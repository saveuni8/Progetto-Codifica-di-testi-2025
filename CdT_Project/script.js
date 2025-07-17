$(document).ready(function() { //funzione di inizializzazione di tutte le altre
        initializeNavigation(); //per configurare menu di navigazione
        setupTextLines(); //per suddividere il testo in righe cliccabili
        initializeHighlighting(); //per impostare l'evidenziazione nel verificare collegamenti testo-immagine
        setupZoneHighlighting(); //per configurare le aree semantiche
        setupFormWork(); //per configurare le funzionalità dei form
        setupReferences(); //per configurare la gestione dei riferimenti
        setupEntityLinks(); //per trasformare i <ref> in link cliccabili per entità
        setupColumnBreaks(); //per gestire le interruzioni di colonna e di pagina

        //Smooth scroll: previene salto brutale quando si clicca un collegamento anchor, e applica offset di 70px
        $('a[href^="#"]').not('.entity-link, .note-ref').on('click', function(event) {
            event.preventDefault();
            var target = $(this.hash);
            if (target.length) {
                $('html, body').scrollTop(target.offset().top - 70);
            }
        });
        
        setTimeout(resizeZones, 300);
        $(window).on('load', function() {
            resizeZones(); //ricalcola il layout (con setTimeout e al caricamento finestra) per regolare dimensioni e posizionamento degli elementi interattivi
        });
    });

    // Converte il contenuto TEI in righe di testo cliccabili
    function setupTextLines() {
        $('.text-paragraph, .list-item, p, .article-body > *, .text-column > *, .tei-list li, li').each(function() {
            const container = $(this); 
            
            if (container.hasClass('processed-lines') || container.hasClass('line-break') || container.hasClass('text-line')) {
                return;
            }
            
            container.addClass('processed-lines');
            processContainerLines(container); //chiamo la funzione che processa il contenuto del contenitore per trasformarlo in righe testuali
        });
        
        $('.column-break, .page-break').each(function() {
            if (!$(this).hasClass('text-line')) {
                $(this).addClass('text-line');
            } //le interruzioni di colonna e di pagina sono contrassegnate come text line cioè parte del flusso testuale
        });
        
        $('.fw').each(function() {
            if (!$(this).hasClass('text-line') && !$(this).hasClass('processed-lines')) {
                $(this).addClass('text-line processed-lines');
            }
        }); //le intestazioni sono definite come righe autonome per poterle evidenziare o cliccare
    }
    
    // Elabora un singolo container dividendolo in righe basandosi sui line breaks TEI
    function processContainerLines(container) {
        const lineBreaks = container.find('lb, .line-break');
        //console.log('Contenitore: ', container); //Debug
        
        if (lineBreaks.length === 0) {
            container.addClass('text-line');
            const id = container.attr('id');
            if (!id) {
                container.attr('id', 'line-' + generateUniqueId());
            }
            return;
        }
        
        const containerId = container.attr('id') || 'container-' + generateUniqueId();
        const originalContent = container.html();
        const tempContainer = $('<div>').html(originalContent);
        
        let lineNumber = 1;
        tempContainer.find('lb, .line-break').each(function() {
            const lb = $(this);
            // Il nuovo ID della linea (se non esiste, lo generiamo)
            const lbId = lb.attr('id') || `${containerId}-lb-${lineNumber}`;
            
            // Se l'attributo data-break==="no", allora mettiamo un trattino
            let markerHtml = `<span class="line-marker" data-line-id="${lbId}"></span>`;
            if (lb.attr('data-break') === 'no') {
                markerHtml = '-' + markerHtml;
            }
            
            lb.before(markerHtml);
            lineNumber++;
        });
        
        const htmlWithMarkers = tempContainer.html();
        // dividiamo lo span che abbiamo inserito: <span class="line-marker"…></span>
        const parts = htmlWithMarkers.split(/<span class="line-marker"[^>]*><\/span>/);
        
        container.empty();
        
        parts.forEach((part, index) => {
            if (part.trim()) {
                // Cerchiamo l'ID del <span class="line-break"> o del <lb> (se presente) nella parte di HTML
                const lbMatch = part.match(/<(?:lb|span[^>]*class="line-break"[^>]*)\s+id="([^"]+)"/);
                const lineId = lbMatch ? lbMatch[1] : `${containerId}-line-${index + 1}`;
                // Rimuoviamo tutti i tag <lb> e <span class="line-break">...</span>, lasciando intatti eventuali trattini
                const cleanContent = part.replace(/<lb[^>]*>|<span[^>]*class="line-break"[^>]*><\/span>/g, '');
                const line = $(`<div class="text-line" id="${lineId}">${cleanContent}</div>`);
                container.append(line);
            }
        });
        
        container.removeClass('text-paragraph list-item');
        console.log('Processed lines:', lineNumber - 1); // Debug
        return lineNumber - 1; // Restituisco il numero di linee processate
    }
    // Genera ID univoci per elementi che non ne hanno uno
    let idCounter = 0;
    function generateUniqueId() {
        return 'gen-' + Date.now() + '-' + (idCounter++);
    }
    // Gestisce il click tra elementi di testo e zone SVG del facsimile
    function setupZoneHighlighting() {
        $('svg rect').css('pointer-events', 'auto');
        console.log('SVG rect elements:', $('svg rect')); // Debug
        
        $(document).on('click', 'svg rect', function(e) {
            console.log('SVG rect clicked'); // Debug: Log when an SVG rect is clicked
            e.stopPropagation();
            
            const rectClass = $(this).attr('class');
            console.log('Assegnata classe', rectClass); //Debug
            if (!rectClass) return;
            
            const targetElement = findElementById(rectClass);
            
            if (targetElement.length) {
                $('svg rect.selected').removeClass('selected');
                $('.highlight-text').removeClass('highlight-text');
                
                $(this).addClass('selected');
                targetElement.addClass('highlight-text');
                
                scrollToElement(targetElement);
            }
        });
        
        $(document).on('click', '.text-line, .fw, .article-title, .column-break, .page-break', function(e) {
            if ($(e.target).hasClass('note-ref') || $(e.target).closest('.note-ref, .entity-link').length) {
                return;
            }
            
            const elementId = $(this).attr('id');
            if (!elementId) return;
            
            const rect = findRectById(elementId);
            
            if (rect.length) {
                $('svg rect.selected').removeClass('selected');
                $('.highlight-text').removeClass('highlight-text');
                
                $(this).addClass('highlight-text');
                rect.addClass('selected');
                
                scrollToRect(rect);
            }
        });
    }
    // Trova elemento di testo tramite ID 
    function findElementById(id) {
        let element = $(`#${id}`); //quando si utilizza la sintassi dei template literal per interpolare le variabili, non si devono usare le parentesi graffe all'interno della stringa
        console.log('Looking for element with ID:', id, element); // Debug
        if (!element.length) {
            element = $(`.text-line[id="${id}"]`);
        }
        if (!element.length) {
            element = $(`[id="${id}"]`);
        }
        return element;
    }

    // Trova rettangolo SVG tramite ID con strategie multiple di ricerca
    function findRectById(id) {
        let rect = $('rect[id="${id}"]');
        if (!rect.length) {
            rect = $('rect[id*="${id}"]');
        }
        return rect;
    }

    // Scrolla la pagina per rendere visibile un elemento di testo
    function scrollToElement(element) {
        const container = element.closest('.text-column');
        if (!container.length) return;

        const containerTop = container.offset().top;
        const elementTop = element.offset().top;
        const scrollTop = elementTop - containerTop + container.scrollTop();

        container.animate({
            scrollTop: scrollTop
        }, 300);
    }


    // Scrolla il container del facsimile per rendere visibile un rettangolo SVG
    function scrollToRect(rect) {
        const container = rect.closest('.facsimile-container');
        if (!container.length) return;

        const containerTop = container.offset().top;
        const rectTop = rect.offset().top;
        const scrollTop = rectTop - containerTop + container.scrollTop();

        container.animate({
            scrollTop: scrollTop
        }, 300);
    }


    //Verifica se la riga cliccata è visibile all'utente nell'immagine senza dover scorrere la pagina
    function isElementInViewport(el) {
        const rect = el.getBoundingClientRect(); //restituisce un oggetto DOMRect che fornisce informazioni sulla dimensione di un elemento e sulla sua posizione relativa alla finestra di visualizzazione (viewport). Come rect ha proprietà top, left, bottom, right, width, e height, che rappresentano le coordinate dell'elemento rispetto alla finestra di visualizzazione.
        const container = el.closest('.text-column, .facsimile-column');
        if (!container) return false;

        const containerRect = container[0].getBoundingClientRect();

        return (
            rect.top >= containerRect.top &&
            rect.left >= containerRect.left &&
            rect.bottom <= containerRect.bottom &&
            rect.right <= containerRect.right
        ); //se true elemento è completamente visibile nel contenitore
    } 

    // Gestisce il menu di navigazione principale e la navigazione tra sezioni
    function initializeNavigation() {
        $('#navigation-fab button').on('click', function(event) {
            $('.navigation-dropdown').toggleClass('active');
            event.stopPropagation();
        });
        
        $('.navigation-dropdown').on('click', function(event) {
            event.stopPropagation();
        });
        
        $('.section-link').on('click', function(event) {
            event.preventDefault();
            
            var targetId = $(this).attr('href');
            
            if (targetId === '#document-info' || targetId === '#people-section' || 
                targetId === '#places-section' || targetId === '#glossary-section') {
                
                $('.visible-section').removeClass('visible-section').addClass('hidden-section');
                $('#info-section').removeClass('hidden-section').addClass('visible-section');
                
                setTimeout(function() {
                    var target = $(targetId);
                    if (target.length) {
                        $('html, body').scrollTop(target.offset().top - 70);
                    }
                }, 100);
            } else {
                var sectionId = targetId + '-section';
                
                $('.visible-section').removeClass('visible-section').addClass('hidden-section');
                $(sectionId).removeClass('hidden-section').addClass('visible-section');
                
                $('html, body').scrollTop(0);
            }
            
            $('.navigation-dropdown').removeClass('active');
        });
        
        $('#back-fab button, #forward-fab button').on('click', function() {
            var sections = $('.article-section, #info-section');
            var visibleSection = $('.visible-section');
            var currentIndex = sections.index(visibleSection);
            var newIndex;
            
            if ($(this).parent().attr('id') === 'back-fab') {
                newIndex = (currentIndex - 1 + sections.length) % sections.length;
            } else {
                newIndex = (currentIndex + 1) % sections.length;
            }
            
            visibleSection.removeClass('visible-section').addClass('hidden-section');
            sections.eq(newIndex).removeClass('hidden-section').addClass('visible-section');
            
            $('html, body').scrollTop(0);
        });
    }

    // Verifica i collegamenti tra elementi di testo e rettangoli SVG
    function initializeHighlighting() {
        setTimeout(function() {
            $('.text-line, .fw, .article-title, .column-break, .page-break').each(function() {
                const id = $(this).attr('id');
                if (id) {
                    const rect = $(`rect[class="${id}"]`);
                }
            });
        }, 100);
    }

    //Gestisce il click sugli elementi del menu a tendina e mostra solo il glossario associato al testo selezionato
    $(document).ready(function() {
        $('.section-link').click(function(e) {
            e.preventDefault();

            // Nascondi tutti i glossari
            $('.glossary-group').hide();

            // Ottieni l'ID del glossario associato al link cliccato
            var glossaryId = $(this).data('glossary-id');

            // Mostra solo il glossario associato
            $('#' + glossaryId).show();
        });
    });


    // Gestisce i click sui link delle entità (persone, luoghi, termini) per mostrare popup 
    function setupEntityLinks() {
        $(document).on('click', '.entity-link', function(e) {
            e.preventDefault();
            
            const targetId = $(this).attr('href');
            let targetElement;
            
            const personIds = [
                '#D_Alighieri', '#A_Aulard', '#Aristotele', '#A_Bahnsen', '#A_Bain', '#J_Bentham', 
                '#F_Boucher', '#G_Carducci', '#E_Caro', '#L_Carrau', '#C_Darwin', 
                '#E_De_Amicis', '#J_M_De_Maistre', '#A_De_Saint_Beuve', '#R_Descartes', '#E_Fouillee', 
                '#J_Fraunstadt', '#G_Garibaldi', '#T_Gautier', '#H_Heine', '#K_Hillebrand', 
                '#V_Hugo', '#G_Leopardi', '#E_Levier', '#E_M_Littre', '#E_Magitot', 
                '#P_Mantegazza', '#A_Manzoni', '#Pio_IX', '#J_S_Mill', '#A_F_Mummery', 
                '#E_Panzacchi', '#Prometeo', '#J_E_Reclus', '#A_Rivaroli', '#H_Schaafhausen', 
                '#A_Schopenhauer', '#H_Spencer', '#H_A_Taine', '#W_Taubert', '#L_Vanderkindere', 
                '#E_v_Hartmann', '#fratelli_v_Schlegel', '#E_Zola'
            ];
            
            if (targetId && personIds.some(id => targetId.startsWith(id))) {
                targetElement = $(targetId);
                showEntityCard(targetElement, 'person');
                return;
            }
            
            if (targetId && targetId.startsWith('#place-')) {
                targetElement = $(targetId);
                showEntityCard(targetElement, 'place');
                return;
            }
            
            if (targetId) {
                targetElement = $(targetId);
                
                if (targetElement.length && (targetElement.hasClass('glossary-card') || targetElement.closest('#glossary-section').length)) {
                    showEntityCard(targetElement, 'glossary');
                    return;
                }
                
                const glossaryPrefixes = [
                    '#historical-', '#political-', '#religious-', '#educational-',
                    '#banking-', '#discipline-', '#institutions-', '#location-',
                    '#work-', '#royalty-', '#event-', '#org-', '#microfono',
                    '#microscopio', '#concilio', '#amnistia'
                ];
                
                if (glossaryPrefixes.some(prefix => targetId.startsWith(prefix))) {
                    if (targetElement.length) {
                        showEntityCard(targetElement, 'glossary');
                        return;
                    }
                }
            }
            
            if (targetId) {
                targetElement = $(targetId);
                if (targetElement.length) {
                    $('html, body').scrollTop(targetElement.offset().top - 100);
                }
            }
        });
    }

    // Crea e mostra popup con informazioni dettagliate su un'entità
    function showEntityCard(element, type) {
        if (!element.length) {
            return;
        }
        
        let title, content, className;
        
        if (type === 'person') {
            title = element.find('h3').text();
            content = element.find('.person-details').html();
            className = 'persName';
        } else if (type === 'place') {
            title = element.find('h3').text();
            content = element.find('.person-details').html();
            className = 'placeName';
        } else if (type === 'glossary') {
            title = element.find('h4').text();
            content = element.find('.glossary-details').html();
            if (!content) {
                content = element.find('.definition-info').html();
            }
            if (!content) {
                const clonedElement = element.clone();
                clonedElement.find('h3').remove();
                content = clonedElement.html();
            }
            className = 'term';
        }
        
        if (!content) {
            const clonedElement = element.clone();
            clonedElement.find('h3').remove();
            content = clonedElement.html();
        }
        
        $('.entity-overlay').remove();
        
        const overlay = $(`
            <div class="entity-overlay">
                <div class="entity-card">
                    <div class="entity-card-header ${className}">
                        <h3>${title}</h3>
                        <button class="entity-card-close">&times;</button>
                    </div>
                    <div class="entity-card-body">
                        ${content}
                    </div>
                </div>
            </div>
        `);
        
        $('main').append(overlay);
        
        overlay.on('click', function(e) {
            if ($(e.target).is('.entity-overlay') || $(e.target).is('.entity-card-close')) {
                overlay.remove();
            }
        });
        
        $('.entity-card-close').on('click', function() {
            overlay.remove();
        });
    }

    // Gestisce i column break 
    function setupColumnBreaks() {
        $('.column-break').each(function() {
            var columnBreak = $(this);
            var div = columnBreak.closest('.text-div');
            
            div.removeClass('no-column').addClass('multi-column');
        });
    }

    // placeholder per gestione riferimenti
    function setupReferences() {
    }
    // Processa elementi fw (forme work) per intestazioni e piè di pagina, li rende cliccabili con classe text-line 
    function setupFormWork() {
        $('.fw').each(function() {
            const fw = $(this);
            const place = fw.attr('place') || '';
            
            const placeClass = place.replace(/\s+/g, '-');
            if (placeClass) {
                fw.addClass(placeClass);
            }
            
            if (!fw.hasClass('text-line')) {
                fw.addClass('text-line');
            }
        });
    }

    // Ridimensiona le zone SVG quando la finestra cambia dimensioni 
    function resizeZones() {
        $('.page-facsimile').each(function() {
            const container = $(this);
            const img = container.find('.facsimile-image');
            
            const currentWidth = img.width();
            const originalWidth = parseInt(img.attr('width')) || 1000;
            
            const scale = currentWidth / originalWidth;
            
            const svg = container.find('svg');
            if (svg.length) {
                const originalViewBox = svg.attr('viewBox')?.split(',');
                if (originalViewBox) {
                    svg.attr('viewBox', `0,0,${originalViewBox[2]},${originalViewBox[3]}`);
                    svg.attr('width', currentWidth);
                    svg.attr('height', img.height());
                }
            }
        });
    }

    $(window).on('resize', function() {
        resizeZones();
    });

    $(document).on('click', function() {
        $('.navigation-dropdown').removeClass('active');
    });

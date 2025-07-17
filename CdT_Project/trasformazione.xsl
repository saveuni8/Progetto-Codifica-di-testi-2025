<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output method="html" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="expan abbr ex" />

 <xsl:template match="/">
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <link rel="stylesheet" href="style.css" type="text/css"/>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js"></script>
    <script src="script.js"></script>
      <title class="header">
        <xsl:value-of select="//tei:titleStmt/tei:title"/>
      </title>
    </head>
    <body>
    <div class="site">
                <!-- NAVIGAZIONE SUPERIORE - menu a tendina -->
                <div class="top-navigation">
                    <div class="nav-dropdown" id="navigation-fab">
                        <button class="button-33" >
                            <img src="immagini/menu_tend_w.png" alt="Menu" class="icon"/>
                            <span>Vai ai testi e alle altre sezioni...</span>
                        </button>
                        <div class="navigation-dropdown">

                            <!-- SEZIONE INFORMAZIONI -->
                            <div class="dropdown-section">
                                <h3>Informazioni generali</h3>
                                <a href="#document-info" class="section-link">Informazioni sulla codifica</a>
                                <br />
                                <a href="#people-section" class="section-link">Persone menzionate</a>
                                <br />
                                <a href="#places-section" class="section-link">Luoghi menzionati</a>
                                <br />
                                <a href="#glossary-section" class="section-link">Glossario dei termini particolari</a>
                            </div>

                            <!-- SEZIONE ARTICOLI -->
                            <div class="dropdown-section">
                                <h3>Testi codificati</h3>
                                <h4>Articoli</h4>
    <xsl:for-each select="//tei:TEI[@type='article']">
        <a href="#{@xml:id}" class="section-link" data-glossary-id="{@xml:id}_gloss">
            <span class="section-title"><xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></span>
        </a>
        <br />
    </xsl:for-each>
    <h4>Bibliografie</h4>
    <xsl:for-each select="//tei:TEI[@type='bibliography']">
        <a href="#{@xml:id}" class="section-link" data-glossary-id="{@xml:id}_gloss">
            <span class="section-title"><xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></span>
        </a>
        <br />
    </xsl:for-each>
    <h4>Notizie</h4>
    <xsl:for-each select="//tei:TEI[@type='news']">
        <a href="#{@xml:id}" class="section-link" data-glossary-id="{@xml:id}_gloss">
            <span class="section-title"><xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></span>
        </a>
        <br />
    </xsl:for-each>
                            </div>

                            <!-- SEZIONE LINK UTILI -->
                            <div class="dropdown-section">
                                <h3>Link utili</h3>
                                <a href="https://github.com/saveuni8/Progetto-Codifica-di-testi-2025/tree/main/Progetto" class="external-link" target="_blank">
                                    Pagina GitHub del progetto
                                </a>
                                <br />
                                <a href="https://rassegnasettimanale.animi.it" class="external-link" target="_blank">
                                    Sito della rassegna settimanale
                                </a>
                                <br />
                                <a href="https://tei-c.org/guidelines/" class="external-link" target="_blank">
                                    TEI Guidelines
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

      <!--<main class="main">-->
      <!-- SEZIONE INFORMAZIONI GENERALI  -->
                    <section id="info-section" class="general-info visible-section">
                        <div class="main-logo-container">
                            <img src="immagini/logo.png" alt="Logo Rassegna Settimanale" class="main-logo"/>
                        </div>

                        <!-- INFORMAZIONI SUL DOCUMENTO - qui uso apply-templates per processare il teiHeader -->
                        <div id="document-info" class="document-info">
                            <h2>Informazioni sulla codifica</h2>
                            <div class="info-container">
                                <xsl:apply-templates select="/tei:teiCorpus/tei:teiHeader"/>
                            </div>
                        </div>

                        <!-- PERSONE MENZIONATE - applico i template alle persone -->
                        <div id="people-section" class="people-section">
                            <h2>Persone menzionate</h2>
                            <div class="people-grid">
                                <xsl:apply-templates select="/tei:teiCorpus/tei:standOff/tei:listPerson/tei:person"/>
                            </div>
                        </div>

                        <!-- LUOGHI MENZIONATI -->
                        <div id="places-section" class="places-section">
                            <h2>Luoghi menzionati</h2>
                            <div class="people-grid">
                                <xsl:apply-templates select="/tei:teiCorpus/tei:standOff/tei:listPlace/tei:place"/>
                            </div>
                        </div>

                        <!-- GLOSSARIO - termine e definizioni _originariamente qui) -->
                    </section>

                    <!-- SEZIONI DEGLI ARTICOLI  -->
                    <xsl:for-each select="/tei:teiCorpus/tei:TEI">
                        <section class="article-section hidden-section" id="{@xml:id}-section">
                            <article
                                class="document">
                    <!-- HEADER DELL'ARTICOLO con metadati -->
                                <header class="document-header">
                                    <h2 class="title"><xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></h2>

                                    <!-- METADATI DELL'ARTICOLO - informazioni bibliografiche -->
                                    <div class="article-header">
                                        <div class="publication-info">
                                            <div class="publication-info-line">
                                                <strong>Pubblicazione: </strong>
                                                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:title"/>
                                            </div>

                                            <!--Autore testo-->
                                            <div class="publication-info-line">
                                                <strong>Autore: </strong>
                                                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:author"/>
                                            </div>

                                            <!-- Data di pubblicazione se esiste -->
                                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:date">
                                                <div class="publication-info-line">
                                                    <strong>Anno: </strong>
                                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:date"/>
                                                </div>
                                            </xsl:if>

                                            <!-- Volume -->
                                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:biblScope[@unit='volume']">
                                                <div class="publication-info-line">
                                                    <strong>Volume: </strong>
                                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:biblScope[@unit='volume']"/>
                                                </div>
                                            </xsl:if>

                                            <!-- Numero di fascicolo -->
                                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:biblScope[@unit='issue']">
                                                <div class="publication-info-line">
                                                    <strong>Numero fascicolo: </strong>
                                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:biblScope[@unit='issue']"/>
                                                </div>
                                            </xsl:if>
                                            <div class="publication-info-line">
                                                <strong>Pagina/e: </strong>
                                                <xsl:choose>

                                                    <!-- Se c'è n (singola pagina) -->
                                                    <xsl:when test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:biblScope[@unit='page']/@n">
                                                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:biblScope[@unit='page']/@n"/>
                                                    </xsl:when>
            
                                                    <!-- Se ci sono from e to -->
                                                    <xsl:when test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:biblScope[@unit='page']/@from and tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:biblScope[@unit='page']/@to">
                                                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:biblScope[@unit='page']/@from"/>
                                                        <xsl:text>,
                                                        </xsl:text>
                                                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:biblScope[@unit='page']/@to"/>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </div>

                                            <!-- Editore e luogo di pubblicazione -->
                                            <div class="publication-info-line">
                                                <strong>Editore: </strong>
                                                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:publisher"/>
                                            </div>
                                            <div class="publication-info-line">
                                                <strong>Luogo: </strong>
                                                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:pubPlace"/>
                                            </div>

                                            <!-- Opera recensita  -->
                                            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:bibl[@type='reviewed']">
                                                <div class="publication-info-line">
                                                    <strong>Opera recensita: </strong>
                                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:bibl[@type='reviewed']/tei:author/tei:persName"/> (autore),
                                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:bibl[@type='reviewed']/tei:title"/> (titolo)
                                                </div>
                                            </xsl:if>

                                            <!-- Link al PDF originale in nuova pagina-->
                                            <div class="publication-info-line">
                                                <strong>Fonte digitale: </strong>
                                                <a
                                                    href="{tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:edition/@source}" target="_blank">
                                                    Visualizza PDF originale
                                                </a>
                                                <br />
                                                <br />
                                            </div>
                                        </div>


                                        
                                    </div>
                                </header>
<main class="main">
                                <!-- LEGENDA -->
                            <div class="legend">
                                <h3>Legenda</h3>
                                <div class="legend-item">
                                    <span style="color: red; font-weight: 600;">Testo originale non standard (orig)</span>
                                </div>
                                <div class="legend-item">
                                    <span style="color: green; font-weight: 600;">Testo regolare standard (reg)</span>
                                </div>
                                <div class="legend-item">
                                    <span style="color: orangered; font-weight: 600;">Testo originale con errore (sic)</span>
                                </div>
                                <div class="legend-item">
                                    <span style="color: darkgreen; font-weight: 600;">Testo corretto (corr)</span>
                                </div>
                                <div class="legend-item">
                                    <span style="color: darkred; font-weight: 600;">Abbreviazione originale (abbr)</span>
                                </div>
                                <div class="legend-item">
                                    <span style="color: lightgreen; font-weight: 600; text-shadow: -1x -1px 0 #000, 1px -1px 0 #000, -1px 1px 0 #000, 1px 1px 0 #000;">Espansione (expan)</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: yellow;"></span>
                                    <span>Persona reale</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: grey;"></span>
                                    <span>Persona immaginaria</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: #ff86e1;"></span>
                                    <span>Luogo</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: green;"></span>
                                    <span>Data</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: #008040;"></span>
                                    <span>Titolo di un'opera</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: #ffc814;"></span>
                                    <span>Termine filosofico</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: #03a9f4;"></span>
                                    <span>Termine liguistico-letterario</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: #1741feff;"></span>
                                    <span>Aspetto culturale</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: #015a01d3;"></span>
                                    <span>Termine delle scienze dure</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: purple;"></span>
                                    <span>Atteggiamento/comportamento</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: #163c4fff;"></span>
                                    <span>Termine delle scienze sociali</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: aqua;"></span>
                                    <span>Termine geografico</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: #fe9514ff;"></span>
                                    <span>Termine o entità politica</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: #bdff07ff;"></span>
                                    <span>Termine editoriale/giornalistico</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background-color: #fae2b6;"></span>
                                    <span>Altri termini</span>
                                </div>
                                <br />
                                <div class="warning">
                                <h5>Attenzione</h5> 
                                <p>Al click di un <span style="text-decoration: underline;">collegamento ipertestuale</span> relativo a un termine, sotto il testo e la/le immagine/i scorrevoli comparirà la spiegazione annessa. Scorrere la pagina verso il basso per visualizzarla e premere la 'x' per toglierla dalla visualizzazione.</p> 
                                <p>Per un'ottimale visualizzazione, assicurati di tenere testo e immagine nella porzione centrale dello schermo: cliccando infatti una zona di testo nell'immagine, la finestra testuale mostrerà in alto il testo corrispondente </p>
                                </div>
                                <!-- Aggiungi altri elementi della legenda qui -->
                            </div>

                                <!-- CONTENUTO DEL DOCUMENTO - facsimile e testo affiancati -->
                                <div
                                    class="document-content">
                                
                                    <!-- Colonna immagini  -->
                                    <div class="facsimile-column" id="facsimile">
                                        <xsl:apply-templates select="tei:facsimile"/>
                                    </div>

                                    <!-- Colonna testo  -->
                                    <div class="text-column" id="testo">
                                        <xsl:apply-templates select="tei:text"/>
                                    </div>
                                </div>
                            </main>
                          </article>
                        </section>
                    </xsl:for-each>
                <!--</main>-->
                <aside class="sidebar">
          <div id="glossary-section" class="glossary-section">
            <h2>Glossario</h2>
            <div class="people-grid">
              <xsl:for-each select="//tei:list[@type='gloss']">
                <div class="glossary-group" id="{@xml:id}">
                  <xsl:for-each select="tei:label">
                    <div class="glossary-card" id="{tei:term/@xml:id}">
                      <h4>
                        <xsl:value-of select="tei:term"/>
                        <xsl:if test="tei:term/@type">
                          <span class="term-type"> (<xsl:value-of select="tei:term/@type"/>)</span>
                        </xsl:if>
                      </h4>
                      <div class="glossary-details">
                        <p class="definition-info">
                          <xsl:apply-templates select="following-sibling::tei:item[1]/tei:gloss/node()[not(self::tei:ref)]"/> <!--Utilizziamo xsl:apply-templates per selezionare e processare tutti i nodi all'interno di <gloss> che non sono <ref>. Questo ci permette di visualizzare il contenuto del <gloss> senza includere il <ref>.-->
                          <xsl:for-each select="following-sibling::tei:item[1]/tei:gloss/tei:ref">
                            <a href="{@target}" class="entity-link">
                <xsl:value-of select="."/>
            </a>
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
                          </xsl:for-each>
                        </p>
                      </div>
                    </div>
                  </xsl:for-each>
                </div>
              </xsl:for-each>
            </div>
          </div>
        </aside>
        <footer class="footer">
        <img src="immagini/Cc-by.webp"/><img src="immagini/Cc-nc.png"/>Licenza Creative Commons: free by attribution non-commercial
        <p>Saverio Solimani: <a href="mailto:s.solimani1@studenti.unipi.it">s.solimani@studenti.unipi.it</a></p> 
        </footer>      
       </div>
    </body>
   </html>
 </xsl:template>

 <xsl:template match="/tei:teiCorpus/tei:teiHeader">
        <div class="document-metadata">
            <!-- Edizione -->
            <div class="metadata-column">
                <h3>Edizione</h3>
                <div class="edition-info">
                    <p class="edition-title">
                        <xsl:value-of select="tei:fileDesc/tei:editionStmt/tei:edition"/>
                    </p>
                    <div class="respStmt-container">
                        <xsl:for-each select="tei:fileDesc/tei:editionStmt/tei:respStmt">
                            <div class="respStmt">
                                <p class="resp">
                                    <xsl:value-of select="tei:resp"/>
                                </p>
                                <ul class="resp-persons">
                                    <xsl:for-each select="tei:persName">
                                        <li>
                                            <xsl:value-of select="."/>
                                            <xsl:if test="@ref">
                                                (<xsl:value-of select="@ref"/>)
                                            </xsl:if>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </div>
                        </xsl:for-each>
                    </div>
                </div>
            </div>

            <!-- Pubblicazione -->
            <div class="metadata-column">
                <h3>Pubblicazione</h3>
                <div class="publication-info">
                    <ul class="info-list">
                        <li>
                            <strong>Editore: </strong>
                            <xsl:value-of select="tei:fileDesc/tei:publicationStmt/tei:publisher"/>
                        </li>
                        <li>
                            <strong>Data: </strong>
                            <xsl:value-of select="tei:fileDesc/tei:publicationStmt/tei:date"/>
                        </li>
                        <li>
                            <strong>Luogo: </strong>
                            <xsl:value-of select="tei:fileDesc/tei:publicationStmt/tei:pubPlace"/>
                        </li>
                        <li>
                            <strong>Disponibilità: </strong>
                            <xsl:value-of select="tei:fileDesc/tei:publicationStmt/tei:availability/tei:p"/>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Edizione Originale -->
            <div class="metadata-column">
                <h3>Edizione Originale</h3>
                <div class="source-info">
                    <ul class="info-list">
                        <li>
                            <strong>Titolo: </strong>
                            <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:title"/></li>
                        <li>
                            <strong>Data: </strong>
                            <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:date"/></li>
                        <li>
                            <strong>Editore: </strong>
                            <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:publisher[1]"/></li>
                        <li>
                            <strong>Luogo: </strong>
                            <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:pubPlace"/></li>
                        <xsl:if test="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:editor[@role]">
                            <li>
                                <strong>Editori: </strong>
                                <xsl:for-each select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:editor">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="position() != last()">,
                                    </xsl:if>
                                </xsl:for-each>
                            </li>
                        </xsl:if>
                        <xsl:if test="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:note[contains(., 'carta')]">
                            <li>
                                <strong>Note: </strong>
                                <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:note[contains(., 'carta')]"/>
                            </li>
                        </xsl:if>
                        <li>
                            <strong>Lingua: </strong>
                            <xsl:value-of select="//tei:profileDesc/tei:langUsage/tei:language"/>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Pubblicazione Digitale -->
            <div class="metadata-column">
                <h3>Pubblicazione Digitale</h3>
                <div class="source-info">
                    <ul class="info-list">
                        <li>
                            <strong>Editore: </strong>
                            <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:publisher[2]"/>
                        </li>
                        <xsl:if test="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:editor[not(@role)]">
                            <li>
                                <strong>Curatore digitale: </strong>
                                <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:editor[not(@role)]"/>
                            </li>
                        </xsl:if>
                        <xsl:if test="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:ref">
                            <li>
                                <strong>Link: </strong>
                                <a href="{tei:fileDesc/tei:sourceDesc/tei:bibl/tei:ref/@target}">
                                    <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:ref"/>
                                </a>
                            </li>
                        </xsl:if>
                        <xsl:if test="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:funder">
                            <li>
                                <strong>Finanziatori: </strong>
                                <xsl:for-each select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:funder">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="position() != last()">,
                                    </xsl:if>
                                </xsl:for-each>
                            </li>
                        </xsl:if>
                        <xsl:if test="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:note[contains(., 'PDF')]">
                            <li>
                                <strong>Note: </strong>
                                <xsl:value-of select="tei:fileDesc/tei:sourceDesc/tei:bibl/tei:note[contains(., 'PDF')]"/>
                            </li>
                        </xsl:if>
                    </ul>
                </div>
            </div>
        </div>
    </xsl:template>
    <!--Template profileDesc-->
    <xsl:template match="tei:profileDesc">
        <div class="profile-info">
            <ul class="info-list">
                <li>
                    <strong>Data di Creazione: </strong>
                    <xsl:value-of select="tei:creation/tei:date"/>
                </li>
                <li>
                    <strong>Lingua: </strong>
                    <xsl:value-of select="tei:langUsage/tei:language"/>
                </li>
            </ul>
        </div>
    </xsl:template>

    <!-- TEMPLATE PER List PERSON  -->
    <xsl:template match="tei:person">
        <div class="person-card" id="{@xml:id}">
            <h3><xsl:value-of select="tei:persName"/></h3>
            <div
                class="person-details">

                <!-- Informazioni di nascita -->
                <xsl:if test="tei:birth">
                    <p class="birth-info">
                        <strong>Nascita: </strong>
                        <xsl:value-of select="tei:birth/tei:date"/>
                        <xsl:if test="tei:birth/tei:placeName">, <xsl:value-of select="tei:birth/tei:placeName"/>
                        </xsl:if>
                        <xsl:if test="tei:birth/tei:country and tei:birth/tei:country != tei:birth/tei:placeName">, <xsl:value-of select="tei:birth/tei:country"/>
                        </xsl:if>
                    </p>
                </xsl:if>

                <!-- Informazioni di morte -->
                <xsl:if test="tei:death">
                    <p class="death-info">
                        <strong>Morte: </strong>
                        <xsl:value-of select="tei:death/tei:date"/>
                        <xsl:if test="tei:death/tei:placeName">, <xsl:value-of select="tei:death/tei:placeName"/>
                        </xsl:if>
                        <xsl:if test="tei:death/tei:country and tei:death/tei:country != tei:death/tei:placeName">, <xsl:value-of select="tei:death/tei:country"/>
                        </xsl:if>
                    </p>
                </xsl:if>

                <!-- Occupazione -->
                <xsl:if test="tei:occupation">
                    <p class="occupation-info">
                        <strong>Occupazione: </strong>
                        <xsl:value-of select="tei:occupation"/>
                    </p>
                </xsl:if>
            </div>
        </div>
    </xsl:template>

    <!-- TEMPLATE PER PLACE - informazioni su un luogo -->
    <xsl:template match="tei:place">
        <div class="person-card" id="{@xml:id}">
            <h3><xsl:value-of select="tei:placeName"/></h3>
            <div
                class="person-details">

                <!-- Coordinate geografiche -->
                <xsl:if test="tei:location/tei:geo">
                    <p class="geo-info">
                        <strong>Coordinate: </strong>
                        <xsl:value-of select="tei:location/tei:geo"/>
                    </p>
                </xsl:if>

                <!-- Paese -->
                <xsl:if test="tei:country">
                    <p class="country-info">
                        <strong>Paese: </strong>
                        <xsl:value-of select="tei:country"/>
                    </p>
                </xsl:if>

                <!-- Descrizione -->
                <xsl:if test="tei:desc">
                    <p class="desc-info">
                        <strong>Descrizione: </strong>
                        <xsl:value-of select="tei:desc"/>
                    </p>
                </xsl:if>
            </div>
        </div>
    </xsl:template>

    <!-- TEMPLATE PER FACSIMILE - immagini -->
    <xsl:template match="tei:facsimile">
        <div
            class="facsimile-container">

            <!-- Per ogni surface dela pagina -->
            <xsl:for-each select="tei:surface">
                <div
                    class="page-facsimile" id="facsimile-{@xml:id}">

                    <!-- Immagine come sfondo -->
                    <img
                    src="{tei:graphic/@url}" alt="Facsimile page" class="facsimile-image" width="{substring-before(tei:graphic/@width, 'px')}" height="{substring-before(tei:graphic/@height, 'px')}"/>
                    
                    <!-- Definisco un overlay SVG per le zone cliccabili -->
                    <svg
                        class="overlay" xmlns="http://www.w3.org/2000/svg" viewBox="0,0,{substring-before(tei:graphic/@width, 'px')},{substring-before(tei:graphic/@height, 'px')}">
                        
                        <!-- Per ogni zona definita creo un rettangolo-->
                        <xsl:for-each select="tei:zone">
                            <rect x="{@ulx}" y="{@uly}" width="{@lrx - @ulx}" height="{@lry - @uly}" class="{translate(@corresp, '#', '')}"/>
                        </xsl:for-each>
                    </svg>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>

    <!-- TEMPLATE PER TEXT, HEAD E COLONNE E LAYOUT GENERALE  -->
    <xsl:template match="tei:text">
        <div class="text-container">
            <xsl:apply-templates select="tei:body"/>
        </div>
    </xsl:template>
    <xsl:template match="tei:body">
        <div class="article-body">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div">
        <div class="text-div no-column" id="{@xml:id}" data-type="{@type}" data-n="{@n}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--Template per il titolo-->
    <xsl:template match="tei:head">
    <h3 class="article-title" id="{@xml:id}">
        <xsl:apply-templates select="tei:title[@type='main']"/>
        <xsl:if test="tei:title[@type='sub']">
            <br/>
            <span class="subtitle">
                <xsl:apply-templates select="tei:title[@type='sub']"/>
            </span>
        </xsl:if>
        <!-- Se non ci sono title separati, processa tutto -->
        <xsl:if test="not(tei:title)">
            <xsl:apply-templates/>
        </xsl:if>
    </h3>
</xsl:template>

<!-- TEMPLATE PER LB - -->
<xsl:template match="tei:lb">
    <span class="line-break" id="{@xml:id}" data-line-break="true">
        <xsl:if test="@break='no'">
            <xsl:attribute name="data-break">no</xsl:attribute>
        </xsl:if>
    </span>
</xsl:template>

 <!-- TEMPLATE PER P  -->
    <xsl:template match="tei:p">
        <p class="text-paragraph">
            <xsl:apply-templates/>
        </p>
    </xsl:template>


<!-- TEMPLATE PER CB - column break (milestone) -->
    <xsl:template match="tei:cb">
        <div class="column-break" id="{@xml:id}">
            <span class="column-number">Fine colonna
            </span>
        </div>
    </xsl:template>

    <!-- TEMPLATE PER QUOTE - citazioni -->
    <xsl:template match="tei:quote">
        <span class="quote">
            <xsl:if test="@xml:lang">
                <xsl:attribute name="lang">
                    <xsl:value-of select="@xml:lang"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@rend='italic'">
                <xsl:attribute name="style">
                    font-style: italic;
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>

    <!-- TEMPLATE PER FOREIGN - termini in lingua straniera -->
    <xsl:template match="tei:foreign">
        <span class="entity foreign" lang="{@xml:lang}">
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>

    <!-- TEMPLATE PER CHOICE (correzioni, espansioni, eccc.) -->
    <xsl:template match="tei:orig">
    <span class="orig-text" style="color: red;">
        <xsl:apply-templates select="node()"/>
    </span>
</xsl:template>

<xsl:template match="tei:reg">
    <span class="reg-text" style="color: green;">
        <xsl:apply-templates select="node()"/>
    </span>
</xsl:template>

<xsl:template match="tei:sic">
    <span class="sic-text" style="color: orangered;">
        <xsl:apply-templates select="node()"/>
    </span>
</xsl:template>

<xsl:template match="tei:corr">
    <span class="corr-text" style="color: darkgreen;">
        <xsl:apply-templates select="node()"/>
    </span>
</xsl:template>

<xsl:template match="tei:abbr">
    <span class="abbr-text" style="color: darkred;">
        <xsl:apply-templates select="node()"/>
    </span>
</xsl:template>

<xsl:template match="tei:expan">
    <span class="expan-text" style="color: lightgreen; text-shadow:
        -1px -1px 0 #000,
        1px -1px 0 #000,
        -1px 1px 0 #000,
        1px 1px 0 #000;">
        <xsl:apply-templates select="node()"/>
    </span>
</xsl:template>


    <!-- TEMPLATE PER PERSNAME - nomi di persona: gialli se reali grigi se immaginari -->
    <xsl:template match="tei:persName">
    <xsl:choose>
        <xsl:when test="@type = 'imaginary'">
            <span class="entity persName" style="background-color: grey;">
                <xsl:choose>
                    <xsl:when test="@ref">
                        <a href="{@ref}" class="entity-link">
                            <xsl:apply-templates select="node()"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="node()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
        </xsl:when>
        <xsl:otherwise>
            <span class="entity persName" id="{@xml:id}" style="background-color: yellow;">
                <xsl:choose>
                    <xsl:when test="@ref">
                        <a href="{@ref}" class="entity-link">
                            <xsl:apply-templates select="node()"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="node()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>



    <!-- TEMPLATE PER PLACENAME - nomi di luogo -->
    <xsl:template match="tei:placeName">
        <span class="entity placeName" style="background-color: #ff86e1;">
            <xsl:choose>
                <xsl:when test="@ref">
                    <a href="{@ref}" class="entity-link">
                        <xsl:apply-templates select="node()"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="node()"/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <!-- TEMPLATE PER DATE - date -->
    <xsl:template match="tei:date">
        <span
            class="entity date" id="{@xml:id}" style="background-color: green;">
            <xsl:if test="@when">
                <xsl:attribute name="data-when">
                    <xsl:value-of select="@when"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>

    <!--TEMPLATE PER titoli opere _non articoli -->
    <xsl:template match="tei:bibl//tei:title">
     <span class="w_title" style="background-color: #008040;">
      <xsl:if test="@rend='italic'">
       <xsl:attribute name="style">
        font-style: italic;
       </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
     </span>
    </xsl:template>

    <!-- TEMPLATE PER TERM - termini tecnici -->
    <xsl:template match="tei:term">
    <xsl:variable name="term-type" select="@type"/>
    <span class="term">
            <a href="{@ref}" class="entity-link">
                <xsl:attribute name="style">
                    <xsl:choose>
                        <xsl:when test="$term-type = 'philosophy'">background-color: #ffc814;</xsl:when>
                        <xsl:when test="$term-type = 'literature-linguistics'">background-color: #03a9f4;</xsl:when>
                        <xsl:when test="$term-type = 'culture'">background-color: #1741feff;</xsl:when>
                        <xsl:when test="$term-type = 'science'">background-color: #015a01d3;</xsl:when>
                        <xsl:when test="$term-type = 'behaviour'">background-color: purple;</xsl:when>
                        <xsl:when test="$term-type = 'social-sciences'">background-color: #163c4fff;</xsl:when>
                        <xsl:when test="$term-type = 'geography'">background-color: aqua;</xsl:when>
                        <xsl:when test="$term-type = 'politics'">background-color: #fe9514ff;</xsl:when>
                        <xsl:when test="$term-type = 'publishing'">background-color: #bdff07ff;</xsl:when>
                        <xsl:otherwise>background-color: #fae2b6;</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:apply-templates select="node()"/>
            </a>
    </span>
</xsl:template>
    
    <!-- Template per le liste -->
    <xsl:template match="tei:list[@type='unordered']">
    <ul>
        <xsl:apply-templates select="node()"/>
    </ul>
</xsl:template>

    <!--TEMPLATE PER RS - nazionalità-->
    <xsl:template match="tei:rs">
     <span class="rs">
      <xsl:attribute name="style">
       <xsl:choose>
        <xsl:when test="@type='nationality'">background-color: orange;</xsl:when>
        <xsl:when test="@type='ancientCivilization'">background-color: blue;</xsl:when>
        <xsl:otherwise>background-color: white;</xsl:otherwise>
       </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="node()"/>
     </span>
    </xsl:template>


    <!-- TEMPLATE PER ORGNAME - nomi di organizzazioni -->
    <xsl:template match="tei:orgName">
        <span class="entity orgName" style="background-color: amaranth;">
            <xsl:if test="@type">
                <xsl:attribute name="data-type">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>

    <!-- TEMPLATE PER REF  -->
    <xsl:template match="tei:ref">
        <a href="{@target}" class="entity-link">
            <xsl:apply-templates select="node()"/>
        </a>
    </xsl:template>
    
    <!-- TEMPLATE PER FW (intestazioni) -->
    <xsl:template match="tei:fw">
        <div class="fw" id="{@xml:id}" data-place="{@place}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- TEMPLATE PER SEPARATOR -->
    <xsl:template match="tei:milestone[@rend]">
        <hr class="milestone {translate(@unit, ' ', '-')}" id="{@xml:id}"/>
    </xsl:template>

    </xsl:stylesheet>

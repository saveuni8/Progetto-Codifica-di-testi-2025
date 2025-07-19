# Progetto-Codifica-di-testi-2025
Progetto di codifica realizzato da Saverio Solimani per il corso di Codifica di Testi a.a. 2024-25 della LT di Informatica Umanistica.  

Il progetto prevede la codifica di due articoli, due entrate della sezione bibliografia e due entrate della sezione notizie de "La rassegna settimanale di politica, scienze, lettere ed arti".

Testi selezionati: 
-articolo pp. 34-35, volume 3, fascicolo 54 
-articolo pp. 113.114, volume 3, fascicolo 69 
-1a entrata "Bibliografie" p. 97, volume 3, fascicolo 57 
-1a entrata "Bibliografie" p. 194, volume 3, fascicolo 62 
-entrata Academy "Notizie", volume 3, fascicolo 53  
-entrata Atenœum Belge "Notizie", volume 3, fascicolo 60. 

File XML convalidato con Xerces (java -cp Xerces\xerces-2_12_2-xml-schema-1.1\* dom.Counter -v progetto.xml) e trasformato in HTML con Saxon (java -cp SaxonHE12-5J\* net.sf.saxon.Transform -s:progetto.xml -xsl:trasformazione.xsl -o:output.html).

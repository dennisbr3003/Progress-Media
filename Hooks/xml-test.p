/* buffer definities */

DEFINE BUFFER q-vord   FOR vord.
DEFINE BUFFER buf-vord FOR vord.

/* variabele declaraties */

DEFINE VARIABLE cTargetType     AS CHARACTER NO-UNDO. 
DEFINE VARIABLE cFile           AS CHARACTER NO-UNDO. 
DEFINE VARIABLE lFormatted      AS LOGICAL NO-UNDO. 
DEFINE VARIABLE cEncoding       AS CHARACTER NO-UNDO. 
DEFINE VARIABLE cSchemaLocation AS CHARACTER NO-UNDO. 
DEFINE VARIABLE lWriteSchema    AS LOGICAL NO-UNDO. 
DEFINE VARIABLE lMinSchema      AS LOGICAL NO-UNDO. 
DEFINE VARIABLE retOK           AS LOGICAL NO-UNDO. 
DEFINE VARIABLE lSeperate       AS LOGICAL NO-UNDO INIT FALSE.

/* dataset definiteis */

DEFINE TEMP-TABLE tmp-vord NO-UNDO LIKE vord
  FIELD afle-adres1 AS CHARACTER
  FIELD afle-adres2 AS CHARACTER
  FIELD afle-adres3 AS CHARACTER
  FIELD afle-adres4 AS CHARACTER
  FIELD afle-adres5 AS CHARACTER. /* extra defenities om array velden op te vangen */
  
DEFINE TEMP-TABLE tmp-vreg NO-UNDO LIKE vreg
  FIELD omsc1 AS CHARACTER
  FIELD omsc2 AS CHARACTER
  FIELD omsc3 AS CHARACTER
  FIELD omsc4 AS CHARACTER. /* extra defenities om array velden op te vangen */
  
DEFINE TEMP-TABLE tmp-vbew NO-UNDO LIKE vbew.

/* dataset relaties */

DEFINE DATASET dsetVord FOR tmp-vord, tmp-vreg, tmp-vbew
    DATA-RELATION drvordnr FOR tmp-vord, tmp-vreg
        RELATION-FIELD (c-firm, c-firm, c-vordnr, c-vordnr) NESTED
    DATA-RELATION drvregnr FOR tmp-vreg, tmp-vbew
        RELATION-FIELD (c-firm, c-firm, c-vordnr, c-vordnr, c-vregnr, c-vregnr) NESTED.

/* query voor vullen indien lSeperate = FALSE */

DEFINE QUERY qvord FOR q-vord.

/* dataset datasources */

DEFINE DATA-SOURCE ds-qvord  FOR QUERY qvord. /* lSeperate = TRUE */
DEFINE DATA-SOURCE ds-vord   FOR vord.        /* lSeperate = FALSE */
DEFINE DATA-SOURCE ds-vreg   FOR vreg.
DEFINE DATA-SOURCE ds-vbew   FOR vbew.

/* datasources koppelen, afhankelijk van de lSeperate wordt tmp-vord
   gevuld vanuit de tabel of vanuit de query */

IF lSeperate THEN
   BUFFER tmp-vord:ATTACH-DATA-SOURCE(DATA-SOURCE ds-vord:HANDLE,?,?).
ELSE
   BUFFER tmp-vord:ATTACH-DATA-SOURCE(DATA-SOURCE ds-qvord:HANDLE,?,?).   
   
BUFFER tmp-vreg:ATTACH-DATA-SOURCE(DATA-SOURCE ds-vreg:HANDLE,?,?).
BUFFER tmp-vbew:ATTACH-DATA-SOURCE(DATA-SOURCE ds-vbew:HANDLE,?,?).
   

/* eenmalig zetten */

ASSIGN cTargetType = "file" 
       lFormatted = YES 
       cEncoding = ? 
       cSchemaLocation = ? 
       lWriteSchema = NO 
       lMinSchema = NO.  
              
IF lSeperate 
THEN DO:

    /* bovenliggende hoofdquery */

    FOR EACH buf-vord 
       WHERE buf-vord.c-firm = 10 
         AND buf-vord.c-vordnr >= 202669 
         AND buf-vord.c-vordnr <= 202671 NO-LOCK:  
    
       /* bestandnaam per order zetten */
    
       ASSIGN cFile = "c:\" + STRING(buf-vord.c-vordnr) + ".xml".
    
       DATA-SOURCE ds-vord:FILL-WHERE-STRING = "WHERE vord.c-firm = 10 AND vord.c-vordnr = " + STRING(buf-vord.c-vordnr). 
    
       DATASET dsetVord:EMPTY-DATASET().
    
       DATASET dsetVord:FILL.
      
       /* array velden vindt Crystal niet zo leuk */
      
       FOR EACH tmp-vord EXCLUSIVE-LOCK:
          ASSIGN tmp-vord.afle-adres1 = tmp-vord.afle-adres[1]
                 tmp-vord.afle-adres2 = tmp-vord.afle-adres[2]
                 tmp-vord.afle-adres3 = tmp-vord.afle-adres[3]
                 tmp-vord.afle-adres4 = tmp-vord.afle-adres[4]
                 tmp-vord.afle-adres5 = tmp-vord.afle-adres[5].
       END.
       FOR EACH tmp-vreg EXCLUSIVE-LOCK:
          ASSIGN tmp-vreg.omsc1 = tmp-vreg.omsc[1]
                 tmp-vreg.omsc2 = tmp-vreg.omsc[2]
                 tmp-vreg.omsc3 = tmp-vreg.omsc[3]
                 tmp-vreg.omsc4 = tmp-vreg.omsc[4].
       
       END.
      
      
       retOK = DATASET dsetVord:WRITE-XML(cTargetType, 
                                          cFile, 
                                          lFormatted, 
                                          cEncoding, 
                                          cSchemaLocation, 
                                          lWriteSchema, 
                                          lMinSchema). 
                                       
    END.                                 
    
END.      
ELSE DO:

    /* bestandnaam een keer zetten */
    
    ASSIGN cFile = "c:\orders.xml".

    QUERY qvord:QUERY-PREPARE("FOR EACH q-vord WHERE q-vord.c-firm = 10 AND q-vord.c-vordnr >= 202669 AND q-vord.c-vordnr <= 202671"). 
               
    DATASET dsetVord:FILL.
    
    /* array velden vindt Crystal niet zo leuk */
          
    FOR EACH tmp-vord EXCLUSIVE-LOCK:
      ASSIGN tmp-vord.afle-adres1 = tmp-vord.afle-adres[1]
             tmp-vord.afle-adres2 = tmp-vord.afle-adres[2]
             tmp-vord.afle-adres3 = tmp-vord.afle-adres[3]
             tmp-vord.afle-adres4 = tmp-vord.afle-adres[4]
             tmp-vord.afle-adres5 = tmp-vord.afle-adres[5].
    END.
    FOR EACH tmp-vreg EXCLUSIVE-LOCK:
      ASSIGN tmp-vreg.omsc1 = tmp-vreg.omsc[1]
             tmp-vreg.omsc2 = tmp-vreg.omsc[2]
             tmp-vreg.omsc3 = tmp-vreg.omsc[3]
             tmp-vreg.omsc4 = tmp-vreg.omsc[4].
       
    END.
              
    retOK = DATASET dsetVord:WRITE-XML(cTargetType, 
                                       cFile, 
                                       lFormatted, 
                                       cEncoding, 
                                       cSchemaLocation, 
                                       lWriteSchema, 
                                       lMinSchema).                                    
    
END.




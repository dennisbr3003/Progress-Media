 /*------------------------------------------------------------------------
    File        : lib.media2015
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Dennis Brink
    Created     : Thu Jun 05 21:54:13 CEST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

  DEF VAR hServerHandle AS HANDLE NO-UNDO. 
  DEF VAR cTempDir AS CHAR NO-UNDO. 
  DEF VAR lMediaServerRemote AS LOG NO-UNDO.
   
  RUN libMedia2015.connectAppServer(INPUT "APPSERVER":U, OUTPUT hServerHandle, OUTPUT lMediaServerRemote).
  RUN libMedia2015.setTempDirectory(INPUT "STARTUP").

FUNCTION getServerHandle RETURNS HANDLE 
	(  ) FORWARD.

FUNCTION getTempDir RETURNS CHARACTER 
	(  ) FORWARD.

FUNCTION verifyPath RETURNS CHARACTER 
	(INPUT picPath AS CHAR) FORWARD.

/* **********************  Internal Procedures  *********************** */

PROCEDURE libMedia2015.connectAppServer:
/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/

    DEF INPUT PARAM picIniSectie AS CHAR NO-UNDO.
    DEF OUTPUT PARAM pohAppSrv AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM polAppSrvRemote AS LOG NO-UNDO.

    DEF VAR cHostName       AS CHAR NO-UNDO.
    DEF VAR cPortNumber     AS CHAR NO-UNDO.
    DEF VAR cAppServiceName AS CHAR NO-UNDO.
    DEF VAR cSessionModel   AS CHAR NO-UNDO.
    DEF VAR cConnectString  AS CHAR NO-UNDO.

    GET-KEY-VALUE SECTION picIniSectie KEY "HostName":U VALUE cHostName.
    GET-KEY-VALUE SECTION picIniSectie KEY "PortNumber":U VALUE cPortNumber.
    GET-KEY-VALUE SECTION picIniSectie KEY "AppServiceName":U VALUE cAppServiceName.
    GET-KEY-VALUE SECTION picIniSectie KEY "SessionModel":U VALUE cSessionModel.
    /* Eerst checken of de handle al beschikbaar is */
    IF VALID-HANDLE(pohAppSrv) AND NOT pohAppSrv = SESSION THEN DO:
      IF pohAppSrv:CONNECTED() THEN
        RETURN.
    END.  
    /* controleren connectie parameters uit ini */
    
    /*
    MESSAGE cHostName SKIP cPortNumber SKIP cAppServiceName SKIP cSessionModel VIEW-AS ALERT-BOX.
    */
    
    IF cHostName = "":U OR cPortNumber = "":U OR cAppServiceName = "":U OR cHostName = ? OR cPortNumber = ? OR cAppServiceName = ? THEN DO:
      ASSIGN pohAppSrv = SESSION.
      RETURN.
    END.  
    ASSIGN cConnectString = 
      "-AppService ":U + cAppServiceName + " " + "-H ":U + cHostName + " " + "-S ":U + cPortNumber + 
      (IF (cSessionModel = "" OR cSessionModel = ?) THEN "" ELSE " -sessionModel ":U + cSessionModel).
    IF NOT VALID-HANDLE(pohAppSrv) OR pohAppSrv:TYPE <> "Server":U THEN
      CREATE SERVER pohAppSrv.
    IF NOT pohAppSrv:CONNECTED() THEN DO:
      ASSIGN polAppSrvRemote = pohAppSrv:CONNECT(cConnectString) NO-ERROR.
      IF NOT polAppSrvRemote THEN 
        ASSIGN pohAppSrv = SESSION. 
    END.  
    
    IF pohAppSrv = SESSION THEN
      MESSAGE "Appserver niet geconnecteerd, geen remote sessie geinitieerd" VIEW-AS ALERT-BOX.           
    /*      
    ELSE
      MESSAGE "Appserver geconnecteerd, remote sessie geinitieerd " + pohAppSrv:CLIENT-CONNECTION-ID VIEW-AS ALERT-BOX.
    */
    RETURN.
    
END PROCEDURE.

PROCEDURE libMedia2015.setTempDirectory:
/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/
  DEF INPUT PARAM picIniSectie AS CHAR NO-UNDO.

  GET-KEY-VALUE SECTION picIniSectie KEY "TEMPFILES":U VALUE cTempDir.

  cTempDir = verifyPath(cTempDir).

  IF cTempDir = ? THEN cTempDir = "".

END PROCEDURE.

/* ************************  Function Implementations ***************** */

FUNCTION getServerHandle RETURNS HANDLE 
	    (  ):
/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/	

	RETURN hServerHandle.
		
END FUNCTION.

FUNCTION getTempDir RETURNS CHARACTER 
	    (  ):
/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/	
    
    RETURN cTempDir.
		
END FUNCTION.

FUNCTION verifyPath RETURNS CHARACTER 
	    (INPUT picPath AS CHAR ):
/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/	
    DEF VAR lResult AS LOG  NO-UNDO.
    DEF VAR cResult AS CHAR NO-UNDO.
         
    FILE-INFO:FILE-NAME = picPath.

    lResult = (FILE-INFO:FILE-TYPE MATCHES "*D*":U). /* "DRW" mag ook ? */

    IF lResult THEN DO:
      IF SUBSTR(picPath, LENGTH(TRIM(picPath)), 1, "CHARACTER":U) <> "\" THEN
        ASSIGN picPath = picPath + "\":U.
      OUTPUT TO VALUE(picPath + "test.txt":U). 
      PUT UNFORMATTED "Hello World":U.
      OUTPUT CLOSE.
      lResult = (SEARCH(picPath + "test.txt":U) <> ?).
    END.

    IF NOT lResult THEN
      RETURN ERROR.
      
    cResult = picPath.
    
    RETURN cResult.
    
    FINALLY:
      OS-DELETE VALUE(picPath + "test.txt") NO-ERROR.
    END. 
		
END FUNCTION.

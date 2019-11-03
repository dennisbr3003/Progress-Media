
/*------------------------------------------------------------------------
    File        : startMedia.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Thu Jun 04 21:41:56 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

  DEF VAR ghSuperProc AS HANDLE NO-UNDO.  

  IF SEARCH("lib.media2015.r") <> ? OR SEARCH("lib.media2015.p") <> ? THEN DO:
    RUN lib.media2015.p PERSISTENT SET ghSuperProc.    
    SESSION:ADD-SUPER-PROCEDURE(ghSuperProc). 
  END.
  ELSE DO: 
    MESSAGE "Fout!" VIEW-AS ALERT-BOX ERROR TITLE "Error".
    QUIT.
  END.  

  DEF VAR clsLogin AS CLASS Client.login NO-UNDO.
  DEF VAR clsMain AS CLASS Client.main NO-UNDO. 

  clslogin = NEW client.login().

  clslogin:ShowModalDialog().
  
  IF STRING(clsLogin:DialogResult) = STRING(System.Windows.Forms.DialogResult:OK) THEN DO:
    clsMain = NEW client.main(). 
    WAIT-FOR clsMain:ShowDialog().
  END.  
  
  IF VALID-OBJECT(clsLogin) THEN DELETE OBJECT clsLogin.
  IF VALID-OBJECT(clsMain) THEN DELETE OBJECT clsMain.  
  IF VALID-HANDLE(ghSuperProc) THEN SESSION:REMOVE-SUPER-PROC(ghSuperProc).
  IF VALID-HANDLE(ghSuperProc) THEN DELETE OBJECT ghSuperProc. 
  
  QUIT.



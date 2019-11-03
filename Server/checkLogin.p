
/*------------------------------------------------------------------------
    File        : checkLogin.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Thu Jun 04 23:38:42 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

  DEF INPUT  PARAM picUser     AS CHAR NO-UNDO.
  DEF INPUT  PARAM picPassword AS CHAR NO-UNDO.
  DEF OUTPUT PARAM polSucces   AS LOG  NO-UNDO.  
  
  DEF VAR rKey AS RAW NO-UNDO.
  
  ASSIGN polSucces = FALSE.
  
  IF picUser = ? OR picUser = "" THEN  
    RETURN.  
    
  IF picPassword = ? OR picPassword = "" THEN 
    RETURN. 
  
  FIND FIRST CollectionUser WHERE CollectionUser.cUserCode = picUser NO-LOCK NO-ERROR. 
  IF NOT AVAIL CollectionUser THEN 
    RETURN.
    
  rKey = GENERATE-PBE-KEY(picPassword).

  IF NOT(STRING(ENCRYPT(picPassword, rKey)) = CollectionUser.cUserPassword) THEN 
    RETURN.  
  
  ASSIGN polSucces = TRUE. 
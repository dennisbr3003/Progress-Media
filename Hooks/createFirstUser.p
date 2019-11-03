
/*------------------------------------------------------------------------
    File        : createFirstUser.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Fri Jun 05 00:45:06 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/
  
  DEF VAR rKey AS RAW NO-UNDO. 
  
  rKey = GENERATE-PBE-KEY("Admin").
  
  FOR EACH CollectionUser EXCLUSIVE-LOCK:
    DELETE CollectionUser.  
  END.    

  CREATE CollectionUser.
  ASSIGN CollectionUser.cUserCode = "Admin"
         CollectionUser.cUserName = "Dennis Brink"
         CollectionUser.cUserPassword = STRING(ENCRYPT("Admin", rKey)). 
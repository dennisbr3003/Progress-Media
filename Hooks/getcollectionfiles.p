
/*------------------------------------------------------------------------
    File        : getcollectionfiles.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Wed Jan 13 12:01:37 CET 2016
    Notes       :
  ----------------------------------------------------------------------*/

  DEF VAR b AS INT NO-UNDO INIT 0.
  
  {server\CollectionFiles.i}
  
  EMPTY TEMP-TABLE ttCollectionFiles.
  
  FOR EACH CollectionFile NO-LOCK:
    CREATE ttCollectionFiles.    
    BUFFER-COPY CollectionFile TO ttCollectionFiles.
    b = b + 1.
  END.    
  MESSAGE SUBST("copied &1 files", b) VIEW-AS ALERT-BOX.
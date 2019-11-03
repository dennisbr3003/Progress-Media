
/*------------------------------------------------------------------------
    File        : getcollectionfiles.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Wed Jan 13 12:01:37 CET 2016
    Notes       :
  ----------------------------------------------------------------------*/
  /*
  FOR EACH CollectionIndex:
      DELETE CollectionIndex.
      END.
  
  FOR EACH CollectionFileIndex:
      DELETE CollectionFileIndex.
      END.
      
  MESSAGE "emptied index tables " VIEW-AS ALERT-BOX.    
      */
  /*
  DEF VAR b AS INT NO-UNDO.
  FOR EACH Collection NO-LOCK:
    CREATE CollectionIndex.
    BUFFER-COPY Collection TO CollectionIndex.
    ASSIGN b = b + 1.
  END.    
  MESSAGE SUBST("copied &1 collection entries", b) VIEW-AS ALERT-BOX.
  */
  /*
  DEF VAR b AS INT NO-UNDO.
  FOR EACH testtable NO-LOCK:
    ASSIGN b = b + 1.
  END.  
  MESSAGE SUBST("counted &1 file entries", b) VIEW-AS ALERT-BOX.
  */
    DEF VAR b AS INT NO-UNDO.
  FOR EACH testtable NO-LOCK:
    CREATE CollectionFileIndex.
    BUFFER-COPY testtable TO CollectionFileIndex.
    ASSIGN b = b + 1.
  END.    
  MESSAGE SUBST("copied &1 entries", b) VIEW-AS ALERT-BOX.
  
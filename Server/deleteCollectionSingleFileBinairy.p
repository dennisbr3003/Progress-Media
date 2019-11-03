
/*------------------------------------------------------------------------
    File        : deleteCollectionSingleFileBinairy.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Tue Jun 16 22:11:33 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

  DEF INPUT PARAM piiCollectionNumber AS INT NO-UNDO. 
  DEF INPUT PARAM piiFileNameKey AS INT NO-UNDO.
  
  DEF VAR iNumberOfOccurences AS INT NO-UNDO INIT 0.
  DEF BUFFER bufCollectionFile FOR CollectionFileIndex.
  
  /* coll */
  FOR EACH bufCollectionFile WHERE bufCollectionFile.iFileNameKey = piiFileNameKey EXCLUSIVE-LOCK:
    iNumberOfOccurences = iNumberOfOccurences + 1.
  END.       
  
  /* coll */
  FOR EACH bufCollectionFile WHERE bufCollectionFile.iCollectionNumber = piiCollectionNumber 
                               AND bufCollectionFile.iFileNameKey = piiFileNameKey EXCLUSIVE-LOCK:
    DELETE bufCollectionFile.
  END.     
  
  /* blb */
  IF iNumberOfOccurences = 1 THEN DO: /* file not copied to any collection by clipboard */
    FIND CollectionFiles WHERE CollectionFiles.iFileNameKey = piiFileNameKey EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL CollectionFiles THEN 
      DELETE CollectionFiles.
  END.     
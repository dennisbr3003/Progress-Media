
/*------------------------------------------------------------------------
    File        : getClipboard.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Sun Jun 14 17:07:56 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

  DEF INPUT PARAM piiCollectionNumber AS INT NO-UNDO.
  
  FIND CollectionIndex WHERE CollectionIndex.iCollectionNumber = piiCollectionNumber NO-LOCK NO-ERROR. 
  IF AVAIL CollectionIndex THEN DO:
    FOR EACH CollectionClipBoard NO-LOCK:
      IF NOT CAN-FIND(FIRST CollectionFileIndex WHERE CollectionFileIndex.iCollectionNumber = piiCollectionNumber
                                                  AND CollectionFileIndex.iFileNameKey = CollectionClipBoard.iFileNameKey NO-LOCK) THEN DO:     
        CREATE CollectionFileIndex.
        ASSIGN CollectionFileIndex.iCollectionNumber = piiCollectionNumber
               CollectionFileIndex.iFileNameKey = CollectionClipBoard.iFileNameKey
               CollectionFileIndex.cFileName = CollectionClipBoard.cFileName.  
      END.     
    END.      
  END.    
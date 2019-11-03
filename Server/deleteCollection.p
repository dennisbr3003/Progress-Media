
/*------------------------------------------------------------------------
    File        : deleteCollection.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Sun Jun 14 12:14:54 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/
  
  DEF INPUT PARAM piiCollectionNumber AS INT NO-UNDO.
  
  FOR EACH CollectionIndex WHERE CollectionIndex.iCollectionNumber = piiCollectionNumber:
    FOR EACH CollectionFileIndex WHERE CollectionFileIndex.iCollectionNumber = piiCollectionNumber: /* coll */
      RUN server\deleteCollectionSingleFileBinairy.p (INPUT CollectionFileIndex.iCollectionNumber, INPUT CollectionFileIndex.iFileNameKey). /* blb */               
    END.
    DELETE CollectionIndex.   
  END.  
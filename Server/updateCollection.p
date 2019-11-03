
/*------------------------------------------------------------------------
    File        : updateCollection.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Sun Jun 14 15:34:00 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/
  DEF INPUT PARAM piiCollectionNumber AS INT NO-UNDO.
  DEF INPUT PARAM picCollectionName AS CHAR  NO-UNDO.
  
  FIND CollectionIndex WHERE CollectionIndex.iCollectionNumber = piiCollectionNumber EXCLUSIVE-LOCK NO-ERROR.
  IF AVAIL CollectionIndex THEN 
    ASSIGN CollectionIndex.cCollectionName = picCollectionName.
  ELSE
    RETURN ERROR.  

/*------------------------------------------------------------------------
    File        : CollectionSingleFileBinairy.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Tue Jun 09 21:55:50 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

  DEFINE TEMP-TABLE ttCollectionSingleFileBinairy NO-UNDO 
    FIELD iCollectionNumber AS INT
    FIELD cPathAndFileName AS CHAR 
    FIELD blbFile AS BLOB 
    INDEX idxCollectionKey iCollectionNumber.


/*------------------------------------------------------------------------
    File        : CollectionFilesBinairy.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Sat Jun 06 18:21:28 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

  DEFINE TEMP-TABLE ttCollectionFilesBinairy NO-UNDO 
    FIELD iFileNameKey AS INT
    FIELD blbFile AS BLOB 
    INDEX idxFileNameKey iFileNameKey.

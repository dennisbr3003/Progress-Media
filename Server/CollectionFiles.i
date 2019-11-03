
/*------------------------------------------------------------------------
    File        : CollectionFiles.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Sat Jun 06 18:15:27 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/
/*
  DEFINE TEMP-TABLE ttCollectionFiles NO-UNDO 
    FIELD cFileName AS CHAR
    FIELD iFileNameKey AS INT
    FIELD iCollectionNumber AS INT 
    INDEX idxCollectionFileNameKey IS PRIMARY UNIQUE iCollectionNumber iFileNameKey
    INDEX idxFileNameKey iFileNameKey.
*/

  DEFINE TEMP-TABLE ttCollectionFiles NO-UNDO LIKE CollectionFileIndex.
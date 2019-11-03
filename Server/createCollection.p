
/*------------------------------------------------------------------------
    File        : createCollection.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Wed Jun 10 15:29:40 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

  DEF INPUT PARAM picCollectionName AS CHAR NO-UNDO.
  
  DEF VAR iTempKey AS INT NO-UNDO.
  
  FIND LAST CollectionIndex USE-INDEX idxCollectionNumber NO-LOCK.
  IF AVAIL CollectionIndex THEN 
    ASSIGN iTempKey = CollectionIndex.iCollectionNumber + 1.
  ELSE ASSIGN iTempKey = 1.
  
  FIND FIRST CollectionIndex WHERE CollectionIndex.iCollectionNumber = iTempKey NO-LOCK NO-ERROR.
  IF AVAIL CollectionIndex THEN DO:
    MESSAGE "Nieuw collectienummer foutief bepaald, het bepaalde nummer bestaat al".
    RETURN ERROR.   
  END.     
  
  CREATE CollectionIndex.
  ASSIGN CollectionIndex.iCollectionNumber = iTempKey
         CollectionIndex.cCollectionName = picCollectionName.
    

/*------------------------------------------------------------------------
    File        : getGridCollection.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Sat Jun 06 16:00:26 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

  DEF INPUT-OUTPUT PARAMETER DATASET-HANDLE piohDataSetGridCollection.  

  DEF VAR a AS INT NO-UNDO INIT 0.
  DEF VAR b AS INT NO-UNDO INIT 0.
  DEF VAR d AS INT NO-UNDO INIT 0. 

  DEFINE TEMP-TABLE ttCollection NO-UNDO 
    FIELD cCollectionName AS CHAR
    FIELD iCollectionNumber AS INT 
    FIELD iNumberOfCollectionFiles AS INT  
    INDEX idxName IS PRIMARY UNIQUE cCollectionName.

  {server\CollectionFiles.i}

  DEFINE DATASET dsetGridCollection FOR ttCollection, ttCollectionFiles
    DATA-RELATION drCollectionName FOR ttCollection, ttCollectionFiles
        RELATION-FIELD (iCollectionNumber, iCollectionNumber) NESTED.

  EMPTY TEMP-TABLE ttCollection.
  EMPTY TEMP-TABLE ttCollectionFiles.
  
  FOR EACH CollectionIndex NO-LOCK:
    CREATE ttCollection.
    BUFFER-COPY CollectionIndex TO ttCollection.
    a = a + 1.    
  END.     
  MESSAGE SUBST("copied &1 collections", a).
  
  FOR EACH CollectionFileIndex NO-LOCK:
    CREATE ttCollectionFiles.    
    BUFFER-COPY CollectionFileIndex TO ttCollectionFiles.
    b = b + 1.
  END.    
  MESSAGE SUBST("copied &1 single collection files", b).
  
  FOR EACH ttCollection NO-LOCK:
    ASSIGN d = 0. 
    FOR EACH ttCollectionFiles WHERE ttCollectionFiles.iCollectionNumber = ttCollection.iCollectionNumber NO-LOCK:
      ASSIGN d = d + 1.
    END.
    ASSIGN ttCollection.iNumberOfCollectionFiles = d.      
  END.    
  
  piohDataSetGridCollection = DATASET dsetGridCollection:HANDLE. 
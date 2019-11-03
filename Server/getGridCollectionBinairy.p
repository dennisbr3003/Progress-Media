
/*------------------------------------------------------------------------
    File        : getGridCollectionBinairy.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Sat Jun 06 18:12:23 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

  {server/CollectionFilesBinairy.i}
    
  DEF INPUT-OUTPUT PARAM TABLE FOR ttCollectionFilesBinairy.
   
  FIND FIRST ttCollectionFilesBinairy NO-ERROR.
  IF AVAIL ttCollectionFilesBinairy THEN DO:
    FIND FIRST CollectionFiles WHERE CollectionFiles.iFileNameKey = ttCollectionFilesBinairy.iFileNameKey NO-LOCK NO-ERROR.
    IF AVAIL CollectionFiles THEN DO:        
      COPY-LOB FROM CollectionFiles.blbFile TO ttCollectionFilesBinairy.blbFile.
    END.      
  END.    
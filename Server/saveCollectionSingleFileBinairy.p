
/*------------------------------------------------------------------------
    File        : saveCollectionSingleFileBinairy.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Wed Jun 10 14:54:49 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/
  FUNCTION getFileNameFromPath RETURNS CHARACTER 
    (pcFileAndPath AS CHAR) FORWARD.

  {server/CollectionSingleFileBinairy.i}
  
  DEF INPUT-OUTPUT PARAM TABLE FOR ttCollectionSingleFileBinairy.
  
  DEF VAR iTempKey AS INT NO-UNDO.
  DEF VAR cFileName AS CHAR NO-UNDO. 
  
  FIND FIRST ttCollectionSingleFileBinairy NO-ERROR.  
  IF NOT AVAIL ttCollectionSingleFileBinairy THEN 
    RETURN.
    
  FIND CollectionIndex WHERE CollectionIndex.iCollectionNumber = ttCollectionSingleFileBinairy.iCollectionNumber NO-LOCK NO-ERROR.
  IF NOT AVAIL CollectionIndex THEN 
    RETURN.
    
  FIND LAST CollectionFiles USE-INDEX idxFileNameKey NO-LOCK NO-ERROR.
  IF AVAIL CollectionFiles THEN 
    ASSIGN iTempKey = CollectionFiles.iFileNameKey + 1.
  ELSE 
    ASSIGN iTempKey = 1.     
  
  cFileName = getFileNameFromPath(ttCollectionSingleFileBinairy.cPathAndFileName).   

  CREATE CollectionFileIndex.
  ASSIGN CollectionFileIndex.cFileName = cFileName
         CollectionFileIndex.iCollectionNumber = ttCollectionSingleFileBinairy.iCollectionNumber
         CollectionFileIndex.iFileNameKey = iTempKey.
         
  CREATE CollectionFiles.
  ASSIGN CollectionFiles.iFileNameKey = iTempKey.       

  COPY-LOB FROM ttCollectionSingleFileBinairy.blbFile TO CollectionFiles.blbFile.
  
/* ************************  Function Implementations ***************** */
FUNCTION getFileNameFromPath RETURNS CHARACTER 
	    (pcFileAndPath AS CHAR):
/*------------------------------------------------------------------------------
		Purpose:  																	  
		Notes:  																	  
------------------------------------------------------------------------------*/	

DEFINE VARIABLE cFileNameOnly AS CHARACTER NO-UNDO.

    DEF VAR i AS INT NO-UNDO.
    #findFileName:
    DO i = LENGTH(pcFileAndPath) TO 0 BY -1:
      IF SUBSTRING(pcFileAndPath, i, 1) = "\" THEN DO: 
        cFileNameOnly = SUBSTRING(pcFileAndPath, i + 1, (LENGTH(pcFileAndPath) - i)).
        LEAVE #findFileName.
      END.   
    END.    
    RETURN cFileNameOnly.
		
END FUNCTION.

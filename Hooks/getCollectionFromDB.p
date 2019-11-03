/*------------------------------------------------------------------------
    File        : getFilesFromDB.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Mon Oct 28 21:57:31 CET 2013
    Notes       :
  ----------------------------------------------------------------------*/
  
  /* quick-dump */

  DEF VAR iCounter AS INT NO-UNDO INIT 1.
  DEF VAR cTargetPath AS CHAR NO-UNDO INIT "D:\Media\DMP\".
  DEF VAR cTempFileName AS CHAR NO-UNDO.
  DEF VAR cFullTargetName AS CHAR NO-UNDO.
  DEF VAR cLibraryName AS CHAR NO-UNDO INIT "". 
  DEF VAR iCollectionNumber AS INT NO-UNDO INIT 113. 
  
  FOR EACH MediaIndex.CollectionFileIndex WHERE MediaIndex.CollectionFileIndex.iCollectionNumber =  iCollectionNumber NO-LOCK:
      /* iFileNameKey */
      FIND Media2015.CollectionFiles WHERE Media2015.CollectionFiles.iFileNameKey = MediaIndex.CollectionFileIndex.iFileNameKey NO-LOCK NO-ERROR.
      IF AVAIL Media2015.CollectionFiles THEN DO:
        ASSIGN cTempFileName = MediaIndex.CollectionFileIndex.cFileName + "-" + STRING(MediaIndex.CollectionFileIndex.iCollectionNumber) + "." + STRING(iCounter, "999999") + ".jpg".                             
               cFullTargetName = cTargetPath + cTempFileName.
        COPY-LOB FROM Media2015.CollectionFiles.blbFile TO FILE cFullTargetName.  
        ASSIGN iCounter = iCounter + 1.            
      END.      
  END.    
      
  MESSAGE SUBST("In totaal &1 bestanden weggeschreven", iCounter - 1) VIEW-AS ALERT-BOX. 
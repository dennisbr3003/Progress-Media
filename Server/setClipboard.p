
/*------------------------------------------------------------------------
    File        : setClipboard.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Sun Jun 14 16:59:20 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

  DEF INPUT PARAM piiFileNameKey AS INT NO-UNDO.
  DEF INPUT PARAM picFileName AS CHAR NO-UNDO.
  
  MESSAGE piiFileNameKey "/" picFileName.
  
  FIND CollectionClipBoard WHERE CollectionClipBoard.iFileNameKey = piiFileNameKey NO-LOCK NO-ERROR.
  IF NOT AVAIL CollectionClipBoard THEN DO:
    CREATE CollectionClipBoard.
    ASSIGN CollectionClipBoard.iFileNameKey = piiFileNameKey
           CollectionClipBoard.cFileName = picFileName.
  END.
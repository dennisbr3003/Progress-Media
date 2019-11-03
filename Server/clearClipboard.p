
/*------------------------------------------------------------------------
    File        : clearClipboard.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Sun Jun 14 17:02:59 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

  FOR EACH CollectionClipBoard EXCLUSIVE-LOCK:
    DELETE CollectionClipBoard.
  END.     
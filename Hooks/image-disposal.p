
/*------------------------------------------------------------------------
    File        : image-disposal.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Dennis Brink
    Created     : Sun Jun 07 14:29:16 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

  MESSAGE "start" VIEW-AS ALERT-BOX.

  DEF VAR clsCollectionFile AS CLASS System.Drawing.Image.
  
  MESSAGE "start 1" VIEW-AS ALERT-BOX.
  
  clsCollectionFile = System.Drawing.Image:FromFile(SEARCH("d:\temp.tmp")).
  
  MESSAGE "start 2" VIEW-AS ALERT-BOX.
  
  clsCollectionFile:Dispose().

  MESSAGE "start 3" VIEW-AS ALERT-BOX.
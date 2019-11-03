 
 /*------------------------------------------------------------------------
    File        : main
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Dennis Brink
    Created     : Thu Jun 04 01:12:12 CEST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Windows.Form.



CLASS Client.main INHERITS Form: 
	
    DEFINE PRIVATE VARIABLE btnAdd AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE btnAddCollection AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE btnAutoFold AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE btnDelete AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE btnDeleteCollection AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE btnRefresh AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE btnUpdateCollection AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button3 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button2 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button1 AS System.Windows.Forms.Button NO-UNDO.
	DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE gridFilesBindingSource AS Progress.Data.BindingSource NO-UNDO.
    DEFINE PRIVATE VARIABLE gridCollection AS Infragistics.Win.UltraWinGrid.UltraGrid NO-UNDO.
    DEFINE PRIVATE VARIABLE groupBoxFiles AS Infragistics.Win.Misc.UltraGroupBox NO-UNDO.
    DEFINE PRIVATE VARIABLE groupBoxView AS Infragistics.Win.Misc.UltraGroupBox NO-UNDO.

    DEF VAR ghGridCollectionDataset AS HANDLE NO-UNDO.
    DEF VAR ghTTGridCollection AS HANDLE NO-UNDO.     
    DEF VAR clsCollectionFile AS CLASS System.Drawing.Image.
    DEF VAR clsCollectionFile2 AS CLASS System.Drawing.Image.
    DEFINE PRIVATE VARIABLE imageList1 AS System.Windows.Forms.ImageList NO-UNDO.
    DEFINE PRIVATE VARIABLE openFileDialog1 AS System.Windows.Forms.OpenFileDialog NO-UNDO.
    DEFINE PRIVATE VARIABLE statusStrip1 AS System.Windows.Forms.StatusStrip NO-UNDO.
    DEFINE PRIVATE VARIABLE toolStripProgressBar AS System.Windows.Forms.ToolStripProgressBar NO-UNDO.
    DEFINE PRIVATE VARIABLE toolStripFileName AS System.Windows.Forms.ToolStripStatusLabel NO-UNDO.
    DEFINE PRIVATE VARIABLE ultraPictureBox1 AS Infragistics.Win.UltraWinEditors.UltraPictureBox NO-UNDO.
    DEFINE PRIVATE VARIABLE ultraToolTipManager1 AS Infragistics.Win.UltraWinToolTip.UltraToolTipManager NO-UNDO.
    
    DEF PRIVATE VAR lMessageBoxAnswer AS LOGICAL NO-UNDO. 
        
    {server/CollectionFilesBinairy.i}
    {server/CollectionSingleFileBinairy.i}
    
	CONSTRUCTOR PUBLIC main (  ):
		
		
        SUPER().
        
        InitializeComponent().
        initializeGridConnection().
        
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
                

	END CONSTRUCTOR.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btnAdd_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
			
		DEF VAR clsSelectedRows AS Infragistics.Win.UltraWinGrid.SelectedRowsCollection NO-UNDO. 
        DEF VAR clsSelectedRow AS Infragistics.Win.UltraWinGrid.UltraGridRow NO-UNDO.         
        DEF VAR hAppServerHandle AS HANDLE NO-UNDO.                
        DEF VAR FileNameArray AS CLASS "System.String[]" NO-UNDO.
        DEF VAR i AS INT NO-UNDO.
        DEF VAR objDialogResult AS CLASS System.Windows.Forms.DialogResult. 
                      
        clsSelectedRows = THIS-OBJECT:gridCollection:Selected:Rows.
        clsSelectedRow = clsSelectedRows[clsSelectedRows:COUNT - 1]. 
     
        THIS-OBJECT:OpenFileDialog1:Filter = "Images (*.bmp;*.jpg;*.jpeg)|*.bmp;*.jpg;*.jpeg|All files (*.*)|*.*". 
        THIS-OBJECT:openFileDialog1:FileName = "".
     
        IF STRING(clsSelectedRow:Band) = "ttCollection" THEN DO:
          WAIT-FOR THIS-OBJECT:openFileDialog1:ShowDialog() SET objDialogResult.          
          IF STRING(objDialogResult) = STRING(System.Windows.Forms.DialogResult:OK) THEN DO:

            THIS-OBJECT:toolStripProgressBar:Visible = TRUE. 
            THIS-OBJECT:toolStripProgressBar:Minimum = 0.
            THIS-OBJECT:toolStripProgressBar:Maximum = INT(THIS-OBJECT:openfiledialog1:FileNames:Length).
              
            hAppServerHandle = DYNAMIC-FUNCTION("getServerHandle").            
            FileNameArray = NEW "System.String[]" (THIS-OBJECT:openfiledialog1:FileNames:Length).         
            ASSIGN FileNameArray = THIS-OBJECT:openfiledialog1:FileNames.
            
            THIS-OBJECT:toolStripFileName:Image = THIS-OBJECT:imageList1:Images:Item[1].

            DO i = 0 TO (THIS-OBJECT:openfiledialog1:FileNames:Length - 1):        
               EMPTY TEMP-TABLE ttCollectionSingleFileBinairy.                        
               CREATE ttCollectionSingleFileBinairy.
               ASSIGN ttCollectionSingleFileBinairy.iCollectionNumber = INT(UNBOX(clsSelectedRow:Cells["iCollectionNumber"]:Value))
                      ttCollectionSingleFileBinairy.cPathAndFileName = UNBOX(FileNameArray:getValue(i)).
               THIS-OBJECT:toolStripFileName:Text = "  [" + STRING(i + 1) + " of " + STRING(THIS-OBJECT:openfiledialog1:FileNames:Length) + "]   " 
                                                    + ttCollectionSingleFileBinairy.cPathAndFileName.                                
               COPY-LOB FROM FILE UNBOX(FileNameArray:getValue(i)) TO ttCollectionSingleFileBinairy.blbFile.      
               RUN server\saveCollectionSingleFileBinairy.p ON hAppServerHandle (INPUT-OUTPUT TABLE ttCollectionSingleFileBinairy BY-REFERENCE).                  
               THIS-OBJECT:toolStripProgressBar:Value = THIS-OBJECT:toolStripProgressBar:Value + 1.
               PROCESS EVENTS.     
            END.           
          END.            
          THIS-OBJECT:openFileDialog1:Dispose().
		END.

        THIS-OBJECT:toolStripFileName:Text = "".
        THIS-OBJECT:toolStripProgressBar:Visible = FALSE. 
        THIS-OBJECT:toolStripProgressBar:Maximum = 0.      
        
        THIS-OBJECT:toolStripFileName:Image = ?.

        RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btnAddCollection_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		
		DEF VAR cTempCollectionName AS CHAR NO-UNDO.
		DEF VAR clsinputDialog AS CLASS Client.inputDialog NO-UNDO.
		 
		clsInputDialog = NEW Client.inputDialog(). 
		clsInputDialog:TEXT = "Add collection".
		clsInputDialog:ShowModalDialog().		
        IF STRING(clsInputDialog:DialogResult) = STRING(System.Windows.Forms.DialogResult:OK) THEN DO:
          RUN server\createCollection.p ON DYNAMIC-FUNCTION("getServerHandle") (INPUT STRING(UNBOX(clsInputDialog:Tag))).
        END.  				
		IF VALID-OBJECT(clsInputDialog) THEN DELETE OBJECT clsInputDialog.
		
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btnAutoFold_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		
		THIS-OBJECT:gridCollection:Rows:CollapseAll(TRUE).
		clearPicture(). 
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btnDelete_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):

        DEF VAR clsSelectedRows AS Infragistics.Win.UltraWinGrid.SelectedRowsCollection NO-UNDO. 
        DEF VAR clsSelectedRow AS Infragistics.Win.UltraWinGrid.UltraGridRow NO-UNDO. 

        DEF VAR iCounter AS INTEGER NO-UNDO. 
        DEF VAR iNumberOfCollectionFiles AS INTEGER NO-UNDO INIT 0. 

        clsSelectedRows = THIS-OBJECT:gridCollection:Selected:Rows.        
        DO iCounter = 0 TO (clsSelectedRows:COUNT - 1):
          clsSelectedRow = clsSelectedRows[0].
          IF STRING(clsSelectedRow:Band) = "ttCollectionFiles" THEN
            iNumberOfCollectionFiles = iNumberOfCollectionFiles + 1.
        END.    
        
        IF iNumberOfCollectionFiles > 1 THEN DO:
          MESSAGE SUBST("There are &1 collectionsfiles selected are you sure you want to delete them all?", iNumberOfCollectionFiles)
                  VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO TITLE "Warning" UPDATE lMessageBoxAnswer.
          IF NOT lMessageBoxAnswer THEN 
            RETURN.
        END.             
        
        IF clsSelectedRows:COUNT >= 1 THEN DO:        
          clsSelectedRow = clsSelectedRows[0].
          IF STRING(clsSelectedRow:Band) = "ttCollectionFiles" THEN DO:
            DO iCounter = 0 TO (clsSelectedRows:COUNT - 1):
               clsSelectedRow = clsSelectedRows[iCounter].
               RUN server\deleteCollectionSingleFileBinairy.p ON DYNAMIC-FUNCTION("getServerHandle") (INPUT INT(UNBOX(clsSelectedRow:Cells["iCollectionNumber"]:Value)), INPUT INT(UNBOX(clsSelectedRow:Cells["iFileNameKey"]:Value))). 
            END.        
          END.      
        END.
        
        RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btnDeleteCollection_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):

        DEF VAR clsSelectedRows AS Infragistics.Win.UltraWinGrid.SelectedRowsCollection NO-UNDO. 
        DEF VAR clsSelectedRow AS Infragistics.Win.UltraWinGrid.UltraGridRow NO-UNDO. 

        DEF VAR iCounter AS INTEGER NO-UNDO. 
        DEF VAR iNumberOfCollections AS INTEGER NO-UNDO INIT 0. 

        clsSelectedRows = THIS-OBJECT:gridCollection:Selected:Rows.        
        DO iCounter = 0 TO (clsSelectedRows:COUNT - 1):
          clsSelectedRow = clsSelectedRows[0].
          IF STRING(clsSelectedRow:Band) = "ttCollection" THEN
            iNumberOfCollections = iNumberOfCollections + 1.
        END.    
        
        IF iNumberOfCollections > 1 THEN DO:
          MESSAGE SUBST("There are &1 collections selected are you sure you want to delete them all?", iNumberOfCollections)
                  VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO TITLE "Warning" UPDATE lMessageBoxAnswer.
          IF NOT lMessageBoxAnswer THEN 
            RETURN.
        END.             
        
        IF clsSelectedRows:COUNT >= 1 THEN DO:        
          clsSelectedRow = clsSelectedRows[0].
          IF STRING(clsSelectedRow:Band) = "ttCollection" THEN DO:
            DO iCounter = 0 TO (clsSelectedRows:COUNT - 1):
               clsSelectedRow = clsSelectedRows[iCounter].
               RUN server\deleteCollection.p ON DYNAMIC-FUNCTION("getServerHandle") (INPUT INT(UNBOX(clsSelectedRow:Cells["iCollectionNumber"]:Value))). 
            END.        
          END.      
        END.
        
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btnRefresh_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		
        ghGridCollectionDataset:TOP-NAV-QUERY:QUERY-CLOSE().
        ghGridCollectionDataset:EMPTY-DATASET().
		
		RUN server\getGridCollection.p ON DYNAMIC-FUNCTION("getServerHandle") (INPUT-OUTPUT DATASET-HANDLE ghGridCollectionDataset BY-REFERENCE).
		
		ghGridCollectionDataset:TOP-NAV-QUERY:QUERY-OPEN() NO-ERROR. 
		
		THIS-OBJECT:gridFilesBindingSource:Refresh().
		
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btnUpdateCollection_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):

        DEF VAR clsSelectedRows AS Infragistics.Win.UltraWinGrid.SelectedRowsCollection NO-UNDO. 
        DEF VAR clsSelectedRow AS Infragistics.Win.UltraWinGrid.UltraGridRow NO-UNDO. 
               
        clsSelectedRows = THIS-OBJECT:gridCollection:Selected:Rows.
        clsSelectedRow = clsSelectedRows[clsSelectedRows:COUNT - 1]. 

        IF STRING(clsSelectedRow:Band) = "ttCollection" THEN DO:

          DEF VAR clsinputDialog AS CLASS Client.inputDialog NO-UNDO.
         
          clsInputDialog = NEW Client.inputDialog(). 
          clsInputDialog:TEXT = "Update collection".
          clsInputDialog:setInitialValueTextField(STRING(UNBOX(clsSelectedRow:Cells["cCollectionName"]:Value))).
          clsInputDialog:ShowModalDialog().       
          IF STRING(clsInputDialog:DialogResult) = STRING(System.Windows.Forms.DialogResult:OK) THEN DO:
            RUN server\updateCollection.p ON DYNAMIC-FUNCTION("getServerHandle") (INPUT INT(UNBOX(clsSelectedRow:Cells["iCollectionNumber"]:Value)), STRING(UNBOX(clsInputDialog:Tag))).
          END.                
          IF VALID-OBJECT(clsInputDialog) THEN DELETE OBJECT clsInputDialog.
        END.
        RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID button1_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):

        DEF VAR clsSelectedRows AS Infragistics.Win.UltraWinGrid.SelectedRowsCollection NO-UNDO. 
        DEF VAR clsSelectedRow AS Infragistics.Win.UltraWinGrid.UltraGridRow NO-UNDO. 

        DEF VAR i AS INT NO-UNDO. 

        clsSelectedRows = THIS-OBJECT:gridCollection:Selected:Rows.
        IF clsSelectedRows:COUNT >= 1 THEN DO:        
          clsSelectedRow = clsSelectedRows[0].
          IF STRING(clsSelectedRow:Band) = "ttCollectionFiles" THEN DO:
            DO i = 0 TO (clsSelectedRows:COUNT - 1):
               clsSelectedRow = clsSelectedRows[i].
               RUN server\setClipboard.p ON DYNAMIC-FUNCTION("getServerHandle") (INPUT INT(UNBOX(clsSelectedRow:Cells["iFileNameKey"]:Value)), INPUT STRING(UNBOX(clsSelectedRow:Cells["cFileName"]:Value))). 
            END.     	
          END.  	
        END.
        
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID button2_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):

        DEF VAR clsSelectedRows AS Infragistics.Win.UltraWinGrid.SelectedRowsCollection NO-UNDO. 
        DEF VAR clsSelectedRow AS Infragistics.Win.UltraWinGrid.UltraGridRow NO-UNDO. 
               
        clsSelectedRows = THIS-OBJECT:gridCollection:Selected:Rows.
        clsSelectedRow = clsSelectedRows[clsSelectedRows:COUNT - 1]. 

        IF STRING(clsSelectedRow:Band) = "ttCollection" THEN DO:
          MESSAGE SUBST("are you sure you want to copty the clopboard into collection &1, &2?", INT(UNBOX(clsSelectedRow:Cells["iCollectionNumber"]:Value)), STRING(UNBOX(clsSelectedRow:Cells["cCollectionName"]:Value))) VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "Quetsion" UPDATE lAns2 AS LOG.
          IF lAns2 THEN             
            RUN server\getClipboard.p ON DYNAMIC-FUNCTION("getServerHandle") (INPUT INT(UNBOX(clsSelectedRow:Cells["iCollectionNumber"]:Value))).
        END.                
		
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID button3_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):

      RUN server\clearClipboard.p ON DYNAMIC-FUNCTION("getServerHandle"). 	
      RETURN.

	END METHOD.


	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/

	METHOD PRIVATE VOID clearPicture(  ):
		
      THIS-OBJECT:ultraPictureBox1:Image = ?.    
      THIS-OBJECT:toolStripFileName:Text = "".
      THIS-OBJECT:toolStripFileName:image = ?.        
      RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID gridCollection_AfterRowCollapsed( INPUT sender AS System.Object, INPUT e AS Infragistics.Win.UltraWinGrid.RowEventArgs ):

        clearPicture(). 
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID gridCollection_AfterSelectChange( INPUT sender AS System.Object, INPUT e AS Infragistics.Win.UltraWinGrid.AfterSelectChangeEventArgs ):

	    DEF VAR clsSelectedRows AS Infragistics.Win.UltraWinGrid.SelectedRowsCollection NO-UNDO. 
        DEF VAR clsSelectedRow AS Infragistics.Win.UltraWinGrid.UltraGridRow NO-UNDO. 
        
        DEF VAR fs AS CLASS System.IO.FileStream.                  
        DEF VAR cBand AS CHAR NO-UNDO.        
        
        clsSelectedRows = THIS-OBJECT:gridCollection:Selected:Rows.
        
        IF clsSelectedRows:COUNT = 0 THEN DO:
          THIS-OBJECT:clearPicture().   
          RETURN. 
        END.
        
        clsSelectedRow = clsSelectedRows[clsSelectedRows:COUNT - 1]. 

        cBand = STRING(clsSelectedRow:Band).
        
        IF STRING(clsSelectedRow:Band) = "ttCollectionFiles" THEN DO:
          
          EMPTY TEMP-TABLE ttCollectionFilesBinairy.
          CREATE ttCollectionFilesBinairy.
          ASSIGN ttCollectionFilesBinairy.iFileNameKey = INT(UNBOX(clsSelectedRow:Cells["iFileNameKey"]:Value)).
          
          RUN server\getGridCollectionBinairy.p ON DYNAMIC-FUNCTION("getServerHandle") (INPUT-OUTPUT TABLE ttCollectionFilesBinairy BY-REFERENCE).          
          
          FIND FIRST ttCollectionFilesBinairy NO-ERROR. 
          IF AVAIL ttCollectionFilesBinairy THEN DO:
            COPY-LOB FROM ttCollectionFilesBinairy.blbFile TO FILE DYNAMIC-FUNCTION("getTempDir") + "X34E".
            fs = NEW system.io.filestream(DYNAMIC-FUNCTION("getTempDir") + "X34E", System.IO.FileMode:Open, System.IO.FileAccess:Read).            
            THIS-OBJECT:ultraPictureBox1:image = System.Drawing.Image:FromStream(fs).                        
            THIS-OBJECT:toolStripFileName:Text = STRING(UNBOX(clsSelectedRow:Cells["cFileName"]:Value)) + " [" + STRING(System.Drawing.Image:FromStream(fs):HEIGHT) + "x" + STRING(System.Drawing.Image:FromStream(fs):WIDTH) + "]".
            THIS-OBJECT:toolStripFileName:image = THIS-OBJECT:imageList1:Images:Item[0].
            fs:Close().
          END.
          
        END.           
		
		IF STRING(clsSelectedRow:Band) = "ttCollection" THEN DO:
		  clearPicture().		  
		  THIS-OBJECT:toolStripFileName:Text = " [" + STRING(UNBOX(clsSelectedRow:Cells["iCollectionNumber"]:Value)) + "/" + STRING(UNBOX(clsSelectedRow:Cells["iNumberOfCollectionFiles"]:Value)) + "]".
		END. 
		
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID gridCollection_BeforeRowFilterDropDown( INPUT sender AS System.Object, INPUT e AS Infragistics.Win.UltraWinGrid.BeforeRowFilterDropDownEventArgs ):
	   

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID gridCollection_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID gridCollection_ClickCell( INPUT sender AS System.Object, INPUT e AS Infragistics.Win.UltraWinGrid.ClickCellEventArgs ):
		
      IF e:Cell:ROW:IsFilterRow THEN 
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID gridCollection_InitializeLayout( INPUT sender AS System.Object, INPUT e AS Infragistics.Win.UltraWinGrid.InitializeLayoutEventArgs ):
		
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID gridCollection_KeyDown( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.KeyEventArgs ):
		
		IF e:KEYCODE:Equals(System.Windows.Forms.Keys:Escape) THEN DO:
          clearPicture().         
          THIS-OBJECT:toolStripFileName:Text = "Esc".
		END.     
		     
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID groupBoxFiles_KeyDown( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.KeyEventArgs ):
		
		RETURN.

	END METHOD.

	METHOD PRIVATE VOID InitializeComponent(  ):
		
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        THIS-OBJECT:components = NEW System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE resources AS Progress.Util.ResourceManager NO-UNDO.
        resources = NEW Progress.Util.ResourceManager("Client.main").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE ultraToolTipInfo1 AS Infragistics.Win.UltraWinToolTip.UltraToolTipInfo NO-UNDO.
        ultraToolTipInfo1 = NEW Infragistics.Win.UltraWinToolTip.UltraToolTipInfo("Collapse all", Infragistics.Win.ToolTipImage:Default, ?, Infragistics.Win.DefaultableBoolean:Default).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE ultraToolTipInfo2 AS Infragistics.Win.UltraWinToolTip.UltraToolTipInfo NO-UNDO.
        ultraToolTipInfo2 = NEW Infragistics.Win.UltraWinToolTip.UltraToolTipInfo("Delete file(s)", Infragistics.Win.ToolTipImage:Default, "", Infragistics.Win.DefaultableBoolean:Default).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE ultraToolTipInfo3 AS Infragistics.Win.UltraWinToolTip.UltraToolTipInfo NO-UNDO.
        ultraToolTipInfo3 = NEW Infragistics.Win.UltraWinToolTip.UltraToolTipInfo("Empty clipboard", Infragistics.Win.ToolTipImage:Default, ?, Infragistics.Win.DefaultableBoolean:Default).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE ultraToolTipInfo4 AS Infragistics.Win.UltraWinToolTip.UltraToolTipInfo NO-UNDO.
        ultraToolTipInfo4 = NEW Infragistics.Win.UltraWinToolTip.UltraToolTipInfo("Copy clipboard into collection", Infragistics.Win.ToolTipImage:Default, ?, Infragistics.Win.DefaultableBoolean:Default).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE ultraToolTipInfo5 AS Infragistics.Win.UltraWinToolTip.UltraToolTipInfo NO-UNDO.
        ultraToolTipInfo5 = NEW Infragistics.Win.UltraWinToolTip.UltraToolTipInfo("Add to clipboard", Infragistics.Win.ToolTipImage:Default, ?, Infragistics.Win.DefaultableBoolean:Default).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE ultraToolTipInfo6 AS Infragistics.Win.UltraWinToolTip.UltraToolTipInfo NO-UNDO.
        ultraToolTipInfo6 = NEW Infragistics.Win.UltraWinToolTip.UltraToolTipInfo("Update collectioname", Infragistics.Win.ToolTipImage:Default, "", Infragistics.Win.DefaultableBoolean:Default).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE ultraToolTipInfo7 AS Infragistics.Win.UltraWinToolTip.UltraToolTipInfo NO-UNDO.
        ultraToolTipInfo7 = NEW Infragistics.Win.UltraWinToolTip.UltraToolTipInfo("Delete collection", Infragistics.Win.ToolTipImage:Default, "", Infragistics.Win.DefaultableBoolean:Default).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE ultraToolTipInfo8 AS Infragistics.Win.UltraWinToolTip.UltraToolTipInfo NO-UNDO.
        ultraToolTipInfo8 = NEW Infragistics.Win.UltraWinToolTip.UltraToolTipInfo("Refresh collections", Infragistics.Win.ToolTipImage:Default, "", Infragistics.Win.DefaultableBoolean:Default).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE ultraToolTipInfo9 AS Infragistics.Win.UltraWinToolTip.UltraToolTipInfo NO-UNDO.
        ultraToolTipInfo9 = NEW Infragistics.Win.UltraWinToolTip.UltraToolTipInfo("Add collection", Infragistics.Win.ToolTipImage:Default, ?, Infragistics.Win.DefaultableBoolean:Default).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE ultraToolTipInfo10 AS Infragistics.Win.UltraWinToolTip.UltraToolTipInfo NO-UNDO.
        ultraToolTipInfo10 = NEW Infragistics.Win.UltraWinToolTip.UltraToolTipInfo("Add file(s)", Infragistics.Win.ToolTipImage:Default, "", Infragistics.Win.DefaultableBoolean:Default).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE ultraGridBand1 AS Infragistics.Win.UltraWinGrid.UltraGridBand NO-UNDO.
        ultraGridBand1 = NEW Infragistics.Win.UltraWinGrid.UltraGridBand("", -1).
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE appearance1 AS Infragistics.Win.Appearance NO-UNDO.
        appearance1 = NEW Infragistics.Win.Appearance().
        THIS-OBJECT:groupBoxFiles = NEW Infragistics.Win.Misc.UltraGroupBox().
        THIS-OBJECT:btnAutoFold = NEW System.Windows.Forms.Button().
        THIS-OBJECT:btnDelete = NEW System.Windows.Forms.Button().
        THIS-OBJECT:button3 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:button2 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:button1 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:btnUpdateCollection = NEW System.Windows.Forms.Button().
        THIS-OBJECT:btnDeleteCollection = NEW System.Windows.Forms.Button().
        THIS-OBJECT:btnRefresh = NEW System.Windows.Forms.Button().
        THIS-OBJECT:btnAddCollection = NEW System.Windows.Forms.Button().
        THIS-OBJECT:btnAdd = NEW System.Windows.Forms.Button().
        THIS-OBJECT:gridCollection = NEW Infragistics.Win.UltraWinGrid.UltraGrid().
        THIS-OBJECT:gridFilesBindingSource = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
        THIS-OBJECT:groupBoxView = NEW Infragistics.Win.Misc.UltraGroupBox().
        THIS-OBJECT:ultraPictureBox1 = NEW Infragistics.Win.UltraWinEditors.UltraPictureBox().
        THIS-OBJECT:openFileDialog1 = NEW System.Windows.Forms.OpenFileDialog().
        THIS-OBJECT:statusStrip1 = NEW System.Windows.Forms.StatusStrip().
        THIS-OBJECT:toolStripProgressBar = NEW System.Windows.Forms.ToolStripProgressBar().
        THIS-OBJECT:toolStripFileName = NEW System.Windows.Forms.ToolStripStatusLabel().
        THIS-OBJECT:imageList1 = NEW System.Windows.Forms.ImageList(THIS-OBJECT:components).
        THIS-OBJECT:ultraToolTipManager1 = NEW Infragistics.Win.UltraWinToolTip.UltraToolTipManager(THIS-OBJECT:components).
        CAST(THIS-OBJECT:groupBoxFiles, System.ComponentModel.ISupportInitialize):BeginInit().
        THIS-OBJECT:groupBoxFiles:SuspendLayout().
        CAST(THIS-OBJECT:gridCollection, System.ComponentModel.ISupportInitialize):BeginInit().
        CAST(THIS-OBJECT:gridFilesBindingSource, System.ComponentModel.ISupportInitialize):BeginInit().
        CAST(THIS-OBJECT:groupBoxView, System.ComponentModel.ISupportInitialize):BeginInit().
        THIS-OBJECT:groupBoxView:SuspendLayout().
        THIS-OBJECT:statusStrip1:SuspendLayout().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* groupBoxFiles */
        /*  */
        DEFINE VARIABLE nestedvar0 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar0 = CAST(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:groupBoxFiles:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:groupBoxFiles:BorderStyle = Infragistics.Win.Misc.GroupBoxBorderStyle:Header3D.
        THIS-OBJECT:groupBoxFiles:Controls:Add(THIS-OBJECT:btnAutoFold).
        THIS-OBJECT:groupBoxFiles:Controls:Add(THIS-OBJECT:btnDelete).
        THIS-OBJECT:groupBoxFiles:Controls:Add(THIS-OBJECT:button3).
        THIS-OBJECT:groupBoxFiles:Controls:Add(THIS-OBJECT:button2).
        THIS-OBJECT:groupBoxFiles:Controls:Add(THIS-OBJECT:button1).
        THIS-OBJECT:groupBoxFiles:Controls:Add(THIS-OBJECT:btnUpdateCollection).
        THIS-OBJECT:groupBoxFiles:Controls:Add(THIS-OBJECT:btnDeleteCollection).
        THIS-OBJECT:groupBoxFiles:Controls:Add(THIS-OBJECT:btnRefresh).
        THIS-OBJECT:groupBoxFiles:Controls:Add(THIS-OBJECT:btnAddCollection).
        THIS-OBJECT:groupBoxFiles:Controls:Add(THIS-OBJECT:btnAdd).
        THIS-OBJECT:groupBoxFiles:Controls:Add(THIS-OBJECT:gridCollection).
        THIS-OBJECT:groupBoxFiles:Location = NEW System.Drawing.Point(0, 7).
        THIS-OBJECT:groupBoxFiles:Name = "groupBoxFiles".
        THIS-OBJECT:groupBoxFiles:Size = NEW System.Drawing.Size(237, 675).
        THIS-OBJECT:groupBoxFiles:TabIndex = 0.
        THIS-OBJECT:groupBoxFiles:Text = "Files".
        THIS-OBJECT:groupBoxFiles:KeyDown:Subscribe(THIS-OBJECT:groupBoxFiles_KeyDown).
        /*  */
        /* btnAutoFold */
        /*  */
        THIS-OBJECT:btnAutoFold:Image = CAST(resources:GetObject("btnAutoFold.Image"), System.Drawing.Image).
        THIS-OBJECT:btnAutoFold:Location = NEW System.Drawing.Point(164, 19).
        THIS-OBJECT:btnAutoFold:Name = "btnAutoFold".
        THIS-OBJECT:btnAutoFold:Size = NEW System.Drawing.Size(35, 33).
        THIS-OBJECT:btnAutoFold:TabIndex = 10.
        ultraToolTipInfo1:ToolTipText = "Collapse all".
        THIS-OBJECT:ultraToolTipManager1:SetUltraToolTip(THIS-OBJECT:btnAutoFold, ultraToolTipInfo1).
        THIS-OBJECT:btnAutoFold:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btnAutoFold:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btnAutoFold:Click:Subscribe(THIS-OBJECT:btnAutoFold_Click).
        /*  */
        /* btnDelete */
        /*  */
        THIS-OBJECT:btnDelete:Image = CAST(resources:GetObject("btnDelete.Image"), System.Drawing.Image).
        THIS-OBJECT:btnDelete:Location = NEW System.Drawing.Point(41, 58).
        THIS-OBJECT:btnDelete:Name = "btnDelete".
        THIS-OBJECT:btnDelete:Size = NEW System.Drawing.Size(35, 33).
        THIS-OBJECT:btnDelete:TabIndex = 9.
        ultraToolTipInfo2:ToolTipText = "Delete file(s)".
        THIS-OBJECT:ultraToolTipManager1:SetUltraToolTip(THIS-OBJECT:btnDelete, ultraToolTipInfo2).
        THIS-OBJECT:btnDelete:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btnDelete:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btnDelete:Click:Subscribe(THIS-OBJECT:btnDelete_Click).
        /*  */
        /* button3 */
        /*  */
        THIS-OBJECT:button3:Image = CAST(resources:GetObject("button3.Image"), System.Drawing.Image).
        THIS-OBJECT:button3:Location = NEW System.Drawing.Point(164, 58).
        THIS-OBJECT:button3:Name = "button3".
        THIS-OBJECT:button3:Size = NEW System.Drawing.Size(35, 33).
        THIS-OBJECT:button3:TabIndex = 8.
        ultraToolTipInfo3:ToolTipText = "Empty clipboard".
        THIS-OBJECT:ultraToolTipManager1:SetUltraToolTip(THIS-OBJECT:button3, ultraToolTipInfo3).
        THIS-OBJECT:button3:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:button3:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:button3:Click:Subscribe(THIS-OBJECT:button3_Click).
        /*  */
        /* button2 */
        /*  */
        THIS-OBJECT:button2:Image = CAST(resources:GetObject("button2.Image"), System.Drawing.Image).
        THIS-OBJECT:button2:Location = NEW System.Drawing.Point(200, 58).
        THIS-OBJECT:button2:Name = "button2".
        THIS-OBJECT:button2:Size = NEW System.Drawing.Size(35, 33).
        THIS-OBJECT:button2:TabIndex = 7.
        ultraToolTipInfo4:ToolTipText = "Copy clipboard into collection".
        THIS-OBJECT:ultraToolTipManager1:SetUltraToolTip(THIS-OBJECT:button2, ultraToolTipInfo4).
        THIS-OBJECT:button2:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:button2:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:button2:Click:Subscribe(THIS-OBJECT:button2_Click).
        /*  */
        /* button1 */
        /*  */
        THIS-OBJECT:button1:Image = CAST(resources:GetObject("button1.Image"), System.Drawing.Image).
        THIS-OBJECT:button1:Location = NEW System.Drawing.Point(127, 58).
        THIS-OBJECT:button1:Name = "button1".
        THIS-OBJECT:button1:Size = NEW System.Drawing.Size(35, 33).
        THIS-OBJECT:button1:TabIndex = 6.
        ultraToolTipInfo5:ToolTipText = "Add to clipboard".
        THIS-OBJECT:ultraToolTipManager1:SetUltraToolTip(THIS-OBJECT:button1, ultraToolTipInfo5).
        THIS-OBJECT:button1:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:button1:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:button1:Click:Subscribe(THIS-OBJECT:button1_Click).
        /*  */
        /* btnUpdateCollection */
        /*  */
        THIS-OBJECT:btnUpdateCollection:Image = CAST(resources:GetObject("btnUpdateCollection.Image"), System.Drawing.Image).
        THIS-OBJECT:btnUpdateCollection:Location = NEW System.Drawing.Point(78, 19).
        THIS-OBJECT:btnUpdateCollection:Name = "btnUpdateCollection".
        THIS-OBJECT:btnUpdateCollection:Size = NEW System.Drawing.Size(35, 33).
        THIS-OBJECT:btnUpdateCollection:TabIndex = 5.
        ultraToolTipInfo6:ToolTipText = "Update collectioname".
        THIS-OBJECT:ultraToolTipManager1:SetUltraToolTip(THIS-OBJECT:btnUpdateCollection, ultraToolTipInfo6).
        THIS-OBJECT:btnUpdateCollection:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btnUpdateCollection:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btnUpdateCollection:Click:Subscribe(THIS-OBJECT:btnUpdateCollection_Click).
        /*  */
        /* btnDeleteCollection */
        /*  */
        THIS-OBJECT:btnDeleteCollection:Image = CAST(resources:GetObject("btnDeleteCollection.Image"), System.Drawing.Image).
        THIS-OBJECT:btnDeleteCollection:Location = NEW System.Drawing.Point(41, 19).
        THIS-OBJECT:btnDeleteCollection:Name = "btnDeleteCollection".
        THIS-OBJECT:btnDeleteCollection:Size = NEW System.Drawing.Size(35, 33).
        THIS-OBJECT:btnDeleteCollection:TabIndex = 4.
        ultraToolTipInfo7:ToolTipText = "Delete collection".
        THIS-OBJECT:ultraToolTipManager1:SetUltraToolTip(THIS-OBJECT:btnDeleteCollection, ultraToolTipInfo7).
        THIS-OBJECT:btnDeleteCollection:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btnDeleteCollection:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btnDeleteCollection:Click:Subscribe(THIS-OBJECT:btnDeleteCollection_Click).
        /*  */
        /* btnRefresh */
        /*  */
        THIS-OBJECT:btnRefresh:Image = CAST(resources:GetObject("btnRefresh.Image"), System.Drawing.Image).
        THIS-OBJECT:btnRefresh:Location = NEW System.Drawing.Point(200, 19).
        THIS-OBJECT:btnRefresh:Name = "btnRefresh".
        THIS-OBJECT:btnRefresh:Size = NEW System.Drawing.Size(35, 33).
        THIS-OBJECT:btnRefresh:TabIndex = 3.
        ultraToolTipInfo8:ToolTipText = "Refresh collections".
        THIS-OBJECT:ultraToolTipManager1:SetUltraToolTip(THIS-OBJECT:btnRefresh, ultraToolTipInfo8).
        THIS-OBJECT:btnRefresh:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btnRefresh:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btnRefresh:Click:Subscribe(THIS-OBJECT:btnRefresh_Click).
        /*  */
        /* btnAddCollection */
        /*  */
        THIS-OBJECT:btnAddCollection:Image = CAST(resources:GetObject("btnAddCollection.Image"), System.Drawing.Image).
        THIS-OBJECT:btnAddCollection:Location = NEW System.Drawing.Point(4, 19).
        THIS-OBJECT:btnAddCollection:Name = "btnAddCollection".
        THIS-OBJECT:btnAddCollection:Size = NEW System.Drawing.Size(35, 33).
        THIS-OBJECT:btnAddCollection:TabIndex = 2.
        ultraToolTipInfo9:ToolTipText = "Add collection".
        THIS-OBJECT:ultraToolTipManager1:SetUltraToolTip(THIS-OBJECT:btnAddCollection, ultraToolTipInfo9).
        THIS-OBJECT:btnAddCollection:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btnAddCollection:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btnAddCollection:Click:Subscribe(THIS-OBJECT:btnAddCollection_Click).
        /*  */
        /* btnAdd */
        /*  */
        THIS-OBJECT:btnAdd:Image = CAST(resources:GetObject("btnAdd.Image"), System.Drawing.Image).
        THIS-OBJECT:btnAdd:Location = NEW System.Drawing.Point(4, 58).
        THIS-OBJECT:btnAdd:Name = "btnAdd".
        THIS-OBJECT:btnAdd:Size = NEW System.Drawing.Size(35, 33).
        THIS-OBJECT:btnAdd:TabIndex = 1.
        ultraToolTipInfo10:ToolTipText = "Add file(s)".
        THIS-OBJECT:ultraToolTipManager1:SetUltraToolTip(THIS-OBJECT:btnAdd, ultraToolTipInfo10).
        THIS-OBJECT:btnAdd:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btnAdd:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btnAdd:Click:Subscribe(THIS-OBJECT:btnAdd_Click).
        /*  */
        /* gridCollection */
        /*  */
        DEFINE VARIABLE nestedvar1 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar1 = CAST(Progress.Util.EnumHelper:Or(CAST(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:gridCollection:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:gridCollection:DataSource = THIS-OBJECT:gridFilesBindingSource.
        ultraGridBand1:Override:CellClickAction = Infragistics.Win.UltraWinGrid.CellClickAction:RowSelect.
        ultraGridBand1:Override:FilterEvaluationTrigger = Infragistics.Win.UltraWinGrid.FilterEvaluationTrigger:OnEnterKeyOrLeaveCell.
        ultraGridBand1:Override:FilterUIType = Infragistics.Win.UltraWinGrid.FilterUIType:FilterRow.
        THIS-OBJECT:gridCollection:DisplayLayout:BandsSerializer:Add(ultraGridBand1).
        THIS-OBJECT:gridCollection:DisplayLayout:BorderStyle = Infragistics.Win.UIElementBorderStyle:Solid.
        THIS-OBJECT:gridCollection:DisplayLayout:BorderStyleCaption = Infragistics.Win.UIElementBorderStyle:None.
        THIS-OBJECT:gridCollection:DisplayLayout:ColumnChooserEnabled = Infragistics.Win.DefaultableBoolean:False.
        THIS-OBJECT:gridCollection:DisplayLayout:LoadStyle = Infragistics.Win.UltraWinGrid.LoadStyle:LoadOnDemand.
        THIS-OBJECT:gridCollection:DisplayLayout:MaxColScrollRegions = 1.
        THIS-OBJECT:gridCollection:DisplayLayout:MaxRowScrollRegions = 1.
        THIS-OBJECT:gridCollection:Location = NEW System.Drawing.Point(4, 101).
        THIS-OBJECT:gridCollection:Name = "gridCollection".
        THIS-OBJECT:gridCollection:Size = NEW System.Drawing.Size(231, 574).
        THIS-OBJECT:gridCollection:TabIndex = 0.
        THIS-OBJECT:gridCollection:InitializeLayout:Subscribe(THIS-OBJECT:gridCollection_InitializeLayout).
        THIS-OBJECT:gridCollection:AfterRowCollapsed:Subscribe(THIS-OBJECT:gridCollection_AfterRowCollapsed).
        THIS-OBJECT:gridCollection:AfterSelectChange:Subscribe(THIS-OBJECT:gridCollection_AfterSelectChange).
        THIS-OBJECT:gridCollection:ClickCell:Subscribe(THIS-OBJECT:gridCollection_ClickCell).
        THIS-OBJECT:gridCollection:BeforeRowFilterDropDown:Subscribe(THIS-OBJECT:gridCollection_BeforeRowFilterDropDown).
        THIS-OBJECT:gridCollection:Click:Subscribe(THIS-OBJECT:gridCollection_Click).
        THIS-OBJECT:gridCollection:KeyDown:Subscribe(THIS-OBJECT:gridCollection_KeyDown).
        /*  */
        /* gridFilesBindingSource */
        /*  */
        THIS-OBJECT:gridFilesBindingSource:AllowEdit = FALSE.
        THIS-OBJECT:gridFilesBindingSource:MaxDataGuess = 0.
        THIS-OBJECT:gridFilesBindingSource:NoLOBs = FALSE.
        THIS-OBJECT:gridFilesBindingSource:TableSchema = ?.
        /*  */
        /* groupBoxView */
        /*  */
        DEFINE VARIABLE nestedvar2 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar2 = CAST(Progress.Util.EnumHelper:Or(CAST(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:groupBoxView:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar2, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:groupBoxView:BorderStyle = Infragistics.Win.Misc.GroupBoxBorderStyle:Header3D.
        THIS-OBJECT:groupBoxView:Controls:Add(THIS-OBJECT:ultraPictureBox1).
        THIS-OBJECT:groupBoxView:Location = NEW System.Drawing.Point(243, 7).
        THIS-OBJECT:groupBoxView:Name = "groupBoxView".
        THIS-OBJECT:groupBoxView:Size = NEW System.Drawing.Size(676, 675).
        THIS-OBJECT:groupBoxView:TabIndex = 1.
        THIS-OBJECT:groupBoxView:Text = "View".
        /*  */
        /* ultraPictureBox1 */
        /*  */
        DEFINE VARIABLE nestedvar3 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar3 = CAST(Progress.Util.EnumHelper:Or(CAST(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:ultraPictureBox1:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar3, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        appearance1:ImageHAlign = Infragistics.Win.HAlign:Center.
        appearance1:ImageVAlign = Infragistics.Win.VAlign:Middle.
        THIS-OBJECT:ultraPictureBox1:Appearance = appearance1.
        THIS-OBJECT:ultraPictureBox1:BorderShadowColor = System.Drawing.Color:Empty.
        THIS-OBJECT:ultraPictureBox1:Location = NEW System.Drawing.Point(4, 19).
        THIS-OBJECT:ultraPictureBox1:Name = "ultraPictureBox1".
        THIS-OBJECT:ultraPictureBox1:Size = NEW System.Drawing.Size(668, 656).
        THIS-OBJECT:ultraPictureBox1:TabIndex = 0.
        /*  */
        /* openFileDialog1 */
        /*  */
        THIS-OBJECT:openFileDialog1:Multiselect = TRUE.
        THIS-OBJECT:openFileDialog1:SupportMultiDottedExtensions = TRUE.
        THIS-OBJECT:openFileDialog1:Title = "Select file(s)".
        /*  */
        /* statusStrip1 */
        /*  */
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar0 AS System.Windows.Forms.ToolStripItem EXTENT 2 NO-UNDO.
        arrayvar0[1] = THIS-OBJECT:toolStripProgressBar.
        arrayvar0[2] = THIS-OBJECT:toolStripFileName.
        THIS-OBJECT:statusStrip1:Items:AddRange(arrayvar0).
        THIS-OBJECT:statusStrip1:Location = NEW System.Drawing.Point(0, 685).
        THIS-OBJECT:statusStrip1:Name = "statusStrip1".
        THIS-OBJECT:statusStrip1:Size = NEW System.Drawing.Size(919, 22).
        THIS-OBJECT:statusStrip1:TabIndex = 2.
        THIS-OBJECT:statusStrip1:Text = "statusStrip1".
        /*  */
        /* toolStripProgressBar */
        /*  */
        THIS-OBJECT:toolStripProgressBar:Name = "toolStripProgressBar".
        THIS-OBJECT:toolStripProgressBar:Size = NEW System.Drawing.Size(231, 16).
        THIS-OBJECT:toolStripProgressBar:Visible = FALSE.
        /*  */
        /* toolStripFileName */
        /*  */
        THIS-OBJECT:toolStripFileName:ImageAlign = System.Drawing.ContentAlignment:TopLeft.
        THIS-OBJECT:toolStripFileName:Name = "toolStripFileName".
        THIS-OBJECT:toolStripFileName:Size = NEW System.Drawing.Size(904, 17).
        THIS-OBJECT:toolStripFileName:Spring = TRUE.
        THIS-OBJECT:toolStripFileName:TextAlign = System.Drawing.ContentAlignment:TopLeft.
        /*  */
        /* imageList1 */
        /*  */
        THIS-OBJECT:imageList1:ImageStream = CAST(resources:GetObject("imageList1.ImageStream"), System.Windows.Forms.ImageListStreamer).
        THIS-OBJECT:imageList1:TransparentColor = System.Drawing.Color:Transparent.
        THIS-OBJECT:imageList1:Images:SetKeyName(0, "camera2.png").
        THIS-OBJECT:imageList1:Images:SetKeyName(1, "server_client_exchange.png").
        /*  */
        /* ultraToolTipManager1 */
        /*  */
        THIS-OBJECT:ultraToolTipManager1:ContainingControl = THIS-OBJECT.
        THIS-OBJECT:ultraToolTipManager1:DisplayStyle = Infragistics.Win.ToolTipDisplayStyle:BalloonTip.
        THIS-OBJECT:ultraToolTipManager1:ToolTipImage = Infragistics.Win.ToolTipImage:None.
        /*  */
        /* main */
        /*  */
        THIS-OBJECT:ClientSize = NEW System.Drawing.Size(919, 707).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:statusStrip1).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:groupBoxView).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:groupBoxFiles).
        THIS-OBJECT:Icon = CAST(resources:GetObject("$this.Icon"), System.Drawing.Icon).
        THIS-OBJECT:Name = "main".
        THIS-OBJECT:Text = "Media 2017".
        THIS-OBJECT:Load:Subscribe(THIS-OBJECT:main_Load).
        THIS-OBJECT:KeyDown:Subscribe(THIS-OBJECT:main_KeyDown).
        CAST(THIS-OBJECT:groupBoxFiles, System.ComponentModel.ISupportInitialize):EndInit().
        THIS-OBJECT:groupBoxFiles:ResumeLayout(FALSE).
        CAST(THIS-OBJECT:gridCollection, System.ComponentModel.ISupportInitialize):EndInit().
        CAST(THIS-OBJECT:gridFilesBindingSource, System.ComponentModel.ISupportInitialize):EndInit().
        CAST(THIS-OBJECT:groupBoxView, System.ComponentModel.ISupportInitialize):EndInit().
        THIS-OBJECT:groupBoxView:ResumeLayout(FALSE).
        THIS-OBJECT:statusStrip1:ResumeLayout(FALSE).
        THIS-OBJECT:statusStrip1:PerformLayout().
        THIS-OBJECT:ResumeLayout(FALSE).
        THIS-OBJECT:PerformLayout().
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/

	METHOD PRIVATE VOID initializeGridConnection(  ):
		
		IF VALID-HANDLE(ghGridCollectionDataset) THEN 
		  DELETE OBJECT ghGridCollectionDataset.
		
        RUN server\getGridCollection.p ON DYNAMIC-FUNCTION("getServerHandle") (INPUT-OUTPUT DATASET-HANDLE ghGridCollectionDataset BY-REFERENCE).		
	
		THIS-OBJECT:gridFilesBindingSource:HANDLE = ghGridCollectionDataset NO-ERROR.   

        THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollection"]:Columns["iCollectionNumber"]:HIDDEN = TRUE.
        THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollection"]:Columns["iNumberOfCollectionFiles"]:HIDDEN = TRUE.
        THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollection"]:Columns["cCollectionName"]:width = 150.        
        THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollectionFiles"]:Columns["iCollectionNumber"]:HIDDEN = TRUE.
        THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollectionFiles"]:Columns["cFileName"]:width = 150.
        THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollectionFiles"]:Columns["iFileNameKey"]:HIDDEN = TRUE.
        
        THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollection"]:Columns["iNumberOfCollectionFiles"]:CellAppearance:TextHAlign = Infragistics.Win.HAlign:Right.
        THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollection"]:Columns["iNumberOfCollectionFiles"]:Format = "###,###,##0".
        THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollection"]:Columns["iNumberOfCollectionFiles"]:width = 50.
        
        THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollection"]:ColHeadersVisible = FALSE.  
        THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollection"]:Override:CellClickAction = Infragistics.Win.UltraWinGrid.CellClickAction:RowSelect.       
        THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollectionFiles"]:Override:CellClickAction = Infragistics.Win.UltraWinGrid.CellClickAction:RowSelect.
		THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollectionFiles"]:ColHeadersVisible = FALSE.
		
		THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollectionFiles"]:Override:FilterUIType = THIS-OBJECT:gridCollection:DisplayLayout:Bands:Item["ttCollection"]:Override:FilterUIType.
		    
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID main_KeyDown( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.KeyEventArgs ):
		
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID main_Load( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		
		RETURN.

	END METHOD.


	DESTRUCTOR PUBLIC main ( ):

		IF VALID-OBJECT(components) THEN DO:
			CAST(components, System.IDisposable):Dispose().
		END.

	END DESTRUCTOR.

END CLASS.
 /*------------------------------------------------------------------------
    File        : addCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Dennis Brink
    Created     : Wed Jun 10 16:20:58 CEST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
USING Progress.Windows.Form.
  

CLASS Client.inputDialog INHERITS Form   : 

	DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE buttonOk AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE buttonCancel AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE txtCollectionName AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE lblName AS System.Windows.Forms.Label NO-UNDO.
    
	CONSTRUCTOR PUBLIC inputDialog( ):
	
		SUPER().
		InitializeComponent ( ).
		CATCH e AS Progress.Lang.Error:
			UNDO, THROW e.
		END CATCH.		

	END CONSTRUCTOR.

	DESTRUCTOR PUBLIC inputDialog( ):

		IF VALID-OBJECT(components) THEN DO:
			CAST(components, System.IDisposable):Dispose().
		END.

	END DESTRUCTOR.	

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID inputDialog_Load( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		
		RETURN.

	END METHOD.

    METHOD PRIVATE VOID okButton_Click (sender AS System.Object, e AS System.EventArgs):  
              
        IF THIS-OBJECT:txtCollectionName:Text = "" THEN DO:
          MESSAGE "Please enter a valid name" VIEW-AS ALERT-BOX ERROR TITLE "Error".
          THIS-OBJECT:txtCollectionName:Focus().
          THIS-OBJECT:DialogResult = System.Windows.Forms.DialogResult:NONE.
          RETURN ERROR.    
        END.
  
        ASSIGN THIS-OBJECT:Tag = THIS-OBJECT:txtCollectionName:Text.     
      	THIS-OBJECT:DialogResult = System.Windows.Forms.DialogResult:Ok.
		THIS-OBJECT:Close ( ).
			   
	END METHOD.

	METHOD PRIVATE VOID cancelButton_Click (sender AS System.Object, e AS System.EventArgs):
	    
		THIS-OBJECT:DialogResult = System.Windows.Forms.DialogResult:Cancel.
		THIS-OBJECT:Close ( ).
		
	END METHOD.
    
	METHOD PRIVATE VOID InitializeComponent ( ):

		/* NOTE: The following method is automatically generated.
		   
		   We strongly suggest that the contents of this method only be modified using the 
		   Visual Designer to avoid any incompatible modifications.
		   
		   Modifying the contents of this method using a code editor will invalidate any support for this file. */
		
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE resources AS Progress.Util.ResourceManager NO-UNDO.
        resources = NEW Progress.Util.ResourceManager("Client.inputDialog").
        THIS-OBJECT:buttonOk = NEW System.Windows.Forms.Button().
        THIS-OBJECT:buttonCancel = NEW System.Windows.Forms.Button().
        THIS-OBJECT:txtCollectionName = NEW System.Windows.Forms.TextBox().
        THIS-OBJECT:lblName = NEW System.Windows.Forms.Label().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* buttonOk */
        /*  */
        DEFINE VARIABLE nestedvar0 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
        THIS-OBJECT:buttonOk:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:buttonOk:BackColor = System.Drawing.SystemColors:Control.
        THIS-OBJECT:buttonOk:DialogResult = System.Windows.Forms.DialogResult:OK.
        THIS-OBJECT:buttonOk:FlatAppearance:BorderColor = System.Drawing.SystemColors:Control.
        THIS-OBJECT:buttonOk:FlatAppearance:BorderSize = 0.
        THIS-OBJECT:buttonOk:Image = CAST(resources:GetObject("buttonOk.Image"), System.Drawing.Image).
        THIS-OBJECT:buttonOk:Location = NEW System.Drawing.Point(385, 39).
        THIS-OBJECT:buttonOk:Name = "buttonOk".
        THIS-OBJECT:buttonOk:Size = NEW System.Drawing.Size(42, 43).
        THIS-OBJECT:buttonOk:TabIndex = 0.
        THIS-OBJECT:buttonOk:TabStop = FALSE.
        THIS-OBJECT:buttonOk:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:buttonOk:UseMnemonic = FALSE.
        THIS-OBJECT:buttonOk:UseVisualStyleBackColor = FALSE.
        THIS-OBJECT:buttonOk:Click:Subscribe(THIS-OBJECT:okButton_Click).
        /*  */
        /* buttonCancel */
        /*  */
        DEFINE VARIABLE nestedvar1 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar1 = System.Windows.Forms.AnchorStyles:Bottom.
        THIS-OBJECT:buttonCancel:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:buttonCancel:DialogResult = System.Windows.Forms.DialogResult:Cancel.
        THIS-OBJECT:buttonCancel:FlatAppearance:BorderColor = System.Drawing.SystemColors:Control.
        THIS-OBJECT:buttonCancel:FlatAppearance:BorderSize = 0.
        THIS-OBJECT:buttonCancel:Image = CAST(resources:GetObject("buttonCancel.Image"), System.Drawing.Image).
        THIS-OBJECT:buttonCancel:Location = NEW System.Drawing.Point(433, 39).
        THIS-OBJECT:buttonCancel:Name = "buttonCancel".
        THIS-OBJECT:buttonCancel:Size = NEW System.Drawing.Size(42, 41).
        THIS-OBJECT:buttonCancel:TabIndex = 0.
        THIS-OBJECT:buttonCancel:TabStop = FALSE.
        THIS-OBJECT:buttonCancel:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:buttonCancel:UseMnemonic = FALSE.
        THIS-OBJECT:buttonCancel:UseVisualStyleBackColor = FALSE.
        THIS-OBJECT:buttonCancel:Click:Subscribe(THIS-OBJECT:cancelButton_Click).
        /*  */
        /* txtCollectionName */
        /*  */
        THIS-OBJECT:txtCollectionName:Location = NEW System.Drawing.Point(49, 13).
        THIS-OBJECT:txtCollectionName:Name = "txtCollectionName".
        THIS-OBJECT:txtCollectionName:Size = NEW System.Drawing.Size(426, 20).
        THIS-OBJECT:txtCollectionName:TabIndex = 0.
        /*  */
        /* lblName */
        /*  */
        THIS-OBJECT:lblName:Location = NEW System.Drawing.Point(3, 13).
        THIS-OBJECT:lblName:Name = "lblName".
        THIS-OBJECT:lblName:Size = NEW System.Drawing.Size(40, 20).
        THIS-OBJECT:lblName:TabIndex = 3.
        THIS-OBJECT:lblName:Text = "Name:".
        THIS-OBJECT:lblName:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
        THIS-OBJECT:lblName:UseCompatibleTextRendering = TRUE.
        /*  */
        /* inputDialog */
        /*  */
        THIS-OBJECT:AcceptButton = THIS-OBJECT:buttonOk.
        THIS-OBJECT:CancelButton = THIS-OBJECT:buttonCancel.
        THIS-OBJECT:ClientSize = NEW System.Drawing.Size(489, 94).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:lblName).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:txtCollectionName).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:buttonCancel).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:buttonOk).
        THIS-OBJECT:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
        THIS-OBJECT:MaximizeBox = FALSE.
        THIS-OBJECT:MinimizeBox = FALSE.
        THIS-OBJECT:Name = "inputDialog".
        THIS-OBJECT:ShowInTaskbar = FALSE.
        THIS-OBJECT:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
        THIS-OBJECT:Text = "".
        THIS-OBJECT:Load:Subscribe(THIS-OBJECT:inputDialog_Load).
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

	METHOD PUBLIC VOID setInitialValueTextField(INPUT picText AS CHAR ):
		
		THIS-OBJECT:txtCollectionName:Text = picText.
		
		RETURN.

	END METHOD.

	METHOD PUBLIC VOID ShowModalDialog(  ):
		
		WAIT-FOR THIS-OBJECT:ShowDialog().

	END METHOD.


 
END CLASS.

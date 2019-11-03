 /*------------------------------------------------------------------------
    File        : login
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Dennis Brink
    Created     : Thu Jun 04 21:54:13 CEST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
USING Progress.Windows.Form.
  

CLASS Client.login INHERITS Form   : 

	DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE buttonOk AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE buttonCancel AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE lblUser AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE lblPassword AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE pictureBox1 AS System.Windows.Forms.PictureBox NO-UNDO.
    DEFINE PRIVATE VARIABLE txtUser AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE txtPassword AS System.Windows.Forms.TextBox NO-UNDO.
        
	CONSTRUCTOR PUBLIC login( ):
	
		SUPER().
		InitializeComponent ( ).
		CATCH e AS Progress.Lang.Error:
			UNDO, THROW e.
		END CATCH.		

	END CONSTRUCTOR.

	DESTRUCTOR PUBLIC login( ):

		IF VALID-OBJECT(components) THEN DO:
			CAST(components, System.IDisposable):Dispose().
		END.

	END DESTRUCTOR.	

    METHOD PRIVATE VOID okButton_Click (sender AS System.Object, e AS System.EventArgs):
        
        DEF VAR lLoginSucces AS LOG NO-UNDO.
        
        RUN server\checklogin.p ON DYNAMIC-FUNCTION("getServerHandle") (INPUT THIS-OBJECT:txtUser:Text, INPUT THIS-OBJECT:txtPassword:text, OUTPUT lLoginSucces).
        IF NOT lLoginSucces THEN DO:
          MESSAGE "Access denied. Invalid username and/or password" VIEW-AS ALERT-BOX ERROR TITLE "Error".
          THIS-OBJECT:txtUser:Focus().
          RETURN ERROR. 
        END.     
          
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
        resources = NEW Progress.Util.ResourceManager("Client.login").
        THIS-OBJECT:buttonOk = NEW System.Windows.Forms.Button().
        THIS-OBJECT:buttonCancel = NEW System.Windows.Forms.Button().
        THIS-OBJECT:txtUser = NEW System.Windows.Forms.TextBox().
        THIS-OBJECT:txtPassword = NEW System.Windows.Forms.TextBox().
        THIS-OBJECT:pictureBox1 = NEW System.Windows.Forms.PictureBox().
        THIS-OBJECT:lblUser = NEW System.Windows.Forms.Label().
        THIS-OBJECT:lblPassword = NEW System.Windows.Forms.Label().
        CAST(THIS-OBJECT:pictureBox1, System.ComponentModel.ISupportInitialize):BeginInit().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* buttonOk */
        /*  */
        DEFINE VARIABLE nestedvar0 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
        THIS-OBJECT:buttonOk:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:buttonOk:Location = NEW System.Drawing.Point(131, 88).
        THIS-OBJECT:buttonOk:Name = "buttonOk".
        THIS-OBJECT:buttonOk:Size = NEW System.Drawing.Size(75, 23).
        THIS-OBJECT:buttonOk:TabIndex = 2.
        THIS-OBJECT:buttonOk:Text = "OK".
        THIS-OBJECT:buttonOk:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:buttonOk:Click:Subscribe(THIS-OBJECT:okButton_Click).
        /*  */
        /* buttonCancel */
        /*  */
        DEFINE VARIABLE nestedvar1 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar1 = System.Windows.Forms.AnchorStyles:Bottom.
        THIS-OBJECT:buttonCancel:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:buttonCancel:DialogResult = System.Windows.Forms.DialogResult:Cancel.
        THIS-OBJECT:buttonCancel:Location = NEW System.Drawing.Point(215, 88).
        THIS-OBJECT:buttonCancel:Name = "buttonCancel".
        THIS-OBJECT:buttonCancel:Size = NEW System.Drawing.Size(75, 23).
        THIS-OBJECT:buttonCancel:TabIndex = 3.
        THIS-OBJECT:buttonCancel:Text = "Cancel".
        THIS-OBJECT:buttonCancel:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:buttonCancel:Click:Subscribe(THIS-OBJECT:cancelButton_Click).
        /*  */
        /* txtUser */
        /*  */
        THIS-OBJECT:txtUser:BorderStyle = System.Windows.Forms.BorderStyle:FixedSingle.
        THIS-OBJECT:txtUser:Location = NEW System.Drawing.Point(131, 12).
        THIS-OBJECT:txtUser:Name = "txtUser".
        THIS-OBJECT:txtUser:Size = NEW System.Drawing.Size(159, 20).
        THIS-OBJECT:txtUser:TabIndex = 0.
        /*  */
        /* txtPassword */
        /*  */
        THIS-OBJECT:txtPassword:BorderStyle = System.Windows.Forms.BorderStyle:FixedSingle.
        THIS-OBJECT:txtPassword:Location = NEW System.Drawing.Point(131, 47).
        THIS-OBJECT:txtPassword:Name = "txtPassword".
        THIS-OBJECT:txtPassword:Size = NEW System.Drawing.Size(159, 20).
        THIS-OBJECT:txtPassword:TabIndex = 1.
        THIS-OBJECT:txtPassword:UseSystemPasswordChar = TRUE.
        /*  */
        /* pictureBox1 */
        /*  */
        THIS-OBJECT:pictureBox1:Image = CAST(resources:GetObject("pictureBox1.Image"), System.Drawing.Image).
        THIS-OBJECT:pictureBox1:Location = NEW System.Drawing.Point(12, 12).
        THIS-OBJECT:pictureBox1:Name = "pictureBox1".
        THIS-OBJECT:pictureBox1:Size = NEW System.Drawing.Size(52, 55).
        THIS-OBJECT:pictureBox1:TabIndex = 4.
        THIS-OBJECT:pictureBox1:TabStop = FALSE.
        /*  */
        /* lblUser */
        /*  */
        THIS-OBJECT:lblUser:Location = NEW System.Drawing.Point(81, 12).
        THIS-OBJECT:lblUser:Name = "lblUser".
        THIS-OBJECT:lblUser:Size = NEW System.Drawing.Size(44, 19).
        THIS-OBJECT:lblUser:TabIndex = 5.
        THIS-OBJECT:lblUser:Text = "User".
        THIS-OBJECT:lblUser:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
        THIS-OBJECT:lblUser:UseCompatibleTextRendering = TRUE.
        /*  */
        /* lblPassword */
        /*  */
        THIS-OBJECT:lblPassword:Location = NEW System.Drawing.Point(70, 48).
        THIS-OBJECT:lblPassword:Name = "lblPassword".
        THIS-OBJECT:lblPassword:Size = NEW System.Drawing.Size(55, 19).
        THIS-OBJECT:lblPassword:TabIndex = 6.
        THIS-OBJECT:lblPassword:Text = "Password".
        THIS-OBJECT:lblPassword:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
        THIS-OBJECT:lblPassword:UseCompatibleTextRendering = TRUE.
        /*  */
        /* login */
        /*  */
        THIS-OBJECT:AcceptButton = THIS-OBJECT:buttonOk.
        THIS-OBJECT:CancelButton = THIS-OBJECT:buttonCancel.
        THIS-OBJECT:ClientSize = NEW System.Drawing.Size(299, 123).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:lblPassword).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:lblUser).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:pictureBox1).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:txtPassword).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:txtUser).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:buttonCancel).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:buttonOk).
        THIS-OBJECT:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
        THIS-OBJECT:MaximizeBox = FALSE.
        THIS-OBJECT:MinimizeBox = FALSE.
        THIS-OBJECT:Name = "login".
        THIS-OBJECT:StartPosition = System.Windows.Forms.FormStartPosition:CenterScreen.
        THIS-OBJECT:Text = "Login".
        CAST(THIS-OBJECT:pictureBox1, System.ComponentModel.ISupportInitialize):EndInit().
        THIS-OBJECT:ResumeLayout(FALSE).
        THIS-OBJECT:PerformLayout().
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
	END METHOD. 
 
	METHOD PUBLIC VOID ShowModalDialog(  ):
		
		WAIT-FOR THIS-OBJECT:ShowDialog().

	END METHOD.


 
END CLASS.

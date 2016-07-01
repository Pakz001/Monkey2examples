#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class MyWindow Extends Window

	Method New()
	End method
	
	Method OnRender( canvas:Canvas ) Override
	
	End Method	
	
	Method OnKeyEvent( event:KeyEvent ) Override
	
		Select event.Type
		Case EventType.KeyDown
			Select event.Key
			Case Key.Escape
			'End here
			End Select
			End Select
		End 
	End Method
	
End	Class

Function Main()

	New AppInstance
	
	New MyWindow
	
	App.Run()
	
End function


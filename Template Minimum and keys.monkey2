#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global instance:AppInstance

Class MyWindow Extends Window

	Method New()
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
	End Method	
	
	Method OnKeyEvent( event:KeyEvent ) Override	
		Select event.Type
			Case EventType.KeyDown
			Select event.Key
				Case Key.Escape
			    instance.Terminate()
			End Select
		End Select		
	End Method
	
End	Class

Function Main()
	instance = New AppInstance	
	
	New MyWindow
	
	App.Run()
	
End Function

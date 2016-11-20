#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class MyWindow Extends Window

	Field mystack:= New Stack<String>

	Method New()
		For Local i:=0 To 10
			mystack.Push(i)
		Next
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		
		If Keyboard.KeyReleased(Key.Space)
			mystack.Erase(0)
			Print mystack.Length
		End if
		For Local i:=0 until mystack.Length
			canvas.DrawText(mystack.Get(i),10,i*20)
		Next
		
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

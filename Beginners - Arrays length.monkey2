#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Class MyWindow Extends Window
	' no idea yet on how to do length withmultidimensional arrays.
	' documentation points to do it yourself.
	Field myarray1:Int[] = New Int[30]

	Method New()
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method
		canvas.Color = Color.White
		canvas.DrawText(myarray1.Length,0,20)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

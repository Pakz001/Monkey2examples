#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Class MyWindow Extends Window
	Method New()
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		' From Monkey 1.1.08 you can print boolean values. They get
		' converted to string automatically. (Handy for debugging)
		'
		Local a:Bool=True
		canvas.Color = Color.Black
		canvas.DrawText("'a' boolean value is : "+a,0,0)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

'
' From the coding train - based on a commodore 64 line of code.
'

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Class MyWindow Extends Window
	Field map:Int[,] = New Int[50,30]
	Method New()
		makemaze()
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		For Local y:Int=0 Until 30
		For Local x:Int=0 Until 50
			If map[x,y] = 1 Then 
				canvas.DrawLine(x*10,y*10,x*10+10,y*10+10)				
			Else
				canvas.DrawLine(x*10+10,y*10,x*10,y*10+10)				
			End if
		Next
		Next
		If Keyboard.KeyReleased(Key.Space) Then makemaze()
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	Method makemaze()
		For Local y:Int=0 Until 30
		For Local x:Int=0 Until 50
			If Rnd(1) < .5 Then map[x,y] = 1 Else map[x,y] = 0
		Next
		Next		
	End Method
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

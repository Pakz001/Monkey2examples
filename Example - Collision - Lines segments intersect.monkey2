#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Class MyWindow Extends Window
	' The variable for a line on the screen 
	Field x1:Int=100,y1:Int=100
	Field x2:Int=200,y2:Int=200
	
	Method New()
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		' Draw some things to the screen
		canvas.DrawLine(x1,y1,x2,y2)
		canvas.DrawLine(Mouse.X,Mouse.Y,Mouse.X-50,Mouse.Y+50)
		'
		' Here we check the collision
		If lineintersect(x1,x1,x2,y2,Mouse.X,Mouse.Y,Mouse.X-50,Mouse.Y+50)
			canvas.DrawText("Collision..",0,0)
		Else 'if no collision - false
			canvas.DrawText("No Collision..",0,0)
		End If
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

' This is the line intersect/collision function
'  input : 	line 1 x1,x1,x2,y2
'			line 2 x1,y1,x2,y2
'  output :	True or False
Function lineintersect:Bool(	x1:Float,y1:Float,x2:Float,y2:Float,
    	                       	u1:Float,v1:Float,u2:Float,v2:Float)
    Local b1:Float = (y2 - y1) / (x2 - x1)
    Local b2:Float = (v2 - v1) / (u2 - u1)
    Local a1:Float = y1 - b1 *x1
    Local a2:Float = v1 - b2 *u1
    Local xi:Float = - (a1-a2)/(b1-b2)
    Local yi:Float = a1+b1*xi
    If     (x1 - xi)*(xi-x2)> -1 And (u1-xi)*(xi - u2)> 0 And (y1-yi)*(yi-y2)>-1 And (v1-yi)*(yi-v2)>-1 Return True
	Return false	
End Function

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class texteditor
	Field wx:int,wy:Int,ww:Int,wh:Int
	Field lines:String[]
	Field maxnumlines:Int=99
	Method New(x:Int,y:Int,w:Int,h:int)

		wx = x
		wy = y
		ww = w
		wh = h		
		lines = New String[99]
		lines[0] = "Testing..."
		lines[1] = "Line two.."
	End Method 
	Method update()
	End Method
	Method draw(canvas:Canvas)
		canvas.Color = Color.Black
		canvas.DrawRect(wx,wy,ww,wh)
		outline(canvas,wx+1,wy+1,ww-2,wh-2,Color.White,Color.Grey)
		For Local line:=0 Until 10
			If lines[line] <> ""
				For Local i:=0 Until lines[line].Length
					canvas.DrawText(lines[line].Mid(i,1),wx+(i*10),wy+(line*15))
				next			
			End If
		Next
	End Method
	Method outline(canvas:Canvas,x:Int,y:Int,w:Int,h:Int,col1:Color,col2:Color)
		canvas.Color = col1
		canvas.DrawLine(x,y,x+w,y)
		canvas.DrawLine(x,y,x,y+h)
		canvas.Color = col2
		canvas.DrawLine(x,y+h,x+w,y+h)
		canvas.DrawLine(x+w,y,x+w,y+h)
	End Method
End Class

Global mytexteditor:texteditor

Class MyWindow Extends Window

	Method New()
		mytexteditor = New texteditor(100,100,320,150)
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		mytexteditor.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

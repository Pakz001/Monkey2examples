#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class menu
	Field wx:Int
	Field wy:Int
	Field ww:Int=96
	Field wh:Int=96
	Field tw:Int
	Field th:Int
	Field ix:Int
	Field iy:Int
	Method New(x:Int,y:Int)
		Self.wx=x
		Self.wy=y
		tw = (ww*3)+20
		th = (wh*3)+20
	End Method 
	Method update()
		If Keyboard.KeyReleased(Key.Right)
			If ix<2 Then ix+=1
		Elseif Keyboard.KeyReleased(Key.Left)
			If ix>0 Then ix-=1
		Elseif Keyboard.KeyReleased(Key.Up)
			If iy>0 Then iy-=1
		Elseif Keyboard.KeyReleased(Key.Down)
			If iy<2 Then iy+=1
		End If
	End Method 
	Method draw(canvas:Canvas)
		canvas.Color = Color.Black
		canvas.DrawRect(wx,wy,tw,th)
		canvas.Color = Color.Brown
		canvas.DrawRect(wx+1,wy+1,tw-2,th-2)
		For Local y:=0 To 2
		For Local x:=0 To 2
			If ix=x And iy=y Then 
				drawwindow(canvas,wx+(x*ww)+10,wy+(y*wh)+10,Color.White)
				Else
				drawwindow(canvas,wx+(x*ww)+10,wy+(y*wh)+10,Color.Grey)	
			End If
		Next
		Next
	End Method 
	Method drawwindow(canvas:Canvas,x:Int,y:Int,color:Color)
		canvas.Color = Color.Black
		canvas.DrawRect(x,y,ww,wh)
		canvas.Color = color
		canvas.DrawRect(x+1,y+1,ww-2,wh-2)
		canvas.Color = Color.Black
		canvas.DrawRect(x+8,y+8,ww-16,wh-16)
		canvas.Color = Color.White
		canvas.DrawLine(x+1,y+1,x+ww-1,y+1)
		canvas.DrawLine(x+1,y+1,x+1,y+wh+1)
		canvas.Color = Color.DarkGrey
		canvas.DrawLine(x+ww-1,y+1+1,x+ww-1,y+wh-1)
		canvas.DrawLine(x+1+1,y+wh-1,x+ww-1,y+wh-1)
	End Method 
End Class 

Global mymenu:menu

Class MyWindow Extends Window 

	
	Method New()
		Title="Menu example 1"
		mymenu = New menu(640/2-(96*3/2),50)
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		canvas.Clear(Color.White)
		For Local y:Float=0 To 50 Step 1
			canvas.Color = New Color(y/50,y/50,y/50)
			canvas.DrawLine(0,y,640,y)
			canvas.DrawLine(0,480-y,640,480-y)
		Next
		mymenu.update()
		mymenu.draw(canvas)	
		canvas.Color = Color.Black
		canvas.DrawText("x:"+mymenu.ix+" - y:"+mymenu.iy,0,90)	
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

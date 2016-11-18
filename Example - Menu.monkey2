#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class menu
	Field twx:Int
	Field twy:Int
	Field wx:Int
	Field wy:Int
	Field ww:Int=96
	Field wh:Int=96
	Field tw:Int
	Field th:Int
	Field ix:Int
	Field iy:Int
	Method New(x:Int,y:Int,twx:Int,twy:Int)
		Self.wx=x
		Self.wy=y
		Self.twx=twx
		Self.twy=twy
		tw = (ww*twx)+20
		th = (wh*twy)+20
	End Method 
	Method update()
		If Keyboard.KeyReleased(Key.Right)
			If ix<twx-1 Then ix+=1
		Elseif Keyboard.KeyReleased(Key.Left)
			If ix>0 Then ix-=1
		Elseif Keyboard.KeyReleased(Key.Up)
			If iy>0 Then iy-=1
		Elseif Keyboard.KeyReleased(Key.Down)
			If iy<twy-1 Then iy+=1
		End If
	End Method 
	Method draw(canvas:Canvas)
		canvas.Color = Color.Black
		canvas.DrawRect(wx,wy,tw,th)
		'canvas.Color = Color.Brown
		For Local y1:Float=0 Until 10 Step 1
			outline(canvas,wx+y1,wy+y1,tw-(y1*2),th-(y1*2),New Color(y1/10,y1/10,y1/10),New Color(y1/10/2,y1/10/2,y1/10/2))
		Next
		''canvas.DrawRect(wx+1,wy+1,tw-2,th-2)
		outline(canvas,wx+1,wy+1,tw-2,th-2,New Color(.7,.7,.7), New Color(.3,.3,.3))
		outline(canvas,wx+2,wy+2,tw-4,th-4,New Color(.4,.4,.4), New Color(.5,.5,.5))
		For Local y:=0 Until twy
		For Local x:=0 Until twx
			If ix=x And iy=y Then 
				drawwindow(canvas,wx+(x*ww)+10,wy+(y*wh)+10,Color.Yellow)
				Else
				drawwindow(canvas,wx+(x*ww)+10,wy+(y*wh)+10,Color.Grey)	
			End If
		Next
		Next
	End Method 
	Method drawwindow(canvas:Canvas,x:Int,y:Int,color:Color)
		canvas.Color = Color.Black
		canvas.DrawRect(x,y,ww,wh)
		canvas.Color = Color.Black
		canvas.DrawRect(x+8,y+8,ww-16,wh-16)
		For Local y1:Float=0 To 10 Step 1
			outline(canvas,x+y1,y+y1,ww-(y1*2),wh-(y1*2),New Color(y1/10,y1/10,y1/10),New Color((y1/10)/2,(y1/10)/2,(y1/10)/2))
		Next
		outline(canvas,x+1,y+1,ww-1,wh-1,  New Color(1,1,1)   ,New Color(.3,.3,.3))
		outline(canvas,x+2,y+2,ww-4,wh-4,color,color)
		outline(canvas,x+3,y+3,ww-6,wh-6,color,color)

	End Method
	Method outline(canvas:Canvas,x:Int,y:Int,w:Int,h:Int,lc:Color,dc:Color)
		canvas.Color = lc
		canvas.DrawLine(x,y,x+w,y)
		canvas.DrawLine(x,y,x,y+h)
		canvas.Color = dc
		canvas.DrawLine(x+w,y+1,x+w,y+h)
		canvas.DrawLine(x+1,y+h,x+w,y+h)
	End Method  
End Class 

Global mymenu:menu

Class MyWindow Extends Window 

	
	Method New()
		Title="Menu example 1"
		mymenu = New menu(0,50,6,4)
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
		canvas.DrawText("x:"+mymenu.ix+" - y:"+mymenu.iy,0,30)	
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

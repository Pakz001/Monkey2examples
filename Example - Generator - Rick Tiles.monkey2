#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class tile
	Field tw:Int,th:Int
	Field map:Int[,]
	Field im:Image
	Field imcan:Canvas
	Field col:Color
	Method New(tw:Int,th:Int,col:Color)
		Self.tw = tw
		Self.th = th
		Self.col = col
		im = New Image(tw,th)
		imcan = New Canvas(im)
		imcan.Clear(Color.Blue)
		imcan.Flush()
		map = New Int[tw,th]
		generatetile()
		createtile()
	End Method
	Method generatetile()
		drawblock(0,0,tw,10)
	End Method
	Method drawblock(x:Int,y:Int,w:Int,h:Int)
		For Local y1:Int=x Until y+h
		For Local x1:Int=y Until x+w
			map[x1,y1] = 1
		Next
		Next
		' left top to right top lighter bar
		For Local x1:Int=x Until x+(w-1)
			map[x1,0] = 3
		Next
		' left top to left bottom light bar
		For Local y1:Int=y Until y+(h-1)
			map[0,y1] = 3
		Next
		' left bottom to right bottom dark bar
		For Local x1:Int=x+1 Until x+(w-1)
			map[x1,y+h-1] = 2
		Next
		' right top to right bottom dark color
		For Local y1:Int=y+1 Until y+(h)
			map[x+w-1,y1] = 2
		Next
		' noise light top left to top right
		For Local x1:Int=x+1 Until x+(w-4)
			If Rnd() < .2 Or x1=x+1
				Local d:Int=Rnd(1,4)
				If x1 = x+1 Then d = w/4
				For Local x2:Int=x1 Until x1+d
					If x2>x+(w-4) Then Exit
					map[x2,1] = 3
				Next
			End if
		Next
		' noise light top left to bottom left
		For Local y1:Int=y+1 Until y+(h-4)
			If Rnd() < .2 Or y1=y+1
				Local d:Int=Rnd(1,4)
				If y1 = y+1 Then d = h/4
				For Local y2:Int=y1 Until y1+d
					If y2>y+(h-4) Then Exit
					map[1,y2] = 3
				Next
			End if
		Next

	End Method
	Method createtile()
		For Local y:Int=0 Until th
		For Local x:Int=0 Until tw
			If map[x,y] = 0 Then Continue
			Select map[x,y]
				Case 1
					imcan.Color = Color.Grey
				Case 2
					imcan.Color = Color.Grey.Blend(Color.Black,.5)					
				Case 3
					imcan.Color = Color.Grey.Blend(Color.White,.5)
				Case 4
					imcan.Color = Color.Grey.Blend(Color.Brown,.5)
			End Select			
			imcan.DrawPoint(x,y)
		Next
		Next
		imcan.Flush()
	End Method
End Class

Class MyWindow Extends Window
	Field mytile:tile
	Method New()
		mytile = New tile(32,32,Color.Grey)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		canvas.DrawImage(mytile.im,100,100,0,6,6)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

#Import "<std>"
#Import "<mojo>"


'
' Create rocks or shapes with shaded edges.
' This is done by taking the angle from the center of the shape to
' the edge and turning this into a light or dark color. 
'

Using std..
Using mojo..

Class wfc
	Field map:Int[,]
	Field mw:Int,mh:Int,sw:Int,sh:Int
	Field tw:Float,th:Float
	Field leftmousetile:Int,rightmousetile:Int
	Enum tiles
		nothing = 0,
		sand = 1,
		sandgrasstop = 2,
		rock = 3,
		rocklightleft = 4,
		rocklightright = 5,
		rocklighttop = 6
		
	End Enum
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		tw = Float(sw) / Float(mw)
		th = Float(sh) / Float(mh)
		map = New Int[mw,mh]
	End Method
	Method edit()
		Local x:Int=Mouse.X / tw
		Local y:Int=Mouse.Y / th
		If Mouse.ButtonDown(MouseButton.Left)
			map[x,y] = leftmousetile
		Elseif Mouse.ButtonDown(MouseButton.Right)
			leftmousetile = map[x,y]
		End If
	End Method
 	Method drawtile(canvas:Canvas,tile:Int,x:Float,y:Float)
		If tile = 0 ' air/nothing
			canvas.Color = Color.Blue
			canvas.DrawRect(x,y,tw+1,th+1)
		End If
		If tile = 1 ' sand
			canvas.Color = Color.Brown
			canvas.DrawRect(x,y,tw+1,th+1)
		End If
		If tile = 2 'sand and grass at top
			canvas.Color = Color.Brown
			canvas.DrawRect(x,y,tw+1,th+1)
			canvas.Color = Color.Green
			canvas.DrawRect(x,y,tw+1,th/5)
		End If
		If tile = 3 ' rock
			canvas.Color = Color.Grey
			canvas.DrawRect(x,y,tw+1,th+1)
		End If
		If tile = 4 'rock light side left
			canvas.Color = Color.Grey
			canvas.DrawRect(x,y,tw+1,th+1)
			canvas.Color = Color.LightGrey
			canvas.DrawRect(x,y,tw/5,th+1)
		End If
		If tile = 5 'rock light right left
			canvas.Color = Color.Grey
			canvas.DrawRect(x,y,tw+1,th+1)
			canvas.Color = Color.LightGrey
			canvas.DrawRect(x+tw-(tw/5),y,tw/5,th+1)
		End If
		If tile = 6 'rock light top side
			canvas.Color = Color.Grey
			canvas.DrawRect(x,y,tw+1,th+1)
			canvas.Color = Color.LightGrey
			canvas.DrawRect(x,y,tw+1,th/5)
		End If
		If tile = 7 'rock ramp left bottom to up
			canvas.Color = Color.Grey
			canvas.DrawTriangle(x+tw,y,x,y+th,x+tw,y+th)
			canvas.Color = Color.LightGrey
			canvas.DrawQuad(x+tw,y,x,y+th,x+tw/5,y+th,x+tw,y+th/5)
		End If
		If tile = 8  'rock ramp right bottom up
			canvas.Color = Color.Grey
			canvas.DrawTriangle(x,y,x,y+th,x+tw,y+th)
			canvas.Color = Color.LightGrey
			canvas.DrawQuad(x,y,x+tw,y+th,x+tw-tw/5,y+th,x,y+th/5)
		End If
		If tile = 9 ' rock left and top highlighted
			canvas.Color = Color.Grey
			canvas.DrawRect(x,y,tw+1,th+1)
			canvas.Color = Color.LightGrey
			canvas.DrawRect(x,y,tw+1,th/5)
			canvas.DrawRect(x,y,tw/5,th+1)
		End If
		If tile = 10 ' rock Right and top highlighted
			canvas.Color = Color.Grey
			canvas.DrawRect(x,y,tw+1,th+1)
			canvas.Color = Color.LightGrey
			canvas.DrawRect(x,y,tw+1,th/5)
			canvas.DrawRect(x+tw-tw/5,y,tw/5,th+1)
		End If

	End Method
	Method tileselect(canvas:Canvas)		
		canvas.Clear(Color.Black)
		Local cnt:Int=0
		Local highlight:Int
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			
			drawtile(canvas,cnt,x*(tw),y*(th))
			If rectsoverlap(x*(tw),y*(th),tw,th,Mouse.X,Mouse.Y,1,1)
				canvas.Color = Color.Yellow.Blend(New Color(.1,.1,.1,.2),.5)
				canvas.DrawRect(x*(tw),y*(th),tw,th)
				If Mouse.ButtonReleased(MouseButton.Left)				
						leftmousetile = cnt
						Print leftmousetile
				Elseif Mouse.ButtonReleased(MouseButton.Right)
						rightmousetile = cnt
						Print rightmousetile
				End If
	
			End If
			
			cnt+=1
		Next
		Next
	End Method
	Method draw(canvas:Canvas)
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			drawtile(canvas,map[x,y],x*tw,y*th)
		Next
		Next
	End Method
	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    	If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    	If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    	Return True
	End Function	
End Class

Class MyWindow Extends Window
	Field mywfc:wfc
	Field delay:Int=20,maxdelay:Int=20
	Method New()
		mywfc = New wfc(Width,Height,16,16)
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		delay+=1
		App.RequestRender() ' Activate this method 
		
		mywfc.draw(canvas)
		If delay>maxdelay Then mywfc.edit()
		If Keyboard.KeyDown(Key.LeftShift) Then mywfc.tileselect(canvas) ; delay=0
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

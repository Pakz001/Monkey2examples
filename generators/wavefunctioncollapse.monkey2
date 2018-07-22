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
	'wave function setup
	Class wavenode		
		Field tile:int
		'Global a:List<test>[] = New List<test>[10]
		Field beside:Stack<Int>[]
		Method New(t:Int)
			Self.tile = t			
			beside = New Stack<Int>[9]
			For Local i:Int=0 Until 9
				beside[i] = New Stack<Int>
			Next
		End Method
		Method addtile(location:Int,tile:Int)
			For Local i:Int=0 Until beside[location].Length
				If beside[location].Get(i) = tile Then Return
			Next
			beside[location].Push(tile)
		End Method
	End Class
	'map setup
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
	Method dofunction()
		'find tiles used
		Local tused:Stack<wavenode> = New Stack<wavenode>
		
		Local exsists := Lambda:Bool(in:Int)
			For Local i:Int=0 Until tused.Length
				If tused.Get(i).tile = in Then Return True
			Next
			Return False
		End Lambda

		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw			
			'add tile and add surroundings
			If exsists(map[x,y]) = False
				tused.Push(New wavenode(map[x,y]))
				Print "added:"+map[x,y]
				Local location:Int=0
				For Local y2:Int=y-1 To y+1
				For Local x2:Int=x-1 To x+1
					If x2<0 Or y2<0 Or x2>=mw Or y2>=mh Then 
						location +=1
						Continue
					End If
					tused.Get(0).addtile(location,map[x2,y2])	
					location +=1
				Next
				Next
			End If			
		Next
		Next		
		
		If tused.Length = 0 Then Return
		
		' Get a random tile from the tiles used stack
		Local randomtile := Lambda:Int()			
			Repeat			
				For Local i:Int=0 Until tused.Length
					If Rnd() <.01 Then Return tused.Get(i).tile 
				Next
			Forever
			Return False
		End Lambda

		' Is this tile legal here
		Local islegaltile := Lambda:Bool(side:Int,check:Int,t:Int)			
			For Local i:Int=0 Until tused.Length
				If tused.Get(i).tile=check
					For Local ii:Int=0 Until tused.Get(i).beside[side].Length
						If tused.Get(i).beside[side].Get(ii) = t Then Return True
					Next
				End If
			Next
			Return False
		End Lambda


		For Local i:Int=0 Until 20
			Print randomtile()
		Next

		' Create new map
		map = New Int[mw,mh]
		map[Rnd(0,mw),Rnd(0,mh)] = randomtile()		
		For Local i:Int=0 Until 500
			
			Local x:Int=Rnd(mw)
			Local y:Int=Rnd(mh)
			'If map[x,y] = 0 Then Continue
			Local side:Int=0
			For Local y1:Int=y-1 To y+1
			For Local x1:Int=x-1 To x+1
				If x1<0 Or y1<0 Or x1>=mw Or y1>=mh Then 
					side+=1
					Continue
				End If
				'findlegal
				If side<>4 Then 
										
				For Local z:Int=0 Until 200
					Local r:Int=randomtile()
					If islegaltile(side,map[x,y],r) Then
						map[x1,y1] = r
						Return
					End If
				Next
				End If
				side+=1
			Next
			Next
			
		Next
		Print "done"
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
		
		If Keyboard.KeyReleased(Key.Space)
			mywfc.dofunction()
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

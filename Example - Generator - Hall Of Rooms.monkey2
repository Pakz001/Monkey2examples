#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class tile
	Field floorim:Image
	Field floorcan:Canvas
	Field tilewidth:Int
	Field tileheight:Int
	Method New(tw:Int,th:Int)
		floorim = New Image(tw,th)
		floorcan = New Canvas(floorim)		
		tilewidth = tw
		tileheight = th
		createfloor(floorcan)
	End Method
	' Here we create a procedural floor tile
	Method createfloor(canvas:Canvas)
		canvas.Clear(Color.Gold.Blend(Color.Black,.6))
		' Create a array
		Local t:Int[,] = New Int[tilewidth,tileheight]		
		' Create a set of numbers in the floor array
		For Local i:Int=0 Until tilewidth/2
			t[Rnd(tilewidth),Rnd(tileheight)] = 1
		Next
		' Loop a number of times
		For Local i:Int=0 Until tilewidth*tileheight*5
			' Get a random x and y position
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(tileheight)
			' If this position is a number
			If t[x,y] = 1
				' next to this location pick a location
				Local x2:Int=x+Rnd(-1,2)
				Local y2:Int=y+Rnd(-1,2)
				' Is it outside of the tile then skip
				If x2<0 Or y2<0 Or x2>=tilewidth Or y2>=tileheight Then Continue
				' New position is now also a number
				t[x2,y2] = 1
				' If the location is top or left of the tile
				' then copy it to the other side of the tile
				' to create a tileable effect
				If y2=0 Then t[x2,tileheight-1] = 1
				If x2=0 Then t[tilewidth-1,y2] = 1
				If y2=tileheight-1 Then t[x2,0] = 1
				If x2=tilewidth-1 Then t[0,y2] = 1
			End If
		Next
		' Draw the array into the tile
		For Local y:Int=0 Until tileheight
		For Local x:Int=0 Until tilewidth		
			If t[x,y] = 1 Then 
				' Create a color from brown with a random black blend
				canvas.Color = Color.Gold.Blend(Color.Black,Rnd(.3,.8))
				canvas.DrawPoint(x,y)
			End If
		Next
		Next
		canvas.Flush()
	End Method
	Method drawback(canvas:Canvas,x:Int,y:Int)
		Local v1:Float=(1.0/1000.0)*distance(0,240,0,y)		
		canvas.Color=Color.White.Blend(Color.Black,1.0-v1)
		canvas.DrawImage(floorim,x,y)
	End Method

	' Draw the floor
	Method drawfloor(canvas:Canvas,x:Int,y:Int)
		Local v1:Float=(1.0/240.0)*distance(0,240,0,y)		
		canvas.Color=Color.White.Blend(Color.Black,v1)
		canvas.DrawImage(floorim,x,y)
	End Method
    Function distance:Float(x1:Int,y1:Int,x2:Int,y2:Int)   
    	Return Abs(x2-x1)+Abs(y2-y1)   
    End Function	
End Class

' Here we have the map class, this generates a new map
' when (re)created and holds the data in map[]
Class map
	Field map:Int[,]
	Field width:Int,height:Int
	Field mapwidth:Int,mapheight:Int
	Field tilewidth:Int,tileheight:Int
	Method New(w:Int,h:Int,mw:Int,mh:Int)
		Self.width = w
		Self.height = h
		Self.mapwidth = mw
		Self.mapheight = mh
		map = New Int[mw,mh]
		tilewidth = Float(width) / Float(mapwidth)
		tileheight = Float(height) / Float(mapheight)
		generatemap()
	End Method
	Method generatemap()
		createmidsection()
		createrooms("up")
		createrooms("down")
	End Method
	Method createrooms(sec:String)
			
			' Create our rooms in the map in this list
			' the list will contain the room width's
			Local l:List<Int> = New List<Int>
			l.AddFirst(3)
			While listcnt(l) < mapwidth-1
				l.AddFirst(Rnd(3,6))
				If listcnt(l)+8>=mapwidth-1 Then l.AddFirst(mapwidth-listcnt(l)-1)
			Wend
			
			'our start and center vvariables
			Local s:Int=1
			Local dy:Int

			' are we making rooms for the upper halve
			' or the bottom halfe			
			If sec="up"
				dy=mapheight/2-1				
			Else
				dy=mapheight/2+1
			End If
			' Loop through each room in the list
			For Local i:=Eachin l
				'Draw the room from either up or bottom towards
				' the center
				For Local x:Int=s Until s+i-1
					If sec="up"
						For Local y:Int=mapheight/4 Until mapheight/2
							map[x,y] = 1				
						Next
					Else
						For Local y:Int=mapheight-mapheight/4 Until mapheight/2 Step -1
							map[x,y] = 1				
						Next
					End If
				Next
				' Create the corridors/rooms
				
				' if the room is size 3
				If i=3 Then 
					Local sw:Int=Rnd(0,2)
					map[s+sw,dy] = 0
				End If
				'if the room is size 4
				If i=4 Then 
					For Local z:Int=0 Until 3
						If Rnd(2)<1 Then map[s+z,dy] = 0
					Next
					map[s+Rnd(3),dy] = 1
				End If
				'if the room is greater then width 4
				If i>4
					Select Int(Rnd(10))
						Case 0,1,2'make only one door							
							For Local z:Int=0 Until i
								map[s+z,dy] = 0
							Next
							map[s+Rnd(i-1),dy] = 1
						Case 3,4,5'half of the room is door/open
							Local sz:Int
							Local ez:Int
							If Rnd(2)<1 Then 
								sz=0 
								ez=i/2
							Else 
								sz=i/2
								ez=i
							End if
							For Local z:Int=sz Until ez-1
								map[s+z,dy] = 0
							Next 
					End Select
				End If
				s+=i
			Next
	
	End Method
	'count up the size of the list
	Method listcnt:int(l:List<Int>)
		Local cnt:Int=0
		For Local i:=Eachin l
			cnt+=i
		Next
		
		Return cnt
	End Method
	Method createmidsection()
		For Local x:Int=1 Until mapwidth-1
			map[x,mapheight/2] = 1
		Next
	End Method
	Method draw(canvas:Canvas)
		canvas.Color = Color.Black
		For Local y:Int=0 Until mapheight
		For Local x:Int=0 Until mapwidth
			Local x2:Int=x*tilewidth
			Local y2:Int=y*tileheight
			If map[x,y] = 0
				mytile.drawback(canvas,x2,y2)
			End If
			If map[x,y] = 1
				mytile.drawfloor(canvas,x2,y2)
			End If
		Next
		Next
	End Method
End Class

Global mymap:map
Global mytile:tile

Class MyWindow Extends Window

	Method New()
		mymap = New map(Width,Height,20,20)
		mytile = New tile(Width/20,Height/20)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		canvas.Clear(Color.Black)				
		mymap.draw(canvas)
		If Keyboard.KeyReleased(Key.Space) Then 
			SeedRnd(Millisecs())
			mymap = New map(Width,Height,20,20)
			mytile = New tile(Width/20,Height/20)
		End If
		canvas.Color = Color.Red
		canvas.DrawText("Press space to create new map",0,0)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

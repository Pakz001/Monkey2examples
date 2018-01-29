#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


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
			If map[x,y] = 1
				canvas.DrawRect(x2,y2,tilewidth+1,tileheight+1)
			End If
		Next
		Next
	End Method
End Class

Global mymap:map

Class MyWindow Extends Window

	Method New()
		mymap = New map(Width,Height,20,20)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		canvas.Clear(New Color(.2,.2,.2))
		mymap.draw(canvas)
		If Keyboard.KeyReleased(Key.Space) Then 
			mymap = New map(Width,Height,20,20)
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

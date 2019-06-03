'Genetic algorithm map generator
' No mutation function...


#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Global mapwidth:Int=40
Global mapheight:Int=40

Class MyWindow Extends Window

	' This class stores our maps and turtle steps
	Class turtle
		Field x:List<Int> = New List<Int>
		Field y:List<Int> = New List<Int>		
		Field map:Int[,] = New Int[mapwidth,mapheight]
		Field score:Int
	End Class

	' This holds our genetic algorithm data
	Field maps:turtle[]
	' might not be needed
	Field sx:Int,sy:Int,ex:Int,ey:Int


	Method New()
		SeedRnd(Microsecs())
		
		' Create our random maps
		createourmaps()		
		
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 


		Local cnt:Int=0
		canvas.Color = Color.White
		For Local y:Int=0 Until 2
		For Local x:Int=0 Until 3
			For Local y2:Int=0 Until mapheight
			For Local x2:Int=0 Until mapwidth
				If maps[cnt].map[x2,y2] = 1
					canvas.DrawRect(x*180+(x2*4),y*170+(y2*4),4,4)
				End If
			Next
			Next
			cnt+=1 
		Next
		Next

		canvas.DrawText("Press space to generate new(genetic algorithm) maps...",0,460)
			
		' create new maps
		If Keyboard.KeyReleased(Key.Space) Then createourmaps()
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	

	Method createourmaps()
'		sx = Rnd(5,mapwidth-5)
'		sy = Rnd(5,mapheight-5)
'		ex = Rnd(5,mapwidth-5)
'		ey = Rnd(5,mapheight-5)
		sx = 3
		sy = 3
		ex = mapwidth-3
		ey = mapheight=3
		maps = New turtle[32]

		geneticcreatemaps()
		
	End Method

	Method geneticcreatemaps()
		' create 32 maps
		For Local i:Int=0 Until 32
			maps[i] = New turtle()
		Next
		' How many passes with creating new maps and storing the best scoring maps
		For Local cycle:Int=0 Until 140
			
			newmaps()
			
			' Save 10 best maps in banana
			Local banana:turtle[] = New turtle[10]
			For Local winners:Int=0 Until 10		
				' find highest number
				Local highestscore:Int=0
				Local highestnum:Int=0
				For Local j:Int=0 Until maps.Length
					If maps[j].score > highestscore
						highestscore=maps[j].score
						highestnum=j
					End If
				Next
				' store highest scoring
				banana[winners] = New turtle()
				For Local y:Int=0 Until mapheight
				For Local x:Int=0 Until mapwidth
					banana[winners].map[x,y] = maps[highestnum].map[x,y]
				Next
				Next		
				For Local z:=Eachin maps[highestnum].x			
					banana[winners].x.AddLast(z)
				Next
				For Local z:=Eachin maps[highestnum].y
					banana[winners].x.AddLast(z)
				Next
				banana[winners].score = maps[highestnum].score
				'reset score of highestnum
				maps[highestnum].score=0
			Next
			
			' put the best 10 into the maps
			For Local i:Int=0 Until 32
				maps[i] = New turtle()
				If i<10 Then 
					For Local y:Int=0 Until mapheight
					For Local x:Int=0 Until mapwidth
						maps[i].map[x,y] = banana[i].map[x,y]
					Next
					Next
					For Local z:=Eachin banana[i].x
						maps[i].x.AddLast(z)
					Next
					For Local z:=Eachin banana[i].y
						maps[i].y.AddLast(z)
					Next
					maps[i].score = banana[i].score
				End If
			Next

		Next	
	End Method

	' Create 32 new random maps.
	Method newmaps()			
		For Local j:Int=0 Until 32
		' if previously higher scoring maps are still present then keep these
		If maps[j].score>0 Then Continue 
		Local nx:Int=sx
		Local ny:Int=sy
		maps[j].x.AddLast(nx)
		maps[j].y.AddLast(ny)
		maps[j].map[nx,ny] = 1
		'step into new direction if possible to create map
		Local lastdir:Int
		For Local i:Int=0 To 500
			Local score:Int=0
			If Rnd()<.2 Then lastdir=Rnd(0,4)
			Select lastdir
				Case 0			
					If maps[j].map[nx,ny-2] = 0 Then 						
						If ny>2 Then ny-=1 ; score+=1 ; lastdir=0
					End If
				Case 1
					If maps[j].map[nx+2,ny] = 0 Then 		
						If nx<mapwidth-3 Then nx+=1; score+=1; lastdir=1
					End If
				Case 2
					If maps[j].map[nx,ny+2] = 0 Then 		
						If ny<mapheight-3 Then ny+=1; score+=1; lastdir=2
					End If
				Case 3
					If maps[j].map[nx-2,ny] = 0 Then 		
						If nx>2 Then nx-=1; score+=1; lastdir=3
					End If
			End Select
			' store the new map data
			maps[j].map[nx,ny] = 1
			maps[j].x.AddLast(nx)
			maps[j].y.AddLast(ny)
			' keep score
			' add one for length of tunnels
			maps[j].score+=score
			' if we step on the destination point then add to score
			If nx=ex And ny=ey Then maps[j].score+=100 ; Exit
		Next
		'Print "score : " + maps[j].score
		Next
	End Method 
	
	
End	Class

    ' Manhattan Distance (less precise)
    Function distance:Float(x1:Float,y1:Float,x2:Float,y2:Float)   
    Return Abs(x2-x1)+Abs(y2-y1)   
    End Function

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

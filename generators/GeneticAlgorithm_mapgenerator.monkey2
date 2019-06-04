'Genetic algorithm map generator



#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Global mapwidth:Int=40
Global mapheight:Int=40
Global numturtles:Int=50
Global numcycles:Int=10000
Global numturtlesteps:Int=1000


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

	Field working:Bool=False
	
	Method New()
		SeedRnd(Microsecs())
		
		' Create our random maps
		'createourmaps()		
		
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 

		If maps
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
		End If
		canvas.DrawText("Press space to generate new(genetic algorithm) maps...",0,420)
		canvas.DrawText("This can take a while. When done the top 3 maps are the result.",0,440)
		canvas.DrawText("The lower maps are random junk ones....",0,460)
			
		If working=True Then geneticcreatemaps()
			
		' create new maps
		If Keyboard.KeyReleased(Key.Space) Then 
			If working=True Then working=False Else working=True
			If working=True Then 
				createourmaps()
			End If
		End if
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
		maps = New turtle[numturtles]
		' create numturtles maps
		For Local i:Int=0 Until numturtles
			maps[i] = New turtle()
		Next

		
		
	End Method

	Method geneticcreatemaps()
		' How many passes with creating new maps and storing the best scoring maps
		'For Local cycle:Int=0 Until numcycles
			
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
					banana[winners].y.AddLast(z)
				Next
				banana[winners].score = maps[highestnum].score
				'reset score of highestnum
				maps[highestnum].score=0
			Next
			
			'copy 0 until 3 into 7 to 10
			Local cnt:Int=0
			For Local i:Int=7 Until 10
				For Local y:Int=0 Until mapheight
				For Local x:Int=0 Until mapwidth
					banana[i].map[x,y] = banana[cnt].map[x,y]
				Next
				Next
				banana[i].x.Clear()
				banana[i].y.Clear()
				For Local j:=Eachin banana[cnt].x
					banana[i].x.AddLast(j)
				Next
				For Local j:=Eachin banana[cnt].y
					banana[i].y.AddLast(j)
				Next
				banana[i].score = banana[cnt].score
				cnt+=1
			Next
			
			
			'Mutate 3 to 10
			For Local i:Int=3 Until 10
				
				' first erase the map
				For Local y:Int=0 Until mapheight
				For Local x:Int=0 Until mapwidth
					banana[i].map[x,y] = 0
				Next
				Next
				
				' erase from pos to length (turtle)
				Local llen:Int=banana[i].x.Count()
				Local start:Int=Rnd(5,llen/2)
				For Local j:Int=start Until llen
					banana[i].x.RemoveLast()
					banana[i].y.RemoveLast()
				Next
				
				' rebuild map to erased position
				Local lx:Int[] = banana[i].x.ToArray()
				
				Local ly:Int[] = banana[i].y.ToArray()
				
				
				For Local j:Int=0 Until lx.GetSize(0)
					banana[i].map[lx[j],ly[j]] = 1
				Next
				
				' create new map from
				Local lastdir:Int=0
				Local nx:Int=banana[i].x.Last,ny:Int=banana[i].y.Last
				
				
				For Local j:Int=0 Until numturtlesteps-start
		
					Local score:Int=0
					Local store:Bool=False
					If Rnd()<Rnd(0.1,0.3) Then lastdir=Rnd(0,4)
					Select lastdir
						Case 0			
							If banana[i].map[nx,ny-2] = 0 Then 						
								If ny>2 Then 
									ny-=1 ; score+=1 ; lastdir=0
									store=True
								End If
							End If
						Case 1
							If banana[i].map[nx+2,ny] = 0 Then 		
								If nx<mapwidth-3 Then 
									nx+=1; score+=1; lastdir=1
									store=True
								End if
							End If
						Case 2
							If banana[i].map[nx,ny+2] = 0 Then 		
								If ny<mapheight-3 Then 
									ny+=1; score+=1; lastdir=2
									store=true
								End If
							End If
						Case 3
							If banana[i].map[nx-2,ny] = 0 Then 		
								If nx>2 Then 
									nx-=1; score+=1; lastdir=3
									store=true
								End If
							End If
					End Select
					If store=True
						' store the new map data
						banana[i].map[nx,ny] = 1
						banana[i].x.AddLast(nx)
						banana[i].y.AddLast(ny)								
					End If
				Next
				banana[i].score = banana[i].x.Count()
				If banana[i].map[ex,ey] = 1 Then banana[i].score += 100
				
				
			Next			
			
			
			' put the best 10 into the maps
			For Local i:Int=0 Until numturtles
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
			
			If Rnd()<0.01
			' print scores
			For Local i:Int=0 Until 10
				Print banana[i].score
			Next
			Print "....."
			End If
			
		'Next
		
		
			
	End Method

	' Create numturtles new random maps.
	Method newmaps()			
		For Local j:Int=0 Until numturtles
		' if previously higher scoring maps are still present then keep these
		If maps[j].score>0 Then Continue 
		Local nx:Int=sx
		Local ny:Int=sy
		maps[j].x.AddLast(nx)
		maps[j].y.AddLast(ny)
		maps[j].map[nx,ny] = 1
		'step into new direction if possible to create map
		Local lastdir:Int
		For Local i:Int=0 To numturtlesteps
			Local score:Int=0
			Local store:Bool=False
			If Rnd()<Rnd(0.1,0.3) Then lastdir=Rnd(0,4)
			Select lastdir
				Case 0			
					If maps[j].map[nx,ny-2] = 0 Then 						
						If ny>2 Then ny-=1 ; score+=1 ; lastdir=0;store=True
					End If
				Case 1
					If maps[j].map[nx+2,ny] = 0 Then 		
						If nx<mapwidth-3 Then nx+=1; score+=1; lastdir=1;store=true
					End If
				Case 2
					If maps[j].map[nx,ny+2] = 0 Then 		
						If ny<mapheight-3 Then ny+=1; score+=1; lastdir=2;store=true
					End If
				Case 3
					If maps[j].map[nx-2,ny] = 0 Then 		
						If nx>2 Then nx-=1; score+=1; lastdir=3;store=true
					End If
			End Select
			If store = True
				' store the new map data
				maps[j].map[nx,ny] = 1
				maps[j].x.AddLast(nx)
				maps[j].y.AddLast(ny)
				' keep score
				' add one for length of tunnels
				maps[j].score+=score
				' if we step on the destination point then add to score
				If nx=ex And ny=ey Then maps[j].score+=100 ; Exit
			End If
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

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global sw:Int,sh:Int

Class basegenerator
	Field w:Int,h:Int
	Field tw:Float,th:Float
	Field map:Int[,]
	Method New(w:Int,h:Int)
		Self.w = w
		Self.h = h
		Self.tw = Float(sw)/Float(w)
		Self.th = Float(sh)/Float(h)
		map = New Int[w,h]
		phase1(1,0)
		phase1(0,1)
		phase1(-1,0)
		phase1(0,-1)
		phase2()
	End Method
	'walls
	Method phase2()
		'flood fill to find edges and turn these into walls(2)
		Local ox:Stack<Int> = New Stack<Int>
		Local oy:Stack<Int> = New Stack<Int>
		Local cmap:Int[,] = New Int[w,h]
		ox.Push(0)
		oy.Push(0)
		cmap[0,0] = 1
		While ox.Length
			Local tx:Int=ox.Get(0)
			Local ty:Int=oy.Get(0)		
			ox.Erase(0)
			oy.Erase(0)
			For Local y:Int=-1 To 1
			For Local x:Int=-1 To 1
				Local nx:Int=tx+x
				Local ny:Int=ty+y
				If nx<0 Or nx>w-1 Or ny<0 Or ny>h-1 Then Continue
				If cmap[nx,ny] = 0 And map[nx,ny] = 0 
					ox.Push(nx)
					oy.Push(ny)
					cmap[nx,ny] = 1		
					Print Microsecs()
				End If
			Next
			Next
		Wend
		'
		For Local y:Int=0 Until h
		For Local x:Int=0 Until w
			If map[x,y]=1 
				For Local x1:Int=-1 To 1
				For Local y1:Int=-1 To 1
					If cmap[x+x1,y+y1] = 1 Then 
						map[x+x1,y+y1] = 2						
					End If
				Next
				Next
			End If
		Next
		Next
	End Method
	' roads
	' randomly draw lines into 1 of four directions and keep
	' doing this for a certain number of times
	Method phase1(xa:Int,ya:Int)
		' get center of map
		' (remember that maps can be temps and be later pasted
		' inside other maps)
		Local x:Int=w/2
		Local y:Int=h/2
		Local depth:Int=Rnd(6,20)
		For Local i:Int=0 Until depth
			Local d:Int=Rnd(5,10)
			Local dx:Int=Rnd(-2,2)			
			Local dy:Int=0
			If dx=0 And dy=0 Then dy=1
			If dy=1 And Rnd()<.5 Then dy=-dy

  			If xa<>0 Then dx = xa ; xa=0 ; ya=0 ; dy=0
			If ya<>0 Then dy = ya ; ya=0 ; xa=0 ; dx=0
			
			For Local i2:Int=0 Until d
				x+=dx
				y+=dy
				map[x,y] =1
				If x+8>w Then dx=-1;dy=0
				If x-8<0 Then dx=1;dy=0
				If y+8>h Then dy=-1;dx=0
				If y-8<0 Then dy=1;dx=0
			Next
		Next
	End Method
	Method drawmap(canvas:Canvas)
		For Local y:Int=0 Until h
		For Local x:Int=0 Until w
			If map[x,y] = 0 Then Continue
			Select map[x,y]
				Case 1
				canvas.Color = Color.White
				Case 2
				canvas.Color = Color.Grey
			End Select
			Local dx:Int=x*tw
			Local dy:Int=y*th
			canvas.DrawRect(dx,dy,tw+1,th+1)
		Next
		Next
	End Method
End Class



Class MyWindow Extends Window
	Field mymap:basegenerator
	Method New()
		SeedRnd(Microsecs())
		sw = Width
		sh = Height
		mymap = New basegenerator(50,50)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		
		mymap.drawmap(canvas)
		
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

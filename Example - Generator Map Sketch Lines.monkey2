#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class map
	Field tw:Float,th:Float
	Field w:Int,h:Int
	Field map:= New Int[1,1] 
	Method New(sw:float,sh:float,w:float,h:Float)		
		map = New Int[w,h]
		tw = sw/w
		th = sh/h		
		Self.w = w
		Self.h = h
		makethicksketchline(w/2,h/2,Rnd(Pi),Rnd(10,15))
		For Local i:=0 Until w*h/8
			Local x:Float=Rnd(2,w-4)
			Local y:Float=Rnd(2,h-4)
			Local cnt:Int
			For Local y1:=-3 To 3
			For Local x1:=-3 To 3
			If map[x+x1,y+y1] = 1
				cnt+=1
			End If
			Next
			Next
			If cnt>3 And cnt<15
			Local l:Float=Rnd(10,30)
			makethicksketchline(x,y,Rnd(TwoPi),l)
			End If
		Next
	End Method		
	Method makethicksketchline(x:Float,y:Float,angle:Float,length:Float)
		For Local y2:=-1 To 1
		For Local x2:=-1 To 1
			If Rnd()<.5
				makesketchline(x+x2,y+y2,angle,length)
			End If
		Next
		Next
	End Method
	Method makesketchline(x1:float,y1:Float,angle:Float,length:float)
		For Local i:=0 Until 6
			Local na:Float=Rnd(TwoPi/8)
		For Local ii:Float=length/i Until length Step 1			
			Local x2:Float=x1+(Cos(angle+na)*ii)
			Local y2:Float=y1+(Sin(angle+na)*ii)
			If x2>1 And x2<w-1 And y2>1 And y2<h-1
			map[x2,y2] = 1
			map[x2-1,y2-1] = 1
			End If
		Next
		Next
	End Method
	Method draw(canvas:Canvas)
		For Local y:=0 Until h
		For Local x:=0 Until w
			If map[x,y] = 0			
				canvas.Color = Color.Black
				canvas.DrawRect(x*tw,y*th,tw,th)
			End If 
			If map[x,y] = 1
				canvas.Color = Color.Grey
				canvas.DrawRect(x*tw,y*th,tw,th)
			End If 
			If map[x,y] = 2
				canvas.Color = Color.Blue
				canvas.DrawRect(x*tw,y*th,tw,th)
			End If 
		Next
		Next
	End Method 
End Class

Global mymap:map

Class MyWindow Extends Window
	field time:Int
	Method New()
		Title = "Map generater with sketch Line Function"
		mymap = New map(Width,Height,150,150)
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		time+=1
		If Mouse.ButtonReleased(MouseButton.Left) Or time>250
			time=0
			Local s:Int=Rnd(30,200)
			mymap = New map(Width,Height,s,s)
		End If
		mymap.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global sw:Int=640,sh:Int=480

Class worker
	Field x:Int,y:Int
	Field w:Float,h:Float
	Field pathmap:Int[,]
	Method New(x:Int,y:Int)
		' get our tile position
		Self.x = x
		Self.y = y
		w = myfarm.tw/2
		h = myfarm.th/2 
	End Method
	Method findpathtotree()
		'find a closeby tree
		'flood the map towards it
		'set flag that worker can move
	End Method
	Method draw(canvas:Canvas)
		canvas.Color = Color.White
		canvas.DrawOval(x*myfarm.tw+myfarm.tw/5,y*myfarm.th+myfarm.th/5,w,h)
	End Method
End Class

Class farm
	Field mw:Int,mh:Int 'map width and height
	Field tw:Float,th:Float 'tile width and height
	Field housex:Int,housey:Int 'house x and y
	Field map:Int[,] ' our map
	Method New(w:Int,h:Int)
		'get pur map width and height
		mw = w
		mh = h
		' get our map width and height
		map = New Int[w,h]
		' get our tile width and height
		tw = Float(sw) / Float(w)
		th = Float(sh) / Float(h)
		' plant our trees
		planttrees((mw*mh)/150)
		makeriver()
		placefarm()
		
	End Method
	Method draw(canvas:Canvas)
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			Local tmp:Int=map[x,y]
			Select tmp
				Case 3 ' water
					canvas.Color = Color.Blue
					canvas.DrawRect(x*tw,y*th,tw+1,th+1)
				Case 2 'our trees
					canvas.Color = Color.Green.Blend(Color.Brown,.5)
					canvas.DrawRect(x*tw,y*th,tw+1,th+1)
					canvas.Color = Color.Green.Blend(Color.White,.5)
					canvas.DrawTriangle(x*tw+tw/2,y*th,x*tw,y*th+th,x*tw+tw,y*th+th)										
				Case 1 'our farm
					canvas.Color = Color.Brown
					canvas.DrawRect(x*tw,y*th,tw+1,th+1)
				Case 0 'our grass/sand
					canvas.Color = Color.Green.Blend(Color.Brown,.5)
					canvas.DrawRect(x*tw,y*th,tw+1,th+1)
			End Select			
		Next
		Next
	End Method
	
	Method placefarm()
		Repeat
			' position the house
			housex = Rnd(6,mw-6)
			housey = Rnd(6,mh-6)
			Local failed:Bool=False
			' if the area below is trees or ground then go ahead
			For Local y:Int=housey-3 To housey+3
			For Local x:Int=housex-3 To housex+3
				If map[x,y] = 3 Then failed=True
			Next
			next
			If failed = False
				' put our farm there
				For Local y:Int=housey-3 To housey+3
				For Local x:Int=housex-3 To housex+3
					map[x,y] = 0
				Next
				Next		
				map[housex,housey] = 1
				Exit
			End If
		Forever
	End Method

	Method makeriver()
		'get a point on the map and draw 2 lines into a wavy direction until
		' they exit the map
		Local x1:Float=Rnd(5,mw-5) 'riverdirection 1
		Local y1:Float=Rnd(5,mh-5)
		Local x2:Float=x1 'riverdirection 2
		Local y2:Float=y1		
		Local angle1:Float=Rnd(TwoPi)
		Local angle2:Float=Rnd(TwoPi)
		Local riverwidth:Int=1
		'RIVER DIRECTION 1
		Repeat
			x1+=Cos(angle1)
			y1+=Sin(angle1)
			angle1+=Rnd(-.3,.3)
			If x1<0 Or y1<0 Or x1>=mw Or y1>= mh Then Exit
			' here we create the river in the map
			map[x1,y1] = 3
			' every now and then change the width of the river
			If Rnd()<.2 Then riverwidth=Rnd(1,3)
			For Local by:Int=y1-riverwidth To y1+riverwidth
			For Local bx:Int=x1-riverwidth To x1+riverwidth
				If bx>=0 And bx<mw And by>=0 And by<mh Then map[bx,by] = 3
			Next
			Next
		Forever
		'RIVER DIRECTION 2
		Repeat
			x2+=Cos(angle2)
			y2+=Sin(angle2)
			angle2+=Rnd(-.3,.3)
			If x2<0 Or y2<0 Or x2>=mw Or y2>= mh Then Exit
			' here we create the river in the map
			map[x2,y2] = 3
			' every now and then change the width of the river
			If Rnd()<.2 Then riverwidth=Rnd(1,3)
			For Local by:Int=y2-riverwidth To y2+riverwidth
			For Local bx:Int=x2-riverwidth To x2+riverwidth
				If bx>=0 And bx<mw And by>=0 And by<mh Then map[bx,by] = 3
			Next
			Next
		Forever
		
	End Method
	' this method create pathches of trees on the map. We do this
	' by creating a couple of tree lines and then growing around those.
	Method planttrees(num:Int)
		' draw some lines with trees
		For Local i:Int=0 Until num
			Local x:Float=Rnd(mw)
			Local y:Float=Rnd(mh)
			Local treegrowline:Int=Rnd(5,40)
			Local angle:Float = Rnd(TwoPi)
			For Local j:Int=0 Until treegrowline
				If x+Cos(angle)>=0 And x+Cos(angle)<mw-1 Then x+=Cos(angle)
				If y+Sin(angle)>=0 And y+Sin(angle)<mh-1 Then y+=Sin(angle)
				If Rnd()<.5 And map[x,y] = 0 Then map[x,y] = 2
			Next				
		Next
		'grow the trees 
		For Local i:Int=0 Until mw*mh
			Local x:Int=Rnd(mw)
			Local y:Int=Rnd(mh)
			If map[x,y] = 2
				If x-1>=0 And map[x-1,y] = 0 Then map[x-1,y] = 2
				If x+1<mw And map[x+1,y] = 0 Then map[x+1,y] = 2
				If y-1>=0 And map[x,y-1] = 0 Then map[x,y-1] = 2
				If y+1<mh And map[x,y+1] = 0 Then map[x,y+1] = 2
			End If
		Next
	End Method
End Class

Global myfarm:farm
Global myworker:List<worker> = New List<worker>

Class MyWindow Extends Window

	Method New()
		SeedRnd(Microsecs())
		newmap()
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		
		myfarm.draw(canvas)
		For Local i:=Eachin myworker
			i.draw(canvas)
		Next
		
		' If press space then new map
		If Keyboard.KeyReleased(Key.Space) Then newmap()
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	Method newmap()
		myfarm = New farm(32,32)
		myworker.Clear()
		myworker.Add(New worker(myfarm.housex,myfarm.housey))
		
	End Method
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

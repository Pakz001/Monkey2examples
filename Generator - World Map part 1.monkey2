#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class world
	Field mapwidth:Int,mapheight:Int
	Field map:Int[,]
	Field tilewidth:Float,tileheight:Float
	Field tileim:Image[] = New Image[10]
	Field tilecan:Canvas[] = New Canvas[10]
	Method New(mapwidth:Int,mapheight:Int,tilewidth:Float,tileheight:Float)
		Self.mapwidth = mapwidth
		Self.mapheight = mapheight
		map = New Int[mapwidth,mapheight]
		Self.tilewidth = tilewidth
		Self.tileheight = tileheight
		generatetiles()
	End Method
	Method draw(canvas:Canvas)
		canvas.DrawImage(tileim[0],320,200,0,2,2)
		canvas.DrawImage(tileim[1],320+tilewidth*2,200,0,2,2)
		canvas.DrawImage(tileim[2],320-tilewidth*2,200,0,2,2)
		canvas.DrawImage(tileim[3],320,200-tileheight*2,0,2,2)
		canvas.DrawImage(tileim[4],320,200+tileheight*2,0,2,2)
	End Method
	Method generatetiles()
		For Local i:Int=0 Until 10
			tileim[i] = New Image(tilewidth,tileheight)
			tileim[i].Handle = New Vec2f(0,0)
			tilecan[i] = New Canvas(tileim[i])
			tilecan[i].Clear(Color.Blue)
			tilecan[i].Flush()
		Next
		tilecan[0].Clear(Color.Green)
		generateshores()
	End Method
	'tile 
	'1-shore on left side of tile
	'2-shore of right side of tile
	'3-
	'4-
	Method generateshores()
		'shore on the right side 		
		Local left:Int=0
		Local right:Int=tilewidth
		Local top:Int=0
		Local bottom:Int=tileheight
		Local y:Float=0
		Local x:Float=0
		Local a:Float=Pi/2
		Local c:Float=0
		Local t:Int=1'tile
		While y<bottom
			' draw the shore
			For Local z:Int=0 To x
				tilecan[t].Color = Color.Green
				tilecan[t].DrawPoint(z,y)
			Next
			'Left to right sand up not including sea
			tilecan[t].Color = Color.Brown.Blend(Color.Black,.3)
			tilecan[t].DrawPoint(x,y)
			tilecan[t].Color = Color.Brown.Blend(Color.White,.1)
			tilecan[t].DrawPoint(x+1,y)
			tilecan[t].Color = Color.Brown.Blend(Color.White,.8)
			tilecan[t].DrawPoint(x+2,y)
			If Rnd()<.5 Then 
				tilecan[t].Color = Color.Brown.Blend(Color.Black,.5)
			Else 
				tilecan[t].Color = Color.Brown.Blend(Color.White,.5)
			End If
			tilecan[t].DrawPoint(x+3,y)
			'sea
			tilecan[t].Color = Color.Blue.Blend(Color.White,.6)
			tilecan[t].DrawPoint(x+4,y)
			tilecan[t].Color = Color.Blue.Blend(Color.White,.5)
			tilecan[t].DrawPoint(x+5,y)
			' move the point
			c+=Rnd(-2,2)
			If c<-Pi/2 Or c>Pi/2 Then c=0
			If y<7 Or y>bottom-7 Then c=0
			x+=Cos(a+c)
			y+=Sin(a+c)
			If y<7 Or y>bottom-7
				If x<left Then x+=1
				If x>left Then x-=1
			endif
			If x<0 Then x=0
		Wend
		tilecan[t].Flush()

		'shore on the right side 		
		left=0
		right=tilewidth
		top=0
		bottom=tileheight
		y=0
		x=right
		a=Pi/2
		c=0
		t=2'tile
		While y<bottom
			' draw the shore
			For Local z:Int=right To x Step -1
				tilecan[t].Color = Color.Green
				tilecan[t].DrawPoint(z,y)
			Next
			'Left to right sand up not including sea
			tilecan[t].Color = Color.Brown.Blend(Color.Black,.3)
			tilecan[t].DrawPoint(x,y)
			tilecan[t].Color = Color.Brown.Blend(Color.White,.1)
			tilecan[t].DrawPoint(x-1,y)
			tilecan[t].Color = Color.Brown.Blend(Color.White,.8)
			tilecan[t].DrawPoint(x-2,y)
			If Rnd()<.5 Then 
				tilecan[t].Color = Color.Brown.Blend(Color.Black,.5)
			Else 
				tilecan[t].Color = Color.Brown.Blend(Color.White,.5)
			End If
			tilecan[t].DrawPoint(x-3,y)
			'sea
			tilecan[t].Color = Color.Blue.Blend(Color.White,.6)
			tilecan[t].DrawPoint(x-4,y)
			tilecan[t].Color = Color.Blue.Blend(Color.White,.5)
			tilecan[t].DrawPoint(x-5,y)
			' move the point
			c+=Rnd(-2,2)
			If c<-Pi/2 Or c>Pi/2 Then c=0
			If y<7 Or y>bottom-7 Then c=0
			x+=Cos(a+c)
			y+=Sin(a+c)
			If y<7 Or y>bottom-7
				If x<right Then x+=1
				If x>right Then x-=1
			endif
			If x>right Then x=right
		Wend
		tilecan[t].Flush()

		'shore on the bottom side 		
		left=0
		right=tilewidth
		top=0
		bottom=tileheight
		y=bottom
		x=0
		a=0
		c=0
		t=3'tile
		Local cnt:Int=0
		While x<right
			cnt+=1
			If cnt>10000 Then Exit
			' draw the shore
			For Local z:Int=bottom To y Step -1
				tilecan[t].Color = Color.Green
				tilecan[t].DrawPoint(x,z)
			Next
			'Left to right sand up not including sea
			tilecan[t].Color = Color.Brown.Blend(Color.Black,.3)
			tilecan[t].DrawPoint(x,y)
			tilecan[t].Color = Color.Brown.Blend(Color.White,.1)
			tilecan[t].DrawPoint(x,y-1)
			tilecan[t].Color = Color.Brown.Blend(Color.White,.8)
			tilecan[t].DrawPoint(x,y-2)
			If Rnd()<.5 Then 
				tilecan[t].Color = Color.Brown.Blend(Color.Black,.5)
			Else 
				tilecan[t].Color = Color.Brown.Blend(Color.White,.5)
			End If
			tilecan[t].DrawPoint(x,y-3)
			'sea
			tilecan[t].Color = Color.Blue.Blend(Color.White,.6)
			tilecan[t].DrawPoint(x,y-4)
			tilecan[t].Color = Color.Blue.Blend(Color.White,.5)
			tilecan[t].DrawPoint(x,y-5)
			' move the point
			c+=Rnd(-2,2)
			If c<-Pi/2 Or c>Pi/2 Then c=0
			If x<7 Or x>right-7 Then c=0
			x+=Cos(a+c)
			y+=Sin(a+c)
			If x<7 Or x>right-7
				If y>bottom Then y-=1
				If y<bottom Then y+=1
			endif
			If y>bottom Then y=bottom
		Wend
		tilecan[t].Flush()


		'shore on the top side 		
		left=0
		right=tilewidth
		top=0
		bottom=tileheight
		y=top
		x=0
		a=0
		c=0
		t=4'tile
		cnt=0
		While x<right
			cnt+=1
			If cnt>10000 Then Exit
			' draw the shore
			For Local z:Int=0 To y
				tilecan[t].Color = Color.Green
				tilecan[t].DrawPoint(x,z)
			Next
			'Left to right sand up not including sea
			tilecan[t].Color = Color.Brown.Blend(Color.Black,.3)
			tilecan[t].DrawPoint(x,y)
			tilecan[t].Color = Color.Brown.Blend(Color.White,.1)
			tilecan[t].DrawPoint(x,y+1)
			tilecan[t].Color = Color.Brown.Blend(Color.White,.8)
			tilecan[t].DrawPoint(x,y+2)
			If Rnd()<.5 Then 
				tilecan[t].Color = Color.Brown.Blend(Color.Black,.5)
			Else 
				tilecan[t].Color = Color.Brown.Blend(Color.White,.5)
			End If
			tilecan[t].DrawPoint(x,y+3)
			'sea
			tilecan[t].Color = Color.Blue.Blend(Color.White,.6)
			tilecan[t].DrawPoint(x,y+4)
			tilecan[t].Color = Color.Blue.Blend(Color.White,.5)
			tilecan[t].DrawPoint(x,y+5)
			' move the point
			c+=Rnd(-2,2)
			If c<-Pi/2 Or c>Pi/2 Then c=0
			If x<7 Or x>right-7 Then c=0
			x+=Cos(a+c)
			y+=Sin(a+c)
			If x<7 Or x>right-7
				If y>top Then y-=1
				If y<top Then y+=1
			endif
			If y<0 Then y=0
		Wend
		tilecan[t].Flush()


	End Method
End Class

Global myworld:world

Class MyWindow Extends Window
		
	Method New()
		myworld = New world(100,100,32,32)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		myworld.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function


#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


' Our gfx
Global shipim:Image
Global shipcan:Canvas
Global rockim:Image
Global rockcan:Canvas

Class ship
	' tilemap
	Field map:Int[,]
	Field tilew:Int=48
	Field tileh:Int=48
	'ship
    Field x:Float,y:Float
	Field incx:Float,incy:Float
	Field thrust:Float,thrustmax:Float=2
	Field angle:Float
	Field maxspeed:Float=2
   	Method New(x:Float,y:Float,angle:Float)
	   	map = New Int[512,512]
	   	generatemap()
		Self.x = x
		Self.y = y
		Self.angle = angle
	End Method
	
	Method update()		
		
		If thrust>0 Then thrust-=.01

	End Method
	Method controls()
		' turn
		If Keyboard.KeyDown(Key.Right) Then angle-=.1
		If Keyboard.KeyDown(Key.Left) Then angle+=.1
		If angle<0 Then angle+=TwoPi
		If angle>TwoPi Then angle-=TwoPi
		' thrust (inc)
		If Keyboard.KeyDown(Key.Up) Then 
			thrust+=.015
			If thrust>thrustmax Then thrust=thrustmax
			Local nvx:Float = incx+Cos(angle)*thrust
			Local nvy:Float = incy+Sin(angle)*thrust
			'get the angle of the new nvx and nvy
			Local nangle:Float = ATan2(nvy,nvx) 'get the angle from the movement variables
			'get the distance traveled from location of ship and the location with the movement added
			Local dist:Float = edistance(x,y,x+nvx,y+nvy)
			' If the movement is larger than max then limit
			If Abs(dist) > maxspeed	Then
				incx = Cos(nangle)*maxspeed
				incy = Sin(nangle)*maxspeed
				Else
				'if the movement is within bounds then update the inc variables
				incx = nvx
				incy = nvy
			End If			
		End If
        x+=incx
        y-=incy
	End Method
	Method generatemap()	
		' center of map set to 256,256
		
		'create asteroid by growing pixels
		map[256,256] = 1
		For Local i:Int=0 Until 1000*1000
			Local x:Int=256+Rnd(-100,100)
			Local y:Int=256+Rnd(-100,100)
			If map[x,y] = 1 Then 
				For Local y2:Int=-1 To 1
				For Local x2:Int=-1 To 1
					map[x+x2,y+y2] = 1
				Next
				Next
			End If
		Next
		
		Local point:Stack<Vec2i> = New Stack<Vec2i>
		Local numpoints:Int=32
		For Local i:Int=0 Until numpoints
			point.Push(New Vec2i(256-Rnd(-100,100),256+Rnd(-100,100)))
		Next
		For Local i:Int=1 Until point.Length
			'carve
			Local x1:Int=point.Get(i-1).x
			Local y1:Int=point.Get(i-1).y
			Local x2:Int=point.Get(i).x
			Local y2:Int=point.Get(i).y
			While x1<>x2 And y1<>y2
				If x1<x2 Then x1+=1
				If x1>x2 Then x1-=1
				If y1<y2 Then y1+=1
				If y1>y2 Then y1-=1
				Local s:Int=1
				If Rnd()<.1 Then s=Rnd(2,3)
				For Local y:Int=-s To s
				For Local x:Int=-s To s
				map[x1+x,y1+y] = 0
				Next
				Next
			Wend
			
		Next
		
	End Method
	Method drawmap(canvas:Canvas)
		Local offx:Int=x/tilew
		Local offy:Int=y/tileh
		Local poffx:Int = (offx*tilew)-x
		Local poffy:Int = (offy*tileh)-y
		For Local my:Int=0 Until 16
		For Local mx:Int=0 Until 24
			If map[offx+mx,offy+my] = 1
				canvas.Color=Color.White
				'canvas.DrawRect(0+mx*tilew+poffx,0+my*tileh+poffy,tilew,tileh)
				canvas.DrawImage(rockim,0+mx*tilew+poffx,0+my*tileh+poffy)
			End If
		Next
		Next
	End Method
End Class

Class MyWindow Extends Window
	' The c64 palette (16 colors)
	Field c64color:Color[]
	' Our classes
	Field myship:ship
	Method New()
		'Setup our images so they can be drawn
		setupim()
		myship = New ship(256*48,256*48,0)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		myship.update()
		myship.controls()
		'
		myship.drawmap(canvas)
		canvas.Color = Color.White
		canvas.DrawImage(shipim,320,240,myship.angle)
		canvas.DrawText("angle : "+myship.angle,0,0)
		canvas.DrawText("thrust : "+myship.thrust,0,15)
		canvas.DrawText("incx and incy : "+myship.incx+","+myship.incy,0,25)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
	
	
	'
	' Holds and set up the gfx data.
	Method setupim()
		inic64colors()
		shipim = New Image(32,32)
		shipcan = New Canvas(shipim)
		shipim.Handle = New Vec2f(0.5,0.5)
		rockim = New Image(48,48)
		rockcan = New Canvas(rockim)

Local map := New Int[][] (
New Int[](1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
New Int[](0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0),
New Int[](0,1,12,1,1,1,0,0,0,0,0,0,0,0,0,0),
New Int[](0,1,12,1,1,1,1,1,1,0,0,0,0,0,0,0),
New Int[](0,1,12,11,1,1,1,1,1,1,1,0,0,0,0,0),
New Int[](0,1,1,1,1,12,1,1,1,1,1,1,1,0,0,0),
New Int[](0,11,1,1,1,11,1,1,1,1,1,1,1,1,1,0),
New Int[](0,11,1,1,1,1,1,11,1,1,1,1,11,12,1,1),
New Int[](0,11,1,1,1,1,1,11,1,1,1,1,11,12,1,1),
New Int[](0,11,1,1,1,11,1,1,1,1,1,1,1,1,1,0),
New Int[](0,1,1,1,1,12,1,1,1,1,1,1,1,0,0,0),
New Int[](0,1,12,11,1,1,1,1,1,1,1,0,0,0,0,0),
New Int[](0,1,12,1,1,1,1,1,1,0,0,0,0,0,0,0),
New Int[](0,1,12,1,1,1,0,0,0,0,0,0,0,0,0,0),
New Int[](0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0),
New Int[](1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0))		
		For Local y:Int=0 Until 16
		For Local x:Int=0 Until 16
			shipcan.Color = c64color[map[y][x]]
			shipcan.DrawRect(x*2,y*2,2,2)
		Next
		Next
		shipcan.Flush()

map = New Int[][] (
New Int[](12,11,12,12,15,15,15,15,15,15,15,15,15,15,15,15),
New Int[](15,15,15,15,15,15,15,15,15,15,15,15,15,1,12,15),
New Int[](15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15),
New Int[](15,15,15,15,15,15,15,15,15,15,15,12,12,15,15,15),
New Int[](15,15,15,12,1,15,15,15,15,1,12,11,15,15,15,15),
New Int[](15,15,15,15,12,1,15,15,15,15,12,15,15,15,15,15),
New Int[](15,15,15,15,15,12,15,15,15,15,15,15,15,15,15,15),
New Int[](15,15,15,15,15,11,12,15,15,15,15,15,15,15,15,12),
New Int[](12,15,15,15,15,15,15,12,15,15,15,15,15,12,15,15),
New Int[](15,15,15,15,15,15,15,11,12,15,15,15,15,15,15,15),
New Int[](15,15,15,15,15,1,15,15,15,15,15,15,15,1,15,15),
New Int[](15,15,15,11,12,12,15,15,15,15,15,15,12,12,1,15),
New Int[](15,15,15,12,15,15,15,15,15,15,15,15,15,12,12,15),
New Int[](15,15,11,12,1,15,15,15,15,15,15,15,12,11,12,15),
New Int[](12,11,15,15,1,15,15,15,15,15,15,15,12,11,12,15),
New Int[](12,15,15,12,15,15,15,15,15,15,15,15,15,15,12,12))
		For Local y:Int=0 Until 16
		For Local x:Int=0 Until 16
			rockcan.Color = c64color[map[y][x]]
			rockcan.DrawRect(x*3,y*3,3,3)
		Next
		Next
		rockcan.Flush()

End Method
	'
	' This is the palette used for the graphics... 
	Method inic64colors()
		c64color = New Color[16]
		c64color[0 ] = New Color(intof(0)  ,intof(0)  ,intof(0)  )'Black
		c64color[1 ] = New Color(intof(255),intof(255),intof(255))'White
		c64color[2 ] = New Color(intof(136),intof(0)  ,intof(0)  )'Red
		c64color[3 ] = New Color(intof(170),intof(255),intof(238))'Cyan
		c64color[4 ] = New Color(intof(204),intof(68) ,intof(204))'Violet / Purple
		c64color[5 ] = New Color(intof(0)  ,intof(204),intof(85) )'Green
		c64color[6 ] = New Color(intof(0)  ,intof(0)  ,intof(170))'Blue
		c64color[7 ] = New Color(intof(238),intof(238),intof(119))'Yellow
		c64color[8 ] = New Color(intof(221),intof(136),intof(85) )'Orange
		c64color[9 ] = New Color(intof(102),intof(68) ,intof(0)  )'Brown
		c64color[10] = New Color(intof(255),intof(119),intof(119))'Light red
		c64color[11] = New Color(intof(51) ,intof(51) ,intof(51) )'Dark grey / Grey 1
		c64color[12] = New Color(intof(119),intof(119),intof(119))'Grey 2
		c64color[13] = New Color(intof(170),intof(255),intof(102))'Light green
		c64color[14] = New Color(intof(0)  ,intof(136),intof(255))'Light blue
		c64color[15] = New Color(intof(187),intof(187),intof(187))'Light grey / grey 3
	End Method
	' convert int(0.255) to float(0.1)
	Function intof:Float(a:Int)
		Return 1.0/255.0*a
	End Function
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function


Function edistance:Float(x1:Float,y1:Float,x2:Float,y2:Float) 
	Return Sqrt( (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2) )
End Function

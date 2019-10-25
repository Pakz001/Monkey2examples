
#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class ship
    Field x:Float,y:Float
	Field incx:Float,incy:Float
	Field thrust:Float,thrustmax:Float=2
	Field angle:Float
	Field maxspeed:Float=2
   	Method New(x:Float,y:Float,angle:Float)
		Self.x = x
		Self.y = y
		Self.angle = angle
	End Method
	Method update()		
		
		If thrust>0 Then thrust-=.01
		'If incx>0 Then incx-=.03
		'If incy>0 Then incy-=.03
	End Method
	Method controls()
		' turn
		If Keyboard.KeyDown(Key.Right) Then angle-=.1
		If Keyboard.KeyDown(Key.Left) Then angle+=.1
		If angle<0 Then angle+=TwoPi
		If angle>TwoPi Then angle-=TwoPi
		' thrust (inc)
		If Keyboard.KeyDown(Key.Up) Then 
			thrust+=.03			
			If thrust>thrustmax Then thrust=thrustmax
			For Local i:Float=0 Until thrust Step .1
			incx += Cos(angle)*.1
			incy += Sin(angle)*.1
			If incx<-maxspeed Or incx>maxspeed Then Exit
			If incy<-maxspeed Or incy>maxspeed Then Exit
			Next
			
		End If
        x+=incx
        y-=incy
	End Method
End Class

Class MyWindow Extends Window
	' Our gfx
	Field shipim:Image
	Field shipcan:Canvas
	' The c64 palette (16 colors)
	Field c64color:Color[]
	' Our classes
	Field myship:ship
	Method New()
		'Setup our images so they can be drawn
		setupim()
		myship = New ship(100,100,0)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		myship.update()
		myship.controls()
		'
		canvas.DrawImage(shipim,myship.x,myship.y,myship.angle)
		canvas.DrawText(myship.angle,0,0)
		canvas.DrawText(myship.thrust,0,15)
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

' Thanks to Blitzcoder for the functions
';= Get horizontal size of vector using distance and angle
Function vectorx:Float(distance:Float,angle:Float)
    Return Sin(angle)*distance
End Function
';= Get vertical size of vector using distance and angle
Function vectory:Float(distance:Float,angle:Float)
    Return Sin(angle-(90/180*Pi))*distance
End Function
';= Get True length of a vector
Function vectordistance:Float(x:Float,y:Float)
    Return Sqrt(x*x+y*y)
End Function
';= Get True angle of a vector
Function vectorangle:Float(x:Float,y:Float)
    Return -ATan2(x,y)+(180*(180/Pi))
End Function

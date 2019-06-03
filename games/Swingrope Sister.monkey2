'
'  Thanks to Daniel SHiffman (book - nature of code)
'
' This example might be usable in platformer games (rope and swing)
' 

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global screenwidth:Int=640,screenheight:Int=480

Class game 
	Field map:Int[,] ' our actual tile map
	Field dmap:String[] ' our map for edit
	Field mw:Int,mh:Int ' map width and height
	Field camerax:Int,cameray:Int ' view
	Field tw:Float=32,th:Float=32 ' tile widht and hegiht
	Field tilesx:Int,tilesy:Int 'number of tiles on the screen
	Method New()
		dmap = New String[10]
		dmap[0] = "111111111111111111111111111111111111111111111111111111111111111"
		dmap[1] = "111111111111111111111111111111110000000000000000000000000000001"
		dmap[2] = "111111111111111111111111111111110000000000000000000000000000001"
		dmap[3] = "111111111111110000000000000000000000000000000000000000000000001"
		dmap[4] = "111111111111110000000000000000000000000000000000000000000000001"
		dmap[5] = "100000000000000000000000000011111111000000111111000000000000001"
		dmap[6] = "100000000000000000000000000011111111000000111111000000001111111"
		dmap[7] = "111111111111111110000111111111111111000000111111000000001111111"
		dmap[8] = "111111111111111110000111111111111111000000111111000000001111111"
		dmap[9] = "111111111111111111111111111111111111111111111111111111111111111"
		mw = dmap[0].Length
		mh = dmap.GetSize(0)
		map = New Int[mw,mh]
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			If dmap[y][x] = 49 Then map[x,y] = 1
		Next
		Next
		tilesx = screenwidth/tw
		tilesy = screenheight/th
	End Method
	Method update()
		If Keyboard.KeyDown(Key.Right)  Then camerax+=3
		If Keyboard.KeyDown(Key.Left)  Then camerax-=3
	End Method
	Method draw(canvas:Canvas)
		Local tx:Int=camerax/tw
		Local ty:Int=cameray/th
		Local offx:Int=tx*tw-camerax
		Local offy:Int=ty*th-cameray
		For Local y:Int=0 Until tilesy+1
		For Local x:Int=0 Until tilesx+1			
			
			If x+tx<0 Or y+ty<0 Or x+tx>=mw Or y+ty>=mh Then Continue
			Select map[x+tx,y+ty]
				Case 0
					canvas.Color = Color.Blue
					canvas.DrawRect(x*tw+offx,y*th+offy,tw,th)
				Case 1
					'Print Microsecs()
					canvas.Color = Color.White
					canvas.DrawRect(x*tw+offx,y*th+offy,tw,th)
			End Select
		Next
		Next
	End Method
End Class


Class MyWindow Extends Window

	Field mygame:game

	' player x and y and width and height
	Field px:Float=100,py:Float=200
	Field pw:Int=32,ph:Int=32
	
	'our anchor x and y
	Field ax:Int=320,ay:Int=0

	Field angle:Float 'our angle between anchor and player	
	Field dist:Float 'distance between anchor and player
	Field acc:Float,vel:Float 'acceleration and velocity
	Field gravity:Float=0.4 ' 
	Field damping:Float=0.995 'slowdown
	Field r:Float 'distance between anchor and player
	Method New()
		
		mygame = New game()
		
		' Get the angle betweem the player and the anchor
		angle = getangle(px,py,ax,ay)		
		' Get the distgance between the player and anchor
		r = distance(px,py,ax,ay)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		
		' swing harder
		If Keyboard.KeyReleased(Key.Right) Then vel+=.005
		If Keyboard.KeyReleased(Key.Left) Then vel-=.005
		' CLimb up or down..
		If Keyboard.KeyDown(Key.Up) Then r-=2
		If Keyboard.KeyDown(Key.Down) Then r+=2
		
		' Do the swing math
		acc=(-1*gravity/r)*Sin(angle)
		vel+=acc
		angle+=vel		
		vel*=damping
		
		' update our position
		px = r*Sin(angle)		
		py = r*Cos(angle)
		px+=ax
		py+=ay

		' draw our map
		mygame.update()
		mygame.draw(canvas)


		' Draw our player
		'canvas.DrawRect(px,py,pw,ph)
		'canvas.DrawLine(px+pw/2,py,ax,ay)
		
		canvas.DrawText("Press cursor left and right to apply force..",0,0)
		canvas.DrawText("Hold cursor Up Down to climb or Lower yourself..",0,20)
		
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

' Return the angle from - to in float
Function getangle:Float(x1:Int,y1:Int,x2:Int,y2:Int)
	Return ATan2(y2-y1, x2-x1)
End Function

' Manhattan Distance (less precise)
Function distance:Float(x1:Float,y1:Float,x2:Float,y2:Float)   
	Return Abs(x2-x1)+Abs(y2-y1)   
End Function

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

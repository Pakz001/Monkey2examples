
' Todo - PLayer aims rope and shoots it to ceiling
' 		player jumps and can swing
'       player can release rope
'       


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
	' player variables
	Field px:Float,py:Float
	Field pw:Float,ph:Float
	'player gravity
	Field isjumping:Bool,grav:Float=.35
	Field movey:Float

	'our rope variabes
	'our anchor x and y
	Field rax:Double=600,ray:Double=0

	Field swingrelease:Int
	Field standswing:Bool=False
	Field inswing:Bool=False
	Field rangle:Double 'our angle between anchor and player	
	Field rdist:Double 'distance between anchor and player
	Field racc:Double,rvel:Double 'acceleration and velocity
	Field rgravity:Double=0.4 ' 
	Field rdamping:Double=0.995 'slowdown
	Field r:Double 'distance between anchor and player

	
	' map variables
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
		dmap[6] = "10p000000000000000000000000011111111000000111111000000001111111"
		dmap[7] = "111111111111111110000111111111111111000000111111000000001111111"
		dmap[8] = "111111111111111110000111111111111111000000111111000000001111111"
		dmap[9] = "111111111111111111111111111111111111111111111111111111111111111"
		mw = dmap[0].Length
		mh = dmap.GetSize(0)
		map = New Int[mw,mh]
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			If dmap[y][x] = 49 Then map[x,y] = 1
			' player start position 'p'
			If dmap[y][x] = 112 Then 
				px = x*tw
				py = y*th
				pw = tw/2
				ph = th/2
			End If
		Next
		Next
		tilesx = screenwidth/tw
		tilesy = screenheight/th

		px = 500
		camerax = 500

	End Method
	Method update()
		
		Local swingkey:Bool=False
		If Keyboard.KeyReleased(Key.R) Then swingkey = True
		
		' scroll the map
		If Keyboard.KeyDown(Key.Right)  Then camerax+=3 
		If Keyboard.KeyDown(Key.Left)  Then camerax-=3 

		'move the player
		If inswing=False
			For Local i:Int=0 Until 3
				Local oldx:Int=px
				Local oldy:Int=py
				If Keyboard.KeyDown(Key.D)  Then px+=1
				If Keyboard.KeyDown(Key.A)  Then px-=1
				If playermapcollide(0,0) Then 
					px = oldx
					py = oldy
				End If
			Next
		End If		
		'player jump
		If Keyboard.KeyDown(Key.Space) And isjumping=False and inswing=False Then 
			' activate the jump flag
			isjumping=True
			' set our jump force
			' we jump upwards so movey = negative
			movey = -5
		End if
		' apply gravity for the player
		If isjumping=False And inswing=False
			' If we are floating in the air then activate falling
			If playermapcollide(0,1) = False
				isjumping=True
				movey = 0				
			End If
		End If
		' If we are in a jump or are falling down
		If isjumping=True And inswing=False
			' apply gravity
			movey+=grav	
			' No faster then 5 pixel per frame down or up		
			If movey>5 Then movey=5
			If movey<-5 Then movey=-5
			' Every pixel check collision with tiles and update player position
			For Local i:Int=0 Until Abs(movey)
				If movey<0 Then py-=1 Else py+=1
				If playermapcollide(0,1) Then isjumping=False ; Exit
				If playermapcollide(0,-1) Then isjumping=False ; Exit
			Next
		End If
		
		
		' Activate the rope
		If swingrelease>0 Then swingrelease-=1
		If swingkey And swingrelease<=0 Then 			
			standswing=True
			rax = px+pw
			lockswing()
		End If
		
		'the rop
		
		If standswing=True
		
			If playermapcollide(0,1) = True
				If Keyboard.KeyDown(Key.D) And playermapcollide(1,0)=False Then px+=1
				If Keyboard.KeyDown(Key.A) And playermapcollide(-1,0)=False Then px-=1
				If Keyboard.KeyDown(Key.W) Then py-=5
			Else
				inswing=True
				standswing=False	
				lockswing()
			End If
		End If
		If inswing=True	
		
			If swingkey Then inswing=False ; swingrelease=100 
			
			If playermapcollide(0,0)=False 
			If Keyboard.KeyDown(Key.W) And r>th
				If playermapcollide(0,-1) = False Then r-=1
				
			End if
			If Keyboard.KeyDown(Key.S) And playermapcollide(0,1)=False Then r+=1
			If Keyboard.KeyReleased(Key.D) Then rvel+=0.005
			If Keyboard.KeyReleased(Key.A) Then rvel-=0.005
			End If
			
			' Do the swing math
			racc=(-1*rgravity/r)*Sin(rangle)
			rvel+=racc
			rangle+=rvel		
			rvel*=rdamping
			
			' update our position
			Local oldx:Float=px
			Local oldy:Float=py

			px = rax+Sin(rangle)*r
			py = ray+Cos(rangle)*r

			If playermapcollide(0,0)
				px = oldx
				py = oldy
				lockswing()
				rvel = -rvel/10
				racc=0
			End If
			
'			If playermapcollide(0,1)
'				px = oldx
'				py = oldy
'				'inswing=false
'			End If
			
			'px = r*Sin(rangle)		
			'py = r*Cos(rangle)
			'px+=rax
			'py+=ray
			
		End If		
		
	End Method
	Method lockswing()
			'px = Mouse.X ; py = Mouse.Y
			r = distance(px,py,rax,ray)
			' Get the angle betweem the player and the anchor
			'rangle = getangle(rax,ray,px,py)
			Local zx:Float=0,zy:Float=0
			Local a:Float=-5
			Repeat
				a+=.1
				zx = rax+Sin(a)*r
				zy = ray+Cos(a)*r
				If rectsoverlap(zx-1,zy-1,2,2,px-1,py-1,2,2) Then Exit
			Forever
			'Print rangle+"=="+a+"=="+TwoPi
			rangle=a
			' Get the distgance between the player and anchor
			
			rvel=0
			racc=0
	
	End Method 
	
	Method playermapcollide:Bool(x1:Int,y1:Int)
	    Local cx:Int = (px)/tw+x1
	    Local cy:Int = (py)/th+y1
	    For Local y2:Int=cy-1 Until cy+2
	    For Local x2:Int=cx-1 Until cx+2
	        If x2>=0 And x2<mw And y2>=0 And y2<mh
	            If map[x2,y2] > 0
	                If rectsoverlap(px+x1,py+y1,pw,ph,x2*tw,y2*th,tw,th) = True
		                Return True
	    	        End If
	    	   	End If
	        End If
	    Next
	    Next
	    Return False
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
					canvas.Color = Color.Black.Blend(Color.Grey,.4)
					canvas.DrawRect(x*tw+offx,y*th+offy,tw,th)
				Case 1
					'Print Microsecs()
					canvas.Color = Color.White
					canvas.DrawRect(x*tw+offx,y*th+offy,tw,th)
			End Select
		Next
		Next
		'draw the player
		canvas.Color = Color.Blue
		canvas.DrawOval(px-camerax,py-cameray,pw,ph)
		'draw the rope
		If inswing Or standswing
		canvas.Color = Color.Yellow
		canvas.DrawLine(px-camerax+pw/2,py-cameray,rax-camerax,ray-cameray)
		End If
	End Method
End Class


Class MyWindow Extends Window

	Field mygame:game

	Method New()
		
		mygame = New game()
		
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		
		' swing harder
'		If Keyboard.KeyReleased(Key.Right) Then rvel+=.005
'		If Keyboard.KeyReleased(Key.Left) Then rvel-=.005
'		' CLimb up or down..
'		If Keyboard.KeyDown(Key.Up) Then r-=2
'		If Keyboard.KeyDown(Key.Down) Then r+=2
'		
		' draw our map
		mygame.update()
		mygame.draw(canvas)


		
		canvas.DrawText("Press cursor left and right to apply force..",0,0)
		canvas.DrawText("Hold cursor Up Down to climb or Lower yourself..",0,20)
		
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

' Return the angle from - to in float
Function getangle:Double(x1:Double,y1:Double,x2:Double,y2:Double)
	Return ATan2(y2-y1, x2-x1)
End Function

' Manhattan Distance (less precise)
Function mdistance:Float(x1:Float,y1:Float,x2:Float,y2:Float)   
	Return Abs(x2-x1)+Abs(y2-y1)   
End Function

	Function distance:Double(x1:Double,y1:Double,x2:Double,y2:Double) 
		Return Sqrt( (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2) )
	End Function

' Helper function
Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
   	If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

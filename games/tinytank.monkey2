#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global tilew:Int=16,tileh:Int=16

Class turret
	Field x:Float,y:Float,w:Int,h:Int
	Field mx:Int,my:Int 'on which tile in the map is it.
	Field angle:Float,destangle:Float
	Field deleteme:Bool
	Field clearshot:Bool
	Method New(x:Int,y:Int,mx:Int,my:Int)
		Self.x = x
		Self.y = y
		Self.mx = mx
		Self.my = my
		Self.w = tilew
		Self.h = tileh
	End Method
	Method align(ax:Float,ay:Float)
		x+=ax
		y+=ay
	End Method
	Method update()
		turntoplayer()
		clearshot = pathblocked()
		If Rnd()<.01 And clearshot  Then 
			mybullet.Add(New bullet(x+Cos(angle)*tilew+tilew/2,y+Sin(angle)*tileh+tileh/2,Cos(angle)*3,Sin(angle)*3,"turret"))
		End If
	End Method
	Method draw(canvas:Canvas)
		canvas.Color = Color.Black
		canvas.DrawOval(x+2,y+2,w-4,h-4)
		canvas.Color = Color.White
		Local x1:Float=x,y1:Float=y
		For Local i:Int=0 Until tilew
			x1+=Cos(angle)
			y1+=Sin(angle)
			canvas.DrawPoint(x1+tilew/2,y1+tileh/2)
		Next
	End Method
	
	Method pathblocked:Bool()
		Local ax:Float=x+tilew/2,ay:Float=y+tileh/2
		ax+=Cos(angle)*(tilew*2)
		ay+=Sin(angle)*(tileh*2)
		For Local i:Int=0 Until 300 Step 5
			If collidetile(ax,ay) Then 
				Return False
			End If
			ax+=Cos(angle)*5
			ay+=Sin(angle)*5
		Next
		Return True
	End Method
	Method collidetile:Bool(posx:Int,posy:Int)
		Local zx:Int = (posx/tilew) + mytank.tx
		Local zy:Int = (posy/tileh) + mytank.ty
		For Local y1:Int=zy-2 To zy+2
		For Local x1:Int=zx-2 To zx+2
			If x1<0 Or y1<0 Or x1>=mymap.mw Or y1>=mymap.mh Then Continue
			
			If mymap.map[x1,y1] = 1 'Or mymap.map[x1,y1] = 2
				
				Local x2:Int=((x1-mytank.tx)*tilew)+mytank.px-16
				Local y2:Int=((y1-mytank.ty)*tileh)+mytank.py-16
				If rectsoverlap(posx-2,posy-2,4,4,x2,y2,tilew,tileh)
					
					Return True
				End If
			End If
		Next
		Next
		Return False
	End Method

	Method turntoplayer()
		destangle = getangle(x,y,320,200)
		If destangle<angle Then angle-=0.005
		If destangle>angle Then angle+=0.005
	End Method
	Function getangle:float(x1:Int,y1:Int,x2:Int,y2:Int)
		Return ATan2(y2-y1, x2-x1)
	End Function
End Class

Class bullet
	Field x:Float,y:Float
	Field w:Float,h:Float
	Field timeout:Int
	Field owner:String="player"
	Field deleteme:Bool=False
	Field mx:Float,my:Float
	Field angle:Float
	Method New(x:Int,y:Int,mx:Float,my:Float,owner:String="player")
		Self.x = x
		Self.y = y
		Self.mx = mx
		Self.my = my
		Self.owner = owner
		timeout = 2000
	End Method
	Method update(canvas:Canvas)
		timeout-=1
		If timeout<0 Then deleteme=True
		x+=mx
		y+=my
		If owner = "player" Then collidetile(canvas,1,1)
	End Method
	Method align(mmx:Float,mmy:Float)
		x += mmx
		y += mmy
	End Method
	Method collidetile(canvas:Canvas,posx:Int,posy:Int)
		Local zx:Int = (x/tilew) + mytank.tx
		Local zy:Int = (y/tileh) + mytank.ty
		For Local y1:Int=zy-2 To zy+2
		For Local x1:Int=zx-2 To zx+2
			If x1<0 Or y1<0 Or x1>=mymap.mw Or y1>=mymap.mh Then Continue
			
			If mymap.map[x1,y1] = 1 Or mymap.map[x1,y1] = 2
				
				Local x2:Int=((x1-mytank.tx)*tilew)+mytank.px-16
				Local y2:Int=((y1-mytank.ty)*tileh)+mytank.py-16
				If rectsoverlap(x-2,y-2,4,4,x2,y2,tilew,tileh)
					mymap.map[x1,y1] = 0
					canvas.Color = Color.Black
					canvas.DrawRect(x2,y2,tilew,tileh)			
					deleteme = True
					For Local i:turret = Eachin myturret
						If i.mx = x1 And i.my = y1 Then i.deleteme = True
					Next
				End If
			End If
		Next
		Next
	End Method
	Method draw(canvas:Canvas)
		canvas.Color = Color.Yellow
		canvas.DrawCircle(x,y,3)
	End Method
End Class

Class playertank
	Field x:Float,y:Float
	Field tx:Int,ty:Int 'tile x and y pos
	Field px:Float,py:Float 'tank pixel x and y
	Field angle:Float
	Method New(tx:Int,ty:Int)
		' tile x and y position
		Self.tx = tx ; Self.ty = ty
		' tank pixel x and y position
		Self.x = tx*tilew ; Self.y = ty*tileh
	End Method
	Method controlmap()
		If Keyboard.KeyReleased(Key.Left) Then tx -=1		
		If Keyboard.KeyReleased(Key.Right) Then tx +=1
		If Keyboard.KeyReleased(Key.Up) Then ty -=1
		If Keyboard.KeyReleased(Key.Down) Then ty +=1		
	End Method
	Method controltank()
		If Keyboard.KeyReleased(Key.Space)
			mybullet.Add(New bullet(320,200,-Cos(angle)*4,-Sin(angle)*4))
		End If
		If Keyboard.KeyDown(Key.Left)
			angle-=.1
		End If
		If Keyboard.KeyDown(Key.Right)
			angle+=.1
		End If

		If Keyboard.KeyDown(Key.Up) Then 
			px += Cos(angle)*1
			py += Sin(angle)*1
			For Local i:bullet = Eachin mybullet
				i.align(Cos(angle)*1,Sin(angle)*1)
			Next
			For Local i:turret = Eachin myturret
				i.x+=Cos(angle)*1
				i.y+=Sin(angle)*1
			Next

			Local ax:Int,ay:Int
			If px>=tilew-1 Then px-=tilew ; tx-=1 ; ax=-1
			If ax=0 And px<0 Then px+=tilew ; tx+=1 ; ax = 1
			If py>=tileh-1 Then py-=tileh ; ty-=1 ; ay=-1
			If ay=0 And py<0 Then py+=tileh ; ty+=1 ; ay=1
			For Local i:turret = Eachin myturret
				'If ax = 1 Then i.align(16,0)
				'If ax = -1 Then i.align(-16,0)
			Next

		End If
	End Method
	
	Method draw(canvas:Canvas)
		mymap.drawmap(canvas,px,py,tx,ty)
		canvas.Color = Color.White
		canvas.DrawOval(320,200,tilew,tileh)
		canvas.PushMatrix()
		canvas.Translate(320+tilew/2,200+tileh/2)
		canvas.Rotate(-angle)
		
		canvas.DrawRect(-12,-4,7,4)
		'canvas.DrawRect(0,-8,10,16)
		
		canvas.PopMatrix()
	End Method
End Class

Class mainmap
	' screen width/height, map width/height, tile width/height
	Field sw:Int,sh:Int,mw:Int,mh:Int,tw:Float,th:Float
	Field brushmap:String[]
	Field map:Int[,]
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw ; Self.sh = sh
		Self.mw = mw ; Self.mh = mh
		Self.tw = tilew ; Self.th = tileh
		map = New Int[mw,mh]
		createmap(5,5)
	End Method
	Method createmap(lx:Int,ly:Int)
		brushmap = New String[10]
		brushmap[0] = "00000000200000000000"
		brushmap[1] = "00000tww2wwwt0000000"
		brushmap[2] = "00000w222222w0000000"
		brushmap[3] = "00000w22222222000000"
		brushmap[4] = "00wwwt22f222w0000000"
		brushmap[5] = "00w222222222twwwt000"
		brushmap[6] = "00w2222222222222w000"
		brushmap[7] = "00twwwwwwtwww2wwt000"
		brushmap[8] = "00000000000002000000"
		brushmap[9] = "00000000000002000000"
		For Local y:Int=0 Until brushmap.GetSize(0)
		For Local x:Int=0 Until brushmap[y].Length			
			If brushmap[y][x] = 119 'w-wall
				map[lx+x,ly+y] = 1
			End If
			If brushmap[y][x] = 116't-urret
				map[lx+x,ly+y] = 2				
			End If
			If brushmap[y][x] = 102 'f-flag
				map[lx+x,ly+y] = 3
			End If
			If brushmap[y][x] = 48 Then '0 - terrain
				map[lx+x,ly+y] = 4
			End If
			If brushmap[y][x] = 50 Then '1 - terrain
				map[lx+x,ly+y] = 5
			End If
		Next
		Next
	End Method
	Method drawmap(canvas:Canvas,px:Int,py:Int,tx:Int,ty:Int)
		For Local y:Int=0 Until (sh/th)+1
		For Local x:Int=0 Until (sw/tw)+1
			If x+tx<0 Or y+ty<0 Or x+tx>=mw Or y+ty>=mh Then Continue
			Local dx:Int=x*tw+px-16
			Local dy:Int=y*th+py-16
			Select map[x+tx,y+ty]
				Case 1'wall
				canvas.Color = Color.Brown.Blend(Color.Grey,.5)
				canvas.DrawRect(dx,dy,tw,th)				
				Case 2'turret
				canvas.Color = Color.Blue.Blend(Color.White,.8)
				canvas.DrawRect(dx,dy,tw,th)				
				Case 3'flag
				canvas.Color = Color.Grey
				canvas.DrawRect(dx,dy,tw,th)				
				Case 4,0'terrain(1)
				canvas.Color = Color.Green.Blend(Color.Black,.6)
				canvas.DrawRect(dx,dy,tw,th)
				Case 5'terrain(2)
				canvas.Color = Color.Brown.Blend(Color.Black,.4)
				canvas.DrawRect(dx,dy,tw,th)					
			End Select
		Next
		Next
	End Method
End Class

	Global mymap:mainmap
	Global mytank:playertank
	Global mybullet:List<bullet>
	Global myturret:List<turret>
	
Class MyWindow Extends Window
	Method New()
		mytank = New playertank(6,10)
		myturret = New List<turret>
		mymap = New mainmap(Width,Height,100,100)				
		mybullet = New List<bullet>
		'inititate the turrets
		For Local y:Int=0 Until mymap.mh
		For Local x:Int=0 Until mymap.mw
			If mymap.map[x,y] = 2
				Local x2:Int,y2:Int
				x2 = (x-mytank.tx)*tilew-tilew
				y2 = (y-mytank.ty)*tileh-tileh
				myturret.Add(New turret(x2,y2,x,y))
			End If
		Next
		Next
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		For Local i:bullet = Eachin mybullet
			If i.deleteme = True Then mybullet.Remove(i)
		Next
		For Local i:turret = Eachin myturret
			If i.deleteme = True Then myturret.Remove(i)
		Next
		
		'mytank.controlmap()
		mytank.controltank()
		mytank.draw(canvas)
		For Local i:turret = Eachin myturret
			i.draw(canvas)
		Next
		For Local i:turret = Eachin myturret
			i.update()
		Next

		For Local i:bullet = Eachin mybullet
			i.draw(canvas)
		Next
		For Local i:bullet = Eachin mybullet
			i.update(canvas)
		Next

		'mymap.drawmap(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	    Return True
	End	Function


Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

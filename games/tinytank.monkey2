#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global tilew:Int=24,tileh:Int=24
Global screenw:Int=640
Global screenh:Int=480

'
' Decals are graphics like spraypaints or bullet holes that get added ontop
' of the game graphics.
Class decal
	Field dx:Int,dy:Int
	Field ox:Int,oy:Int
	Field type:String="blood"
	Method New(x:Int,y:Int,type:String)
		Self.type = type
		Self.dx = x
		Self.dy = y
		ox=Rnd(tilew/8)
		oy=Rnd(tileh/8)
	End Method
	Method draw(canvas:Canvas)
		Local posx:Int=dx-(mytank.tx*tilew)+mytank.px-tilew/2
		Local posy:Int=dy-(mytank.ty*tileh)+mytank.py-tileh/2

		Select type
			Case "blood"				
				canvas.Color = Color.Red.Blend(Color.Black,.5)
				canvas.DrawOval(posx+tilew/4+ox,posy+tileh/4+oy,tilew/3,tileh/3)
		End Select
	End Method
End Class

Class soldier
	Field id:Int
	Field sx:Float,sy:Float,sw:Float,sh:Float
	Field tx:Int,ty:Int
	Field map:Int[,]
	Field targetx:Int,targety:Int
	Field targetfound:Bool=False
	Field deleteme:Bool
	Method New(id:Int,x:Int,y:Int)
		Self.id = id
		map = New Int[mymap.mw,mymap.mh]
		tx=x
		ty=y
		sx = x*tilew'(tx-mytank.tx)*tilew
		sy = y*tileh'(ty-mytank.ty)*tileh
		sw = tilew/3
		sh = tileh/3
		
		
	End Method
	Method update()
		'Return

		 'here we randomly shoot at the player 
		 ' if there is a chance of hitting. 
		If Rnd()<.01 
			If pathblocked() Then
				Local posx:Int=sx-(mytank.tx*tilew)+mytank.px-tilew/2
				Local posy:Int=sy-(mytank.ty*tileh)+mytank.py-tileh/2
				Local angle:Float=getangle(posx,posy,320,200)
				mybullet.Add(New bullet((posx+Cos(angle)*(tilew))+tilew/2,(posy+Sin(angle)*tileh)+(tileh/2),Cos(angle)*3,Sin(angle)*3,"soldier"))
			End If
		End if
	

		
		tx = (sx/tilew)
		ty = (sy/tileh)
		'
		If (Rnd()<.1 And map[tx,ty] = 0 ) Or Rnd()<0.09
			findsafespot()
		End If
		If targetfound = False And map[tx,ty] > 0
			Local lowest:Int=map[tx,ty]
			Local mx:Int,my:Int	
			Local sel:Bool
			If map[tx-1,ty]>0 And map[tx-1,ty] < lowest Then lowest = map[tx-1,ty] ; mx=-1;my=0; sel=True
			If map[tx+1,ty]>0 And map[tx+1,ty] < lowest Then lowest = map[tx+1,ty] ; mx=1;my=0; sel=True
			If map[tx,ty-1]>0 And map[tx,ty-1] < lowest Then lowest = map[tx,ty-1] ; my=-1;mx=0; sel=True
			If map[tx,ty+1]>0 And map[tx,ty+1] < lowest Then lowest = map[tx,ty+1] ; my=1;mx=0;sel=True
			If sel=True
				targetx = (tx+mx)*tilew
				targety = (ty+my)*tileh
				targetfound=True
			End If
			'tx+=mx
			'ty+=my
			'sx+=mx
			'sy+=my
			
			'sx+=Float(mx)*3
			'sy+=Float(my)*3
			
			
			
		End If
		
		' Move towards and If reaches the target position
		If targetfound = True
		If sx < targetx Then sx+=1
		If sx > targetx Then sx-=1
		If sy < targety Then sy+=1
		If sy > targety Then sy-=1
		'avoid()
		If distance(sx,sy,targetx,targety) < 6 Then 
			targetfound = False			
		End If
		End If


		collidewithplayer()

	End Method
	
	
	Method pathblocked:Bool()
		' First check if we are not goint to hit a wall or other turret
		Local posx:Int=sx-(mytank.tx*tilew)+mytank.px-tilew/2
		Local posy:Int=sy-(mytank.ty*tileh)+mytank.py-tileh/2
		Local angle:Float=getangle(posx,posy,320,200)
		Local ax:Float=posx+tilew/2,ay:Float=posy+tileh/2
		ax+=Cos(angle)*(tilew*3)
		ay+=Sin(angle)*(tileh*3)
		For Local i:Int=0 Until 300 Step 2
			If collidetile(ax,ay) Then 				
				Return False
			End If
			' Check if we have a chance of hitting the player
			If rectsoverlap(ax,ay,tilew,tileh,320-tilew*1.5,200-tileh*1.5,tilew*2,tileh*2) = True
				'Print "w"
				
				Return True
			End If
			'
			ax+=Cos(angle)*5
			ay+=Sin(angle)*5
			'Print ax+","+ay
		Next
		
		
		Return False
	End Method
	Method collidetile:Bool(posx:Int,posy:Int)
		Local zx:Int = (posx/tilew) + mytank.tx
		Local zy:Int = (posy/tileh) + mytank.ty
		For Local y1:Int=zy-2 To zy+2
		For Local x1:Int=zx-2 To zx+2
			If x1<0 Or y1<0 Or x1>=mymap.mw Or y1>=mymap.mh Then Continue			
			If mymap.map[x1,y1] = 1 Or mymap.map[x1,y1] = 2				
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

	' The player is always at 320*200 so if the soldier
	' is there then he wil get squashed.
	'
	Method collidewithplayer()
		Local posx:Int=sx-(mytank.tx*tilew)+mytank.px-tilew/2
		Local posy:Int=sy-(mytank.ty*tileh)+mytank.py-tileh/2

		If rectsoverlap(posx,posy,sw,sh,320,200,mytank.w,mytank.h)
			deleteme = True

			mydecal.Add(New decal(sx,sy,"blood"))
		End If
	End Method
	
	
	
	Method align(x:Float,y:Float)
		'sx+=x
		'sy+=y
	End Method
	
	Method findsafespot()
		'Here the soldiier find sa safe spot behind a wall
		'from that spot a path is flooded so he can get there
		Local tankx:Float,tanky:Float
		tankx = (320/tilew)+mytank.tx
		tanky = (200/tileh)+mytank.ty
		Local a:Float= Rnd(TwoPi)
		For Local i:Int=0 To 20
			tankx+=Cos(a)
			tanky+=Sin(a)
			
			If tankx<0 Or tanky<0 Or tankx>=mymap.mw Or tanky>=mymap.mh Then Return
			
			If mymap.map[tankx,tanky] = 1
				For Local ii:Int=0 To 4
					tankx+=Cos(a)
					tanky+=Sin(a)
					If tankx<0 Or tanky<0 Or tankx>=mymap.mw Or tanky>=mymap.mh Then Return
					If mymap.map[tankx,tanky] = 4 Or mymap.map[tankx,tanky] = 5
						'mymap.map[tankx,tanky] = 2
						fillpos(tankx,tanky,10)
						Return
					End If
				Next
			End	if

		Next
		
	End Method
	Method fillpos(fx:Int,fy:Int,radius:Int)
		map = New Int[mymap.mw,mymap.mh]
		map[fx,fy] = 1
		Local current:Int=1
		
		For Local i:Int=0 Until radius
		For Local y:Int = fy-radius To fy+radius
		For Local x:Int = fx-radius To fx+radius
			If x<1 Or y<1 Or x>mymap.mw-1 Or y>=mymap.mh-1 Then Continue
			If map[x,y] = current Then 
				If validfilltile(x-1,y) And map[x-1,y] = 0 Then map[x-1,y] = current+1
				If validfilltile(x+1,y) And map[x+1,y] = 0 Then map[x+1,y] = current+1
				If validfilltile(x,y-1) And map[x,y-1] = 0 Then map[x,y-1] = current+1
				If validfilltile(x,y+1) And map[x,y+1] = 0 Then map[x,y+1] = current+1
			End if
		Next
		Next
			current+=1
		Next
	End Method
	Method validfilltile:Bool(x:Int,y:Int)
		Select mymap.map[x,y]
			Case 0
				Return True
			Case 1
				Return False
			Case 2
				Return False
			Default Return True
		End Select
		Return False
	End Method
	Method draw(canvas:Canvas)
		'Local posx:Int=((tx-mytank.tx)*tilew)+sx
		'Local posy:Int=((ty-mytank.ty)*tileh)+sy
		
		Local posx:Int=sx-(mytank.tx*tilew)+mytank.px-tilew/2+sw/2
		Local posy:Int=sy-(mytank.ty*tileh)+mytank.py-tileh/2+sh/2
		canvas.Color = Color.Blue
		canvas.DrawOval(posx-1,posy-1,sw+2,sh+2)
		canvas.Color = Color.Yellow
		canvas.DrawOval(posx,posy,sw,sh)
		canvas.Color = Color.Black
		canvas.DrawLine(posx,posy+sh/4,posx+sw,posy+sh/4)
		canvas.DrawLine(posx+sw/2,posy,posx+sw/2,posy+sh/1.5)
		canvas.DrawLine(posx+sw/2,posy+sh,posx+sw,posy-sh/2)
		canvas.DrawLine(posx+sw/2+1,posy+sh,posx+sw+1,posy-sh/2)
		' drawmap
		If Keyboard.KeyDown(Key.LeftShift)
			drawmap(canvas)
		End If
	End Method
	Method drawmap(canvas:Canvas)
		Local px:Int = mytank.px
		Local py:Int = mytank.py
		Local tx:Int = mytank.tx
		Local ty:Int = mytank.ty
		For Local y:Int=0 Until (screenh/tileh)+1
		For Local x:Int=0 Until (screenw/tilew)+1
			If x+tx<0 Or y+ty<0 Or x+tx>=mymap.mw Or y+ty>=mymap.mh Then Continue
			Local dx:Int=x*tilew+px-16
			Local dy:Int=y*tileh+py-16
			'Select map[x+tx,y+ty]
			canvas.Color = Color.White
			canvas.DrawText(map[x+tx,y+ty],dx+tilew/2,dy+tileh/2)
			'End Select
		Next
		Next		
	End Method
End Class

Class turret
	Field x:Float,y:Float,w:Float,h:Float
	Field mx:Int,my:Int 'on which tile in the map is it.
	Field angle:Float,destangle:Float
	Field deleteme:Bool
	Field clearshot:Bool
	Field maxdamage:Int=10
	Field damage:Int=10
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
			mybullet.Add(New bullet((x+Cos(angle)*(tilew))+tilew/2,(y+Sin(angle)*tileh)+(tileh/2),Cos(angle)*3,Sin(angle)*3,"turret"))
		End If
	End Method
	Method draw(canvas:Canvas)
		canvas.Color = Color.Black
		canvas.DrawOval(x+w/2-2,y+h/2-2,w-4,h-4)
		canvas.Color = Color.White
		Local x1:Float=x+w/4,y1:Float=y+h/4
		For Local i:Int=0 Until tilew/2
			x1+=Cos(angle)
			y1+=Sin(angle)
			canvas.DrawRect(x1+tilew/2,y1+tileh/2,3,3)
		Next
		' Draw the damage bar
		Local pw:Int=tilew
		Local ph:Int=tileh/5
		Local p:Int=(pw/maxdamage+1)*damage
		canvas.Color = Color.Black
		canvas.DrawRect(x,y,pw,ph)
		If damage < 5 Then 
			canvas.Color = Color.Red
		Else
			canvas.Color = Color.Green
		End If
		canvas.DrawRect(x+1,y+1,p,ph-2)
		
		
	End Method
	
	Method pathblocked:Bool()
		' First check if we are not goint to hit a wall or other turret
		Local ax:Float=x+tilew/2,ay:Float=y+tileh/2
		ax+=Cos(angle)*(tilew*3)
		ay+=Sin(angle)*(tileh*3)
		For Local i:Int=0 Until 300 Step 2
			If collidetile(ax,ay) Then 
				Return False
			End If
			' Check if we have a chance of hitting the player
			If rectsoverlap(ax,ay,tilew,tileh,320-tilew*1.5,200-tileh*1.5,tilew*2,tileh*2) = True
				Return True
			End If
			'
			ax+=Cos(angle)*5
			ay+=Sin(angle)*5
		Next
		
		
		Return False
	End Method
	Method collidetile:Bool(posx:Int,posy:Int)
		Local zx:Int = (posx/tilew) + mytank.tx
		Local zy:Int = (posy/tileh) + mytank.ty
		For Local y1:Int=zy-2 To zy+2
		For Local x1:Int=zx-2 To zx+2
			If x1<0 Or y1<0 Or x1>=mymap.mw Or y1>=mymap.mh Then Continue			
			If mymap.map[x1,y1] = 1 Or mymap.map[x1,y1] = 2				
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
		' Make the angle and target angle suitable for comapisment		
		If (destangle >= (angle + Pi))
		    angle += TwoPi
		Elseif (destangle < (angle - Pi))
		        destangle += TwoPi
		End If		
		' .05 is the turn speed
		Local directiondiff:Float = destangle - angle
		
		If (directiondiff < -.007)
		    directiondiff = -.007
		End If
		If (directiondiff > .007)
		    directiondiff = .007
		End If
		angle+=directiondiff
	End Method

End Class

Class bullet
	Field x:Float,y:Float
	Field w:Float,h:Float
	Field timeout:Int
	Field owner:String="player"
	Field deleteme:Bool=False
	Field mx:Float,my:Float
	Field radius:Int
	Field angle:Float
	Method New(x:Int,y:Int,mx:Float,my:Float,owner:String="player")
		Self.x = x
		Self.y = y
		Self.mx = mx
		Self.my = my
		If owner = "player" Or owner="turret" Then radius = 3
		If owner = "soldier" Then radius = 1
		Self.owner = owner
		timeout = 2000
	End Method
	Method update(canvas:Canvas)
		timeout-=1
		If timeout<0 Then deleteme=True
		x+=mx
		y+=my
		If owner = "player" Then collidetile(canvas,1,1)
		If owner = "turret" Then collideplayer()
		If owner = "soldier" Then collideplayer2()
	End Method
	Method align(mmx:Float,mmy:Float)
		x += mmx
		y += mmy
	End Method
	Method collideplayer2()
		If rectsoverlap(320-tilew/2,200-tileh/2,tilew,tileh,x-1,y-1,3,3)
			If Rnd()<.2 And mytank.damage>0 Then mytank.damage-=1
			deleteme = True
		End If
	End Method

	Method collideplayer()
		If rectsoverlap(320-tilew/2,200-tileh/2,tilew,tileh,x-1,y-1,3,3)
			If mytank.damage>0 Then mytank.damage-=1
			deleteme = True
		End If
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
					If mymap.map[x1,y1] = 1 And Rnd()<.2 Then mymap.map[x1,y1] = 0
					canvas.Color = Color.Red.Blend(Color.Yellow,Rnd())
					canvas.DrawRect(x2,y2,tilew,tileh)			
					deleteme = True
					For Local i:turret = Eachin myturret						
						If i.mx = x1 And i.my = y1 Then 
							i.damage-=1
							If i.damage<=0 Then 
								i.deleteme = True
								mymap.map[x1,y1] = 0
							End if
						End If
					Next
				End If
			End If
		Next
		Next
	End Method
	Method draw(canvas:Canvas)
		canvas.Color = Color.Yellow
		canvas.DrawCircle(x,y,radius)
	End Method
End Class

Class playertank
	Field x:Float,y:Float,w:Int,h:Int
	Field tx:Int,ty:Int 'tile x and y pos
	Field px:Float,py:Float 'tank pixel x and y
	Field angle:Float
	Field maxdamage:Int=10
	Field damage:Int=10
	Method New(tx:Int,ty:Int)
		' tile x and y position
		Self.tx = tx ; Self.ty = ty
		' tank pixel x and y position
		Self.x = tx*tilew ; Self.y = ty*tileh
		Self.w = tilew/2
		Self.h = tileh/2
	End Method
	Method controlmap()
		If Keyboard.KeyReleased(Key.Left) Then tx -=1		
		If Keyboard.KeyReleased(Key.Right) Then tx +=1
		If Keyboard.KeyReleased(Key.Up) Then ty -=1
		If Keyboard.KeyReleased(Key.Down) Then ty +=1		
	End Method
	Method controltank()
		
		If Keyboard.KeyReleased(Key.Space)
			mybullet.Add(New bullet(320+tilew/2,200+tileh/2,-Cos(angle)*4,-Sin(angle)*4))
		End If
		If Keyboard.KeyDown(Key.Left)
			angle-=.1
		End If
		If Keyboard.KeyDown(Key.Right)
			angle+=.1
		End If

		If Keyboard.KeyDown(Key.Up) 
			Local xx:Float=Cos(angle)*1,yy:Float=Sin(angle)*1
			 ' First move ahead
			px += xx
			py += yy
			' If we touch a tile then move back and return
		 	If collidetile(xx,yy) = True Then
				px -= xx
				py -= yy
				Return
			End If
			
			' update the bullets with the new scroll posotion	
			For Local i:bullet = Eachin mybullet
				i.align(xx,yy)
			Next
			' udpat the turrets with the new scroll position
			For Local i:turret = Eachin myturret
				i.x+=xx
				i.y+=yy
			Next
			' udpat the soldiers with the new scroll position
			For Local i:soldier = Eachin mysoldier
				i.align(xx,yy)
				'i.sx+=xx
				'i.sy+=yy
			Next			
			' Scroll the actual tiles if we moved a tile dimension		
			Local ax:Int,ay:Int
			If px>=tilew-1 Then px-=tilew ; tx-=1 ; ax=-1
			If ax=0 And px<0 Then px+=tilew ; tx+=1 ; ax = 1
			If py>=tileh-1 Then py-=tileh ; ty-=1 ; ay=-1
			If ay=0 And py<0 Then py+=tileh ; ty+=1 ; ay=1
		End If
	End Method
	Method collidetile:Bool(posx:Int,posy:Int)
		Local zx:Int = ((320-tilew/2+posx)/tilew) + mytank.tx
		Local zy:Int = ((200-tileh/2+posy)/tileh) + mytank.ty
		For Local y1:Int=zy-2 To zy+2
		For Local x1:Int=zx-2 To zx+2
			If x1<0 Or y1<0 Or x1>=mymap.mw Or y1>=mymap.mh Then Continue
			
			If mymap.map[x1,y1] = 1 Or mymap.map[x1,y1] = 2
				
				Local x2:Int=((x1-mytank.tx)*tilew)+mytank.px-16
				Local y2:Int=((y1-mytank.ty)*tileh)+mytank.py-16
				If rectsoverlap(320,200,w,h,x2,y2,tilew,tileh)
					Return True
				End If
			End If
		Next
		Next
		Return False
	End Method
	
	Method draw(canvas:Canvas)
		canvas.Color = Color.White
		canvas.DrawOval(320,200,w,h)
		canvas.PushMatrix()
		canvas.Translate(320+w/2,200+h/2)
		canvas.Rotate(-angle)
		
		canvas.DrawRect(-12,-4,7,4)
		'canvas.DrawRect(0,-8,10,16)
		
		canvas.PopMatrix()
		'draw the damage bar
		Local dw:Int=w
		Local dh:Int=h/4
		Local d:Int=(dw/maxdamage)*damage
		canvas.Color = Color.Black
		canvas.DrawRect(320,200-dh,dw,dh)
		If damage>maxdamage/3 Then 
			canvas.Color = Color.Green
		Elseif damage<maxdamage/3
			canvas.Color = Color.Yellow
		Else
			canvas.Color = Color.Red
		End If
		canvas.DrawRect(320+1,200-dh+1,d,dh-2)
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
	Global mysoldier:List<soldier>
	Global mydecal:List<decal>
	
Class MyWindow Extends Window
	Method New()
		mytank = New playertank(6,10)
		myturret = New List<turret>
		mymap = New mainmap(Width,Height,100,100)				
		mybullet = New List<bullet>
		mysoldier = New List<soldier>
		mydecal = New List<decal>
		mysoldier.Add(New soldier(1,18,13))
		mysoldier.Add(New soldier(2,5,9))
		mysoldier.Add(New soldier(3,18,6))
		For Local i:Int=0 Until 4
		mysoldier.Add(New soldier(4+i,10,13))
		Next
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



		mymap.drawmap(canvas,mytank.px,mytank.py,mytank.tx,mytank.ty)
		For Local i:decal=Eachin mydecal
			i.draw(canvas)
		Next

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
		
		
		For Local i:soldier = Eachin mysoldier
			i.update()
		Next
		For Local i:soldier = Eachin mysoldier
			If i.deleteme Then mysoldier.Remove(i)
		Next
		For Local i:soldier = Eachin mysoldier
			i.draw(canvas)
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
	Function getangle:float(x1:Int,y1:Int,x2:Int,y2:Int)
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

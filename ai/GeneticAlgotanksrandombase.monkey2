#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Enum tiles
	ground=0,wallver=1,wallhor=2
	wallverdestroyed=3,wallhordestroyed=4
	turret=9,turretdestroyed=10
	tree=11,treedestroyed=12
	capturepoint=13,startpoint=14
End Enum


Class world
	Field sw:Int,sh:Int,mw:Int,mh:Int,tw:Float,th:Float
	Field map:Int[,]
	Field capturexy:Vec2i,startxy:Vec2i
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		tw = Float(sw) / Float(mw)
		th = Float(sh) / Float(mh)
		map = New Int[mw,mh]
		generatemap()
	End Method
	Method generatemap()
		map[10,10] = tiles.wallhor
		map[11,10] = tiles.wallhordestroyed
		map[10,10] = tiles.turretdestroyed
		map[10,11] = tiles.wallverdestroyed
		map[10,12] = tiles.wallver
		map[5,5] = tiles.treedestroyed
		map[4,5] = tiles.tree
		map[5,6] = tiles.tree
		map[10,13] = tiles.turret
		map[4,4] = tiles.tree
	End Method
	Method drawtile(canvas:Canvas,x:Int,y:Int,tile:Int)
		Select tile
			Case tiles.ground
				canvas.Color = Color.Yellow.Blend(Color.Red,.5)
				canvas.DrawRect(x,y,tw+1,th+1)
			Case tiles.turret
				canvas.Color = Color.Grey.Blend(Color.Red,.5)
				canvas.DrawRect(x,y,tw+1,th+1)
				canvas.Color = Color.Grey.Blend(Color.Yellow,.5)
				canvas.DrawOval(x+tw/4,y+th/4,tw/2.5,th/2.5)
			Case tiles.wallver
				drawtile(canvas,x,y,tiles.ground)
				canvas.Color = Color.Grey.Blend(Color.Red,.5)
				canvas.DrawRect(x+tw/4,y,tw/2,th+1)		
			Case tiles.wallhor
				drawtile(canvas,x,y,tiles.ground)
				canvas.Color = Color.Grey.Blend(Color.Red,.5)
				canvas.DrawRect(x,y+th/4,tw+1,th/2)		
			Case tiles.treedestroyed
				drawtile(canvas,x,y,tiles.ground)
				SeedRnd(1)
				For Local i:Int=0 Until 14
					If Rnd()<.6
						canvas.Color = Color.Green.Blend(Color.Brown,Rnd(0.1,0.3))
					Else
						If Rnd()<.5
							canvas.Color = Color.Brown.Blend(Color.Black,Rnd(0.1,1))
						Else
							canvas.Color = Color.Green.Blend(Color.Black,Rnd(0.1,1))
						End If
					End If
					canvas.DrawRect(x+Rnd(tw-tw/5),y+Rnd(th-th/5),Rnd(2,tw/5),Rnd(2,th/5))
					If Rnd()<.4 Then
						Local ax:Float=x+Rnd(tw-tw/5)
						Local ay:Float=y+Rnd(th-th/5)
						canvas.DrawQuad(ax,ay,ax+Rnd(10),ay+Rnd(10),ax+Rnd(10),ay+Rnd(10),ax+Rnd(10),ay+Rnd(10))
					End If
				Next
								

			Case tiles.turretdestroyed
				drawtile(canvas,x,y,tiles.ground)
				SeedRnd(1)
				For Local i:Int=0 Until 14
					If Rnd()<.5
						canvas.Color = Color.Grey.Blend(Color.Brown,Rnd(0.1,0.3))
					Else
						If Rnd()<.5
							canvas.Color = Color.Grey.Blend(Color.Black,Rnd(0.1,1))
						Else
							canvas.Color = Color.Grey.Blend(Color.Yellow,Rnd(0.1,1))
						End If
					End If
					canvas.DrawRect(x+Rnd(tw-tw/5),y+Rnd(th-th/5),Rnd(2,tw/5),Rnd(2,th/5))
					If Rnd()<.4 Then
						Local ax:Float=x+Rnd(tw-tw/5)
						Local ay:Float=y+Rnd(th-th/5)
						canvas.DrawQuad(ax,ay,ax+Rnd(10),ay+Rnd(10),ax+Rnd(10),ay+Rnd(10),ax+Rnd(10),ay+Rnd(10))
					End If
				Next
								
			Case tiles.wallhordestroyed
				drawtile(canvas,x,y,tiles.ground)
				SeedRnd(1)
				For Local i:Int=0 Until 14
					If Rnd()<.5
						canvas.Color = Color.Grey.Blend(Color.Brown,Rnd(0.1,0.3))
					Else
						If Rnd()<.5
							canvas.Color = Color.Grey.Blend(Color.Black,Rnd(0.1,1))
						Else
							canvas.Color = Color.Grey.Blend(Color.White,Rnd(0.1,1))
						End If
					End If
					canvas.DrawRect(x+Rnd(tw-tw/3),y+Rnd(th/5,th-th/3),Rnd(2,tw/6),Rnd(2,th/6))		
				Next
			Case tiles.wallverdestroyed
				drawtile(canvas,x,y,tiles.ground)
				SeedRnd(1)
				For Local i:Int=0 Until 14
					If Rnd()<.5
						canvas.Color = Color.Grey.Blend(Color.Brown,Rnd(0.1,0.3))
					Else
						If Rnd()<.5
							canvas.Color = Color.Grey.Blend(Color.Black,Rnd(0.1,1))
						Else
							canvas.Color = Color.Grey.Blend(Color.White,Rnd(0.1,1))
						End If
					End If
					canvas.DrawRect(x+Rnd(tw/3,tw-tw/3),y+Rnd(0,th-th/3),Rnd(2,tw/6),Rnd(2,th/6))		
				Next

			Case tiles.tree
				drawtile(canvas,x,y,tiles.ground)
				canvas.Color = Color.Green.Blend(Color.Red,.2)
				canvas.DrawOval(x+tw/5,y+th/5,tw/1.25,th/1.25)
			
		End Select
	End Method
	Method drawmap(canvas:Canvas)
		For Local y:Int=0 Until mh
		For Local x:Int=0 Until mw
			drawtile(canvas,x*tw,y*th,map[x,y])
		Next
		Next
	End Method
End Class

Global myworld:world

Class MyWindow Extends Window
	Field mapwidth:Int=25,mapheight:Int=25
	Method New()
		myworld = New world(Width,Height,mapwidth,mapheight)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		myworld.drawmap(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

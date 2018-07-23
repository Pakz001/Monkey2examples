#Import "<std>"
#Import "<mojo>"


'
' I want to run 1 or a group of tanks on one simulation at a time.
' I run a simulation a x amount of times and store the genes
' Then I select a new fittest brain and do some mutations and repeat.
'
'

Using std..
Using mojo..

Enum tiles
	ground=0,wallver=1,wallhor=2
	wallverdestroyed=3,wallhordestroyed=4
	turret=9,turretdestroyed=10
	tree=11,treedestroyed=12
	capturepoint=13,startpoint=14
End Enum

Enum geneinst
	turnleft=1,turnright=2,moveforward=3,movebackward=4,
	stop=5
End Enum

Class ai
	Field tankimage:Image
	Field tankcanvas:Canvas
	'
	' Here we store a x amount of runs that we use
	' to select the fittest for a new run.
	Class brainhistory
		Field id:Int ' 0 = tank 1, 1=tank 2 etc...
		Field deathstep:Int
		Field damagedone:Int
		Field damagetaken:Int
		Field genescom:Stack<Int>
		Field genesval:Stack<Int>
		Method New()
		End Method
	End Class
	Class brain
		Field deathstep:Int ' how close to target were we
		Field damagedone:Int
		Field damagetaken:Int
		Field position:Int
		Field angle:Float
		Field kx:Float,ky:Float,kw:Float,kh:Float 'xywidhtheight
		Field genescom:Stack<Int>
		Field genesval:Stack<Int> 'time
		Method New(x:Int,y:Int)
			genescom = New Stack<Int>
			genesval = New Stack<Int>
			Self.kx = x
			Self.ky = y
			Self.kw = myworld.tw / 3
			Self.kh = myworld.th / 2
			Self.angle = 0
		End Method
		' Insert a instruction
		Method insertinstruction(in1:Int,in2:Int)
			'in1 is a command
			'in2 is the time/steps
			genescom.Push(in1)
			genesval.Push(in2)
		End Method
		'
		' Here we execute 1 step at position from the genes
		' start at 0 and at every step update the world
		' check collision with bullets(damage)
		' check collision with obstacles(collision)
		Method rungene(position:Int)						
			Local i:Int=position
			Select genescom.Get(i)
				Case geneinst.stop
					Local val:Int=genesval.Get(i)
					For Local i2:Int=0 Until val

					Next				
				Case geneinst.moveforward						
					Local val:Int=genesval.Get(i)
					For Local i2:Int=0 Until val
						kx += Cos(-angle)*1
						ky += Sin(-angle)*1
					Next				
				Case geneinst.movebackward
					Local val:Int=genesval.Get(i)
					For Local i2:Int=0 Until val
						kx -= Cos(-angle)*1
						ky -= Sin(-angle)*1
					Next				
				Case geneinst.turnleft
					Local val:Int=genesval.Get(i)
					For Local i2:Int=0 Until val
						angle-=.05
					Next
				Case geneinst.turnright
					Local val:Int=genesval.Get(i)
					For Local i2:Int=0 Until val
						angle+=.05
					Next
			End Select
		End Method
		Method draw(canvas:Canvas)			
			canvas.Color = Color.White
			canvas.DrawImage(myai.tankimage,kx,ky,angle)
		End Method
	End Class
	Field mybrain:Stack<brain>
	Method New()
		mybrain = New Stack<brain>
		createtankimage()
	End Method
	Method createtankimage()
		tankimage = New Image(myworld.tw,myworld.th)
		tankimage.Handle = New Vec2f(0.5,0.5)
		tankcanvas = New Canvas(tankimage)
		tankcanvas.Clear(New Color(0,0,0,0))
		tankcanvas.Flush()
		tankcanvas.Color = Color.Brown
		tankcanvas.DrawQuad(tankimage.Width,tankimage.Height/2+5,
							tankimage.Width,tankimage.Height/2-5,
							4,4,
							4,tankimage.Height-4)
		tankcanvas.Color = Color.Silver
		tankcanvas.DrawOval(tankimage.Width/2-tankimage.Width/6,
							tankimage.Height/2-tankimage.Height/6,
							tankimage.Width/3,
							tankimage.Height/3)
		tankcanvas.Color = Color.Gold
		tankcanvas.DrawRect(tankimage.Width/2,tankimage.Height/2,
							tankimage.Width/2,tankimage.Height/10)
		tankcanvas.Color = Color.Brown.Blend(Color.Black,.5)
		tankcanvas.DrawLine(tankimage.Width,tankimage.Height/2-5,							
							4,4)
		tankcanvas.Flush()
	End Method
End Class

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
Global myai:ai

Class MyWindow Extends Window
	Field mapwidth:Int=25,mapheight:Int=25
	Method New()
		myworld = New world(Width,Height,mapwidth,mapheight)
		myai = New ai()
		myai.mybrain.Push(New ai.brain(100,100))
		myai.mybrain.Get(0).insertinstruction(geneinst.moveforward,5)
		myai.mybrain.Get(0).insertinstruction(geneinst.turnright,5)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		myworld.drawmap(canvas)
		For Local i:Int=0 Until myai.mybrain.Length			
			myai.mybrain.Get(i).draw(canvas)
		Next
		If Keyboard.KeyReleased(Key.Space)
			myai.mybrain.Get(0).rungene(0)
			myai.mybrain.Get(0).rungene(1)
		End If
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

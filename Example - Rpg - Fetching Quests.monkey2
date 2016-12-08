#Import "<std>"
#Import "<mojo>"



Using std..
Using mojo..

Class npc
	Field nx:Int,ny:Int,nw:Int,nh:Int
	Field id:String
	Field hasquest:Bool
	Method New(id:String,x:Int,y:Int)
		Self.nx = x
		Self.ny = y
		Self.nw = 10
		Self.nh = 10
		Self.id = id
		Select id
			Case "Old man"
			hasquest = True
		End Select
	End Method
	Method draw(canvas:Canvas)
		Select id
			Case "Old man"
			canvas.Color = Color.Yellow
			canvas.DrawRect(nx,ny,nw,nh)
		End Select
	End Method	
End Class

Class player
	Field px:Float,py:Float
	Field pw:Int,ph:Int
	Field pinv:Int[] = New Int[50]
	Enum inventory
		gold=1,
		experience=2,
		flowers=3
	End Enum 
	Method New(x:Int,y:int)
		pw = 10
		ph = 10
		Self.px = x
		Self.py = y		
	End Method
	Method update()
		If Keyboard.KeyDown(Key.Right)
			px+=1
		End If
		If Keyboard.KeyDown(Key.Left)
			px-=1
		End If
		If Keyboard.KeyDown(Key.Up)
			py-=1
		End If
		If Keyboard.KeyDown(Key.Down)
			py+=1
		End If
		harvest()
		If Keyboard.KeyReleased(Key.Space) Then interact()
	End Method
	Method Interact()
		For Local i:=Eachin mynpc
			If rectsoverlap(px,py,pw,ph,i.nx,i.ny,i.nw,i.nh)
				myquestui.active = true				
			End If 	
		Next
	End Method
	Method harvest()
		Local tx:Int=(px+myworld.tw/2)/myworld.tw
		Local ty:Int=(py+myworld.tw/2)/myworld.th
		If myworlditems.map[tx,ty] = myworlditems.item.flower
		If myworlditems.mapinvisible[tx,ty] = False
			pinv[inventory.flowers] +=1
			myworlditems.mapinvisible[tx,ty] = True
			myworlditems.mapregrow[tx,ty] = 10
		End If
		End If 
	End Method
	Method draw(canvas:Canvas)
		canvas.Color = Color.White
		canvas.DrawRect(px,py,pw,ph)
		'draw inventory
		canvas.Color = Color.Black
		Local x:Int=0
		Local y:Int=myworld.sh-32
		canvas.DrawRect(0,y,myworld.sw,32)
		canvas.Color = Color.White
		canvas.DrawText("Flowers :"+pinv[inventory.flowers],x,y+4)
	End Method
	Method rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	    Return True
	End	Method
End Class

Class worlditems
	Field map:Int[,] = New Int[1,1]
	Field mapinvisible:Float[,] = New float[1,1]
	Field mapregrow:Int[,] = New Int[1,1]
	Field sw:Int,sh:Int,mw:Int,mh:Int
	Field tw:Float,th:Float
	Field delay:Int
	Enum item
		flower=1		
	End Enum 
	Method New(sw:Int,sh:Int,mw:Int,mh:int)		
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		Self.tw = Float(sw)/Float(mw)
		Self.th = Float(sh)/Float(mh)
		map = New Int[mw,mh]
		mapinvisible = New float[mw,mh]
		mapregrow= New int[mw,mh]
		makemap()		
	End Method
	Method makemap()
		' add some flowers
		SeedRnd(50)
		For Local i:=0 Until 10
			Local x:Int=Rnd(0,10)	
			Local y:Int=Rnd(0,10)
			x+=5
			y+=5
			map[x,y] = item.flower
		Next
	End Method
	Method update()
		delay -=1
		If delay <=0
			delay = 60
			For Local y:=0 Until mh
			For Local x:=0 Until mw
				If myworlditems.mapregrow[x,y] > 0
					myworlditems.mapregrow[x,y] -=1
					If myworlditems.mapregrow[x,y] = 0
						myworlditems.mapinvisible[x,y] = False					
					End If
				End If
			Next
			Next
		End If
	End Method
	Method draw(canvas:Canvas)
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			Local t:Int=map[x,y]
			If t>0
			Select t
				Case item.flower
				If mapinvisible[x,y] = False
				canvas.Color = New Color(.1,.5,.2)
				canvas.DrawRect(x*tw+3,y*th+th/2,3,th/2)
				canvas.Color = New Color(1,.3,.1)
				canvas.DrawCircle(x*tw+tw/3,y*th,tw/2)
				Else 'show hole itheground
				canvas.Color = New Color(.5,.3,.1)
				canvas.DrawCircle(x*tw+tw/3,y*th+th/3,tw/3)
				End If
			End Select
			End If
		Next
		Next
	End Method
End Class

Class world
	Field map:Int[,] = New Int[1,1]
	Field mw:Int,mh:Int,sw:Int,sh:Int
	Field tw:Float,th:Float
	Enum tile
		grass = 1,
		road = 2,
		water = 3	
	End Enum
	
	Method New(sw:Int,sh:Int,mw:int,mh:Int)
		Self.sw = sw
		Self.sh = sh
		Self.mw = mw
		Self.mh = mh
		Self.tw = Float(sw)/Float(mw)
		Self.th = Float(sh)/Float(mh)
		map = New Int[mw,mh]
		makemap()
	End Method
	Method makemap()
		'make grass
		For Local y:=0 until mh
		For Local x:=0 until mw
			map[x,y] = tile.grass
		Next
		Next		
		'make a river
		For Local y:=16 until 25
		For Local x:=0 until mw
			map[x,y] = tile.water
		Next
		Next
		' make a road
		For Local y:=0 Until mh
		For Local x:=32 Until 37		
			map[x,y] = tile.road
		Next
		Next
	End Method
	Method draw(canvas:Canvas)
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			Local t:Int=map[x,y]
			If t>0
			Select t
				Case tile.grass 'grass
				canvas.Color = Color.Green
				canvas.DrawRect(x*tw,y*th,tw,th)
				Case tile.road 'road
				canvas.Color = Color.Brown
				canvas.DrawRect(x*tw,y*th,tw,th)
				Case tile.water 'water
				canvas.Color = Color.Blue
				canvas.DrawRect(x*tw,y*th,tw,th)				
			End Select 
			End If
		Next
		Next
	End Method
End Class

Class quest
	Field questid:String
	Field isquestcomplete:Bool
	Field goldreward:Int
	Field xpreward:Int	
End Class 

Class questui
	Field questtext:String
	Field active:Bool
	Field qx:Int,qy:Int,qw:Int,qh:Int
	Method New()
		qx = 50
		qy = 50
		qw = 320
		qh = 200
		active = False
	End Method
	Method update()
		If active = False Then Return
		If Keyboard.KeyHit(Key.Space)
			active = False
			Keyboard.FlushChars()
		End If
	End Method
	Method draw(canvas:Canvas)
		If active = False Then Return
		canvas.Color = Color.Black
		canvas.DrawRect(qx,qy,qw,qh)
	End Method 
End Class

Global myquest:quest
Global myquestui:questui
Global myworld:world
Global myworlditems:worlditems
Global myplayer:player
Global mynpc:Stack<npc> = New Stack<npc>

Class MyWindow Extends Window

	Method New()
		myworld = New world(Width,Height,64,64)
		myworlditems = New worlditems(Width,Height,64,64)
		myquestui = New questui()
		myplayer = New player(300,300)
		mynpc.Push(New npc("Old man",500,200))
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		myplayer.update()
		myworlditems.update()
		myworld.draw(canvas)
		myworlditems.draw(canvas)
		For Local i:=Eachin mynpc
			i.draw(canvas)
		Next
		myplayer.draw(canvas)
		myquestui.update()
		myquestui.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

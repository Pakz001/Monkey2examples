#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global blinkspeed:Int=5 ' lower is faster
Global turn:Int=1
Global activeunitmovesleft:Float=1
Global gamehasmovesleft:Bool=True
Global cityscreenopen:Bool=False
Global keydelay:Int=0

Class citycontrols
	Method controls()
		If Keyboard.KeyReleased(Key.Escape)
			cityscreenopen = False
			keydelay = 0
		End If
	End Method
	
End Class

Class cityscreen
	Field Width:Int,Height:Int
	Method New(Width:Int,Height:Int)
		Self.Width = Width
		Self.Height = Height
	End Method
	Method draw(canvas:Canvas)
		canvas.Color = Color.Black
		canvas.DrawRect(50,50,Width-100,Height-100)	
	End Method
End Class

' Controls like mouse pressed and keyboard
Class controls
	'If press on city then open city sceen
	Method opencityscreen()
		If Mouse.ButtonReleased(MouseButton.Left)
		If mycitymethod.hascityatmousepos()
			cityscreenopen = true
		End If
		End If
		
	End Method
	'unit skip turn (space)
	Method activeunitskipturn()
		If Keyboard.KeyReleased(Key.Space)
			myunitmethod.activeunitskipturn()
			myunitmethod.activateamovableunit()
		End If
	End Method
	' build a road
	Method buildroad()
		If Keyboard.KeyReleased(Key.R)
			myunitmethod.buildroadatactiveunitpos()				
		End If
	End Method
	
	' End of turn
	Method myendofturn()
		If Keyboard.KeyReleased(Key.Enter)
			For Local i:=Eachin myunit
				i.movesleft = i.originalmoves
				i.active = False				
			Next
			gamehasmovesleft = true
			turn+=1
			myunitmethod.activateamovableunit()
			
		End If
	End Method
	' if mouse on unit then activate unit
	Method activateunit()
		If Mouse.ButtonReleased(MouseButton.Left) = False Then Return		
		Local x:Int=Mouse.X / myworld.tw
		Local y:Int=Mouse.Y / myworld.th
		If myunitmethod.ismovableunitatpos(x,y) = False Then return
		myunitmethod.unitsactivedisable()
		myunitmethod.activatemovableunitatpos(x,y)
	End Method
	' if pressed b then build city at active unit
	Method buildcity()
		If Keyboard.KeyReleased(Key.B)
			If myunitmethod.iscityatactiveunitpos() = true Then Return
			Local x:Int,y:Int
			'get the active unit x and y coordinates
			For Local i:=Eachin myunit
				If i.active = True
					x = i.x
					y = i.y
					i.deleteme = true
					Exit
				End If
			Next
			mycity.Add(New city(x,y))
			myunitmethod.activateamovableunit()
		End If
	End Method
	' add a unit to the map (cheat)
	Method addunit()
		If Keyboard.KeyDown(Key.LeftShift)
		If Mouse.ButtonReleased(MouseButton.Left)
			myunit.Add(New unit(Mouse.X/myworld.tw,Mouse.Y/myworld.th))
		End If
		End if
	End Method
	Method moveunit()
		If Mouse.ButtonReleased(MouseButton.Right)
			Local x:Int=Mouse.X / myworld.tw
			Local y:Int=Mouse.Y / myworld.th
			myunitmethod.moveactiveunitto(x,y)			
		End If
	End Method
End Class

Class city
	Field x:Int
	Field y:Int
	Field size:Int=1
	Field deleteme:Bool=False
	Method New(x:Int,y:int)
		If cityatpos(x,y) = True Then deleteme = True ; Return
		Self.x = x
		Self.y = y
		myunitmethod.removeactiveunit()
	End Method
	'return true if there is a city at the input coords
	Method cityatpos:Bool(x:Int,y:Int)
		For Local i:=Eachin mycity
			If i.x = x And i.y = y Then Return True
		Next
		Return False
	End Method
	'draw the city
	Method draw(canvas:Canvas)
		Local mx:Int=x*myworld.tw
		Local my:Int=y*myworld.th
		Local tw:Int=myworld.tw
		Local th:Int=myworld.th
		canvas.Color = New Color(1,0,0)
		canvas.DrawRect(mx,my,tw,th)
		canvas.Color = New Color(1,1,1)
		canvas.DrawRect(mx+4,my+4,tw-8,th-8)
		canvas.Color = New Color(0,0,0)
		canvas.DrawText(size,mx+tw/2,my+th/2,.5,.5)
	End Method
End Class

'city methods
Class citymethod
	Method hascityatmousepos:Bool()
		Local x:Int=Mouse.X / myworld.tw
		Local y:Int=Mouse.Y / myworld.th
		For Local i:=Eachin mycity
			If i.x = x And i.y = y
				Return True
			End If
		Next
		Return False
	End Method
End class

' Methods to modify units
Class unitmethod
	' skip the turn of a unit (set its moves to 0)
	Method activeunitskipturn()
		For Local i:=Eachin myunit
			If i.active = True
				i.active = False
				i.visible = true
				i.movesleft = 0
				Return
			End If
		Next
	End Method
	' returns if there is a city at the active unit its position	
	Method iscityatactiveunitpos:bool()	
		For Local i:=Eachin myunit
			If i.active=True
				For Local i2:=Eachin mycity
					If i2.x = i.x And i2.y = i.y Then Return true
				Next
			End If
		Next
		Return False
	End Method
	' build a road at the active unit its position
	Method buildroadatactiveunitpos()
		For Local i:=Eachin myunit
			If i.active = True And myworld.roadmap[i.x,i.y].hasroad = False
				i.active = False
				i.movesleft = 0
				i.visible = True
				myworld.roadmap[i.x,i.y].hasroad = True
				' has road north
				If i.y-1 >=0
					If myworld.roadmap[i.x,i.y-1].hasroad = True Then
						myworld.roadmap[i.x,i.y].n = True
						myworld.roadmap[i.x,i.y-1].s = true
					End If
				End If
				'has a road north east
				If i.x+1<myworld.mw And i.y-1 >=0
					If myworld.roadmap[i.x+1,i.y-1].hasroad = True
						myworld.roadmap[i.x,i.y].ne = True
						myworld.roadmap[i.x+1,i.y-1].sw = True
					End If
				End If
				'has a road east
				If i.x+1<myworld.mw 
					If myworld.roadmap[i.x+1,i.y].hasroad = True
						myworld.roadmap[i.x,i.y].e = True
						myworld.roadmap[i.x+1,i.y].w = True
					End If
				End If
				'has a road south east
				If i.x+1<myworld.mw 
					If myworld.roadmap[i.x+1,i.y+1].hasroad = True
						myworld.roadmap[i.x,i.y].se = True
						myworld.roadmap[i.x+1,i.y+1].nw = True
					End If
				End If
				'has a road south
				If i.y+1<myworld.mh
					If myworld.roadmap[i.x,i.y+1].hasroad = True
						myworld.roadmap[i.x,i.y].s = True
						myworld.roadmap[i.x,i.y+1].n = True
					End If
				End If
				'has a road south west
				If i.x-1 >=0 And i.y+1<myworld.mh
					If myworld.roadmap[i.x-1,i.y+1].hasroad = True
						myworld.roadmap[i.x,i.y].sw = True
						myworld.roadmap[i.x-1,i.y+1].ne = True
					End If
				End If
				'has a road west
				If i.x-1 >=0 
					If myworld.roadmap[i.x-1,i.y].hasroad = True
						myworld.roadmap[i.x,i.y].w = True
						myworld.roadmap[i.x-1,i.y].e = True
					End If
				End If
				'has a north west
				If i.x-1 >=0 And i.y-1>=0
					If myworld.roadmap[i.x-1,i.y-1].hasroad = True
						myworld.roadmap[i.x,i.y].nw = True
						myworld.roadmap[i.x-1,i.y-1].se = True
					End If
				End If
				'find next movable unit
				activateamovableunit()
				Exit
			End If
		Next
	End Method
	' this function finds a unit that has not moved yet.
	Method activateamovableunit()
		For Local i:=Eachin myunit
			If i.deleteme = False			
			If i.movesleft > .3				
				myunitmethod.disableunitontopat(i.x,i.y)
				i.active = True
				i.ontop = True
				i.visible = True
				i.blinktimer = 0
				activeunitmovesleft = i.movesleft
				Return
			End If			
			End If
		Next
		gamehasmovesleft=False
	End Method
	'activate unit at position	
	Method activatemovableunitatpos(x:int,y:int)
		For Local i:=Eachin myunit
			If i.x = x And i.y = y
			If i.movesleft > .3
				i.active = True
				myunitmethod.disableunitontopat(i.x,i.y)
				i.ontop = True
				i.visible = True
				i.blinktimer = 0
				activeunitmovesleft = i.movesleft
				return
			End if
			End If
		Next
	End Method
	' disable ontop flag at pos x,y
	Method disableunitontopat(x:Int,y:Int)
		For Local i:=Eachin myunit
			If i.x = x And i.y = y
				i.ontop = False
			End If
		Next
	End Method
	'see if there is a unit at pos x,y
	Method ismovableunitatpos:bool(x:Int,y:Int)
		For Local i:=Eachin myunit
			If i.x = x And i.y = y
				If i.movesleft > 0
					Return True
				End If
			End If
		Next
		Return False
	End Method
	'disable the active unit state
	Method unitsactivedisable()
		For Local i:=Eachin myunit
			If i.active = True
				i.active = False
				i.visible = True
				return
			End If
		Next
	End Method
	' Remove the current active unit
	Method removeactiveunit()
		For Local i:=Eachin myunit
			If i.active = True Then 
				i.active = False
				i.deleteme = True
			End If
		Next
	End Method
	' Move active unit to this possition if possible
	' checks if reachable. 
	Method moveactiveunitto(newposx:Int,newposy:Int)
		' if destination is water then return
		If myworld.map[newposx,newposy] <= 5 Then Return
		' find unit and move
		For Local i:=Eachin myunit
			If i.active = True And i.movesleft > .3				
				If i.x = newposx And i.y = newposy Then Return
				Local oldposx:Int=i.x
				Local oldposy:Int=i.y
				' see if we can move here.
				If rectsoverlap(newposx,newposy,1,1,oldposx-1,oldposy-1,3,3)										
					' at old position set one unit to visible
					' and ontop
					For Local i2:=Eachin myunit
						If i<>i2
						If i2.x = oldposx And i2.y = oldposy
							i2.visible = True							 
							i2.ontop = True							 
							Exit
						End If
						End If
					Next					
					' at new pos set units to invible
					' and not ontop
					For Local i2:=Eachin myunit
						If i2.x = newposx And i2.y = newposy
							i2.visible = False
							i2.ontop = False
						End If
					Next					
					i.x = newposx
					i.y = newposy
					i.visible = True
					i.ontop = True
					i.blinktimer = 0
					' here we do the movement cost
					If myworld.roadmap[newposx,newposy].hasroad = True
						i.movesleft -=.33
					Else
						i.movesleft -= 1
					End If
					activeunitmovesleft = i.movesleft
					If i.movesleft < .3 Then 
						i.visible = True
						i.active = False
						myunitmethod.activateamovableunit()
						return
					End If
				End If
			End If
		Next
	End Method
	
	
	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	    Return True
	End	 Function

End Class

Class unit
	Field x:Int,y:Int
	Field ontop:Bool=True
	Field active:Bool=False
	Field deleteme:Bool=False
	Field visible:Bool=True
	Field blinktimer:Int
	Field movesleft:Float=1
	Field originalmoves:Float=1
	Method New(mx:Int,my:Int)
		If myworld.map[mx,my] <= 5 Then deleteme=True ; return		
		Self.x = mx
		Self.y = my
		removeontop(mx,my)
		ontop = True
		removeallactivestatus()
		resetblink()
		active = True
	End Method
	' remove ontop status of all units at position x,y
	Method removeontop(mx:Int,my:Int)
		For Local i:=Eachin myunit
			If i.x = mx And i.y = my
				i.ontop = False
			End If
		Next
	End Method
	' Set active status of all units at x,y to false
	Method removeallactivestatus()
		For Local i:=Eachin myunit
			i.active = False
		Next
	End Method
	' Reset blink timers and set visible to true
	Method resetblink()
			For Local i:=Eachin myunit
				i.visible = True
				i.blinktimer = 0
			Next
	End Method
	Method draw(canvas:Canvas)
		If ontop = True And visible = True			
			Local mx:Float = x * myworld.tw
			Local my:Float = y * myworld.th
			Local rec:Recti<Int>
			rec.X = mx
			rec.Y = my
			rec.Size = New Vec2i(myworld.tw,myworld.th)
			canvas.Scissor = rec
			
			canvas.Color = New Color(1,1,1)
			canvas.DrawRect(mx,my,myworld.tw,myworld.th)
			'
			If movesleft <= .3 
				canvas.Color = New Color(.5,.5,.5)				
				For Local x1:Int = mx-10 Until mx+myworld.tw Step 5				
					canvas.DrawLine(x1,my,x1+10,my+myworld.th)
				Next				
			End If
		End If
	End Method
End Class

Class tile
	Field tw:Float
	Field th:Float
	Method New()
		Self.tw = myworld.tw
		Self.th = myworld.th
	End Method	

	Method drawmountain(x:Float,y:Float,canvas:Canvas)		
		SeedRnd(1)
		canvas.Color = New Color(.5,0.6,0.2)
		canvas.DrawRect(x,y,tw,th)
		For Local y2:Int=y Until y+th
		For Local x2:Int=x Until x+tw
			If Rnd(2)<.2
				canvas.Color = New Color(Rnd(0.3,0.5),Rnd(0.2,0.7),Rnd(0.1,0.3))
				canvas.DrawPoint(x2,y2)
			End If
		Next
		Next		
	End Method

	Method drawhill(x:Float,y:Float,canvas:Canvas)		
		SeedRnd(1)
		canvas.Color = New Color(.5,0.3,0)
		canvas.DrawRect(x,y,tw,th)
		For Local y2:Int=y Until y+th
		For Local x2:Int=x Until x+tw
			If Rnd(2)<.2
				canvas.Color = New Color(Rnd(0.3,0.5),Rnd(0.1,0.3),0)
				canvas.DrawPoint(x2,y2)
			End If
		Next
		Next		
	End Method


	Method drawtree(x:Float,y:Float,canvas:Canvas)		
		SeedRnd(1)
		canvas.Color = New Color(0,0.5,0)
		canvas.DrawRect(x,y,tw,th)		
		For Local i1:=0 Until 5
		Local x1:Float=x+Rnd(tw)
		Local y1:Float=y+Rnd(th)
		For Local i2:=0 Until 5
			Local x2:float=x1+Rnd(-5,5)
			Local y2:float=y1+Rnd(-5,5)
			canvas.Color = New Color(0,Rnd(0,0.5),0)
			canvas.DrawCircle(x2,y2,5)
		Next
		Next
		For Local y2:Int=y Until y+th
		For Local x2:Int=x Until x+tw
			If Rnd(2)<.2
				canvas.Color = New Color(0,Rnd(0.1,0.3),0)
				canvas.DrawPoint(x2,y2)
			End If
		Next
		Next		
	End Method

	Method drawgrass(x:float,y:Float,canvas:Canvas)		
		SeedRnd(1)
		canvas.Color = New Color(0,0.5,0)
		canvas.DrawRect(x,y,tw,th)
		For Local y2:Int=y Until y+th
		For Local x2:Int=x Until x+tw
			If Rnd(2)<.2
				canvas.Color = New Color(0,Rnd(0.2,0.6),0)
				canvas.DrawPoint(x2,y2)
			End If
		Next
		Next		
	End Method

	Method drawwater(x:float,y:Float,canvas:Canvas)		
		SeedRnd(1)
		canvas.Color = New Color(0,0,0.5)
		canvas.DrawRect(x,y,tw,th)
		For Local y2:Int=y Until y+th
		For Local x2:Int=x Until x+tw
			If Rnd(2)<.2
				canvas.Color = New Color(0,Rnd(0.2,0.3),Rnd(0.4,0.7))
				canvas.DrawPoint(x2,y2)
			End If
		Next
		Next		
	End Method
	
	Method drawwaterdeep(x:float,y:Float,canvas:Canvas)
		SeedRnd(1)
		canvas.Color = New Color(0,0,0.3)
		canvas.DrawRect(x,y,tw,th)
		For Local y2:Int=y Until y+th
		For Local x2:Int=x Until x+tw
			If Rnd(2)<.2
				canvas.Color = New Color(0,Rnd(0,0.1),Rnd(0.2,0.6))
				canvas.DrawPoint(x2,y2)
			End If
		Next
		Next
	End Method
End Class

Class world
	Class roadconnection
		Field hasroad:Bool = False
		Field n:Bool=False,ne:Bool=False
		Field e:Bool=False,se:Bool=False
		Field s:Bool=False,sw:Bool=False
		Field w:Bool=False,nw:Bool=false
		Method New()
			'n=True
			'e=True
			's=True
			'w=True
			'ne=True
			'se=True
			'sw=True
			'nw=True
			'hasroad=true
		End Method	
	End Class
	Field roadmap:roadconnection[,] = New roadconnection[1,1]
	Field map:Int[,] = New Int[1,1]
	Field tw:Float,th:Float
	Field sw:Int,sh:Int
	Field mw:Int,mh:Int
	Method New(sw:Int,sh:Int,mw:Int,mh:Int)
		Self.mw = mw
		Self.mh = mh
		Self.sw = sw
		Self.sh = sh
		tw = Float(sw)/Float(mw)
		th = Float(sh)/Float(mh)
		map = New Int[mw,mh]
		roadmap = New roadconnection[mw,mh]
		For Local my:=0 Until mh
		For Local mx:=0 Until mw
			roadmap[mx,my] = New roadconnection()
		Next
		Next
		makemap()
	End Method
	Method makemap()
		Local eloop:Bool=False		
		While eloop=False
			Local x1:Int=Rnd(-10,mw)
			Local y1:Int=Rnd(-10,mh)
			Local w:Int=Rnd(1,12)
			Local h:Int=Rnd(1,10)
			For Local y2:=y1 To y1+h
			For Local x2:=x1 To x1+w
				If x2>=0 And x2<mw And y2>=0 And y2<mh
					map[x2,y2] = map[x2,y2] + 1
					If map[x2,y2] > 46 Then eloop=True					
				End If
			Next
			Next		
		Wend
		For Local y:=0 Until mh
		For Local x:=0 Until mw
			map[x,y] = (10.0/46)*map[x,y]
		Next
		Next
	End Method
	Method draw(canvas:Canvas)
		For Local y:Float=0 Until mh Step 1
		For Local x:Float=0 Until mw Step 1
			Local t:Int=map[x,y]
			Local x2:Float=x*tw
			Local y2:Float=y*th
			Select t
			Case 0
			'canvas.Color = New Color(0,0,.5)
			mytile.drawwaterdeep(x2,y2,canvas)
			Case 2
			'canvas.Color = New Color(0,0,.6)
			mytile.drawwaterdeep(x2,y2,canvas)
			Case 3
			mytile.drawwaterdeep(x2,y2,canvas)
			'canvas.Color = New Color(0,0,.7)
			Case 4
			mytile.drawwater(x2,y2,canvas)
			'canvas.Color = New Color(.1,.1,.7)
			Case 5
			mytile.drawwater(x2,y2,canvas)
			Case 6
			mytile.drawgrass(x2,y2,canvas)
			'canvas.Color = New Color(.2,1,.1)
			Case 7
			'canvas.Color = New Color(0,.5,0)
			mytile.drawtree(x2,y2,canvas)
			Case 8
			'canvas.Color = New Color(0,.2,0)			
			mytile.drawhill(x2,y2,canvas)
			Case 9
			mytile.drawmountain(x2,y2,canvas)
			'canvas.Color = New Color(.9,.8,.9)			
			Case 10
			mytile.drawmountain(x2,y2,canvas)
			'canvas.Color = New Color(.9,.9,.9)			
			End Select
			'canvas.DrawRect(x*tw,y*th,tw,th)
		Next
		Next
	End Method
	Method drawroads(canvas:Canvas)	
		canvas.Color = New Color(.7,.3,0)
		For Local y:Float=0 Until mh Step 1
		For Local x:Float=0 Until mw Step 1			
			Local x2:Float=x*tw
			Local y2:Float=y*th
			Local cx:Float=x2+tw/2
			Local cy:Float=y2+th/2
			If roadmap[x,y].hasroad = True
				canvas.DrawRect(x2+tw/2,y2+th/2,4,4)			
				If roadmap[x,y].n = True Then
					canvas.DrawLine(cx,cy,cx,cy-th/2)				
				End If
				If roadmap[x,y].ne = True Then
					canvas.DrawLine(cx,cy,cx+tw/2,cy-th/2)				
				End If
				If roadmap[x,y].e = True Then
					canvas.DrawLine(cx,cy,cx+tw/2,cy)				
				End If
				If roadmap[x,y].se = True Then
					canvas.DrawLine(cx,cy,cx+tw/2,cy+th/2)				
				End If
				If roadmap[x,y].s = True Then
					canvas.DrawLine(cx,cy,cx,cy+th/2)				
				End If
				If roadmap[x,y].sw = True Then
					canvas.DrawLine(cx,cy,cx-tw/2,cy+th/2)				
				End If
				If roadmap[x,y].w = True Then
					canvas.DrawLine(cx,cy,cx-tw/2,cy)				
				End If
				If roadmap[x,y].nw = True Then
					canvas.DrawLine(cx,cy,cx-tw/2,cy-th/2)				
				End If
				
			End If
		Next
		Next		
	End Method
	Method drawwateredge(canvas:Canvas)
		For Local my:=0 Until mh
		For Local mx:=0 until mw
			Local lefttopx:Int=mx*tw
			Local lefttopy:Int=my*th
			Local righttopx:Int=mx*tw+tw
			Local righttopy:Int=my*th
			Local rightbottomx:Int=mx*tw+tw
			Local rightbottomy:Int=my*th+th
			Local leftbottomx:Int=mx*tw
			Local leftbottomy:Int=my*th+th
			If map[mx,my] <= 5 'if water tile
			If mx-1>=0 And map[mx-1,my] > 5 'if left is land
				drawwaterline(canvas,lefttopx,lefttopy,leftbottomx,leftbottomy)
			End If
			If my-1>=0 And map[mx,my-1] > 5 'if top is land
				drawwaterline(canvas,lefttopx,lefttopy,righttopx,righttopy)
			End If
			If mx+1<mw And map[mx+1,my]>5 'if right is land
				drawwaterline(canvas,righttopx,righttopy,rightbottomx,rightbottomy)
			End If
			If my+1<mh And map[mx,my+1]>5 'if bottom is land
				drawwaterline(canvas,leftbottomx,leftbottomy,rightbottomx,rightbottomy)
			End If
			End If
		Next
		Next
	End Method
	Method drawwaterline(canvas:Canvas,x1:float,y1:Float,x2:float,y2:float)		
		SeedRnd(0)
		Local oldx:Float=x1,oldy:Float=y1
		Local x3:Float=x1,y3:Float=y1
		Repeat
			If x3<x2 Then x3+=Rnd(1)
			If y3<y2 Then y3+=Rnd(1)
			If x3>x2 Then x3-=Rnd(1)
			If y3>y2 Then y3-=Rnd(1)
			canvas.Color = New Color(0,Rnd(0.1,.2),Rnd(0.7,1))
			canvas.DrawRect(x3+Rnd(-2,2),y3+Rnd(-2,2),Rnd(2,4),Rnd(2,4))
			If Rnd(1)<.5
			canvas.Color = New Color(1,1,1)
			canvas.DrawPoint(x3,y3)
			End if
			If rectsoverlap(x3,y3,2,2,x2,y2,2,2) Then Return
		Forever
	End Method	
	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
	    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
	    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
	    Return True
	End	 Function	
End Class

Global mycontrols:controls
Global myworld:world
Global mytile:tile
Global myunit:List<unit> = New List<unit>
Global myunitmethod:unitmethod
Global mycity:List<city> = New List<city>
Global mycityscreen:cityscreen
Global mycitymethod:citymethod
Global mycitycontrols:citycontrols

Class MyWindow Extends Window
	Method New()
		Title="CivClone"
		myworld = New world(Width,Height,16,16)
		mytile = New tile()
		myunit.Add(New unit(5,5))
		myunitmethod = New unitmethod()
		mycityscreen = New cityscreen(Width,Height)
		mycitymethod = New citymethod()
		mycitycontrols = New citycontrols()
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		keydelay+=1
		App.RequestRender() ' Activate this method 
		'
		If cityscreenopen = False
		If Keyboard.KeyDown(Key.F1) = False
		mycontrols.addunit()
		mycontrols.moveunit()
		mycontrols.buildcity()
		mycontrols.activateunit()
		mycontrols.myendofturn()
		mycontrols.buildroad()
		mycontrols.activeunitskipturn()
		mycontrols.opencityscreen()
		End If
		End If
		If cityscreenopen = True
			mycitycontrols.controls()
			mycityscreen.draw(canvas)
		End If
		If cityscreenopen = False
			updatemapingame(canvas,Width,Height)
		End If
		
		' if key escape then quit
		If keydelay>10 And cityscreenopen = False
			If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
		End If
	End Method	
	
End	Class

Function updatemapingame(canvas:Canvas,Width:Int,Height:int)
		'Draw world
		myworld.draw(canvas)
		myworld.drawwateredge(canvas)
		'Draw roads
		myworld.drawroads(canvas)

		' Draw cities
		For Local i:=Eachin mycity
			i.draw(canvas)
		Next
		'Draw units
		For Local i:=Eachin myunit
			i.draw(canvas)
		Next		
		' Refresh unit list
		For Local i:=Eachin myunit
			' blink update
			If i.active = True 
				i.blinktimer += 1
				If i.blinktimer > blinkspeed
					i.blinktimer = 0
					If i.visible = True Then i.visible = False Else i.visible = true
				End If
			End If
			If i.deleteme = True Then myunit.Remove(i)
		Next
		' Refresh city list
		For Local i:=Eachin mycity
			If i.deleteme = True Then mycity.Remove(i)
		Next	
		'
		Local rec:Recti<Int>
		rec.X = 0
		rec.Y = 0
		rec.Size = New Vec2i(Width,Height)
		canvas.Scissor = rec
		
		canvas.Color = New Color(0,0,0)
		canvas.DrawRect(0,Height-20,70,20)
		canvas.Color = New Color(1,1,1)
		canvas.DrawText("Turn:"+turn,0,Height-15)

		canvas.Color = New Color(0,0,0)
		canvas.DrawRect(100,Height-20,180,20)
		canvas.Color = New Color(1,1,1)
		Local mystr:String = "Moves Left:"+activeunitmovesleft
		canvas.DrawText(mystr.Mid(0,14),100,Height-15)
		
		If gamehasmovesleft = False
		canvas.Color = New Color(0,0,0)
		canvas.DrawRect(300,Height-20,200,20)
		canvas.Color = New Color(1,1,1)
		canvas.DrawText("Press Enter for new turn",300,Height-15)
		End If

		canvas.Color = New Color(0,0,0)
		canvas.DrawRect(500,Height-20,200,20)
		canvas.Color = New Color(1,1,1)
		canvas.DrawText("Hold F1 for help.",500,Height-15)


		If Keyboard.KeyDown(Key.F1) Then drawhelpscreen(canvas,Width,Height)
End function

Function drawhelpscreen(canvas:Canvas,Width:int,Height:Int)
	canvas.Color = New Color(0,0,0)
	canvas.DrawRect(50,50,Width-100,Height-100)
	canvas.Color = Color.White
	canvas.DrawText("F1 - This help screen",60,60)
	canvas.DrawText("Left Mouse on movable Unit - Activate unit",60,80)
	canvas.DrawText("Left Mouse and Shift - Create unit",60,100)
	canvas.DrawText("Right Mouse - Move active unit.",60,120)
	canvas.DrawText("R - Build Road",60,140)
	canvas.DrawText("B - Build City",60,160)
	canvas.DrawText("Enter - Next Turn",60,180)
	canvas.DrawText("Space - Unit Skip Turn.",60,200)
	canvas.DrawText("Left Mouse on City - Open city screen",60,220)
	
End Function

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

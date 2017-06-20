#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global blinkspeed:Int=5 ' lower is faster
Global turn:Int=1

' Controls like mouse pressed and keyboard
Class controls
	' End of turn
	Method endofturn()
		If Keyboard.KeyReleased(Key.Enter)
			For Local i:=Eachin myunit
				i.movesleft = i.originalmoves
			Next
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

' Methods to modify units
Class unitmethod
	' this function finds a unit that has not moved yet.
	'note : currently it only activas ontop units.
	Method activateamovableunit()
		For Local i:=Eachin myunit
			If i.deleteme = False
			If i.ontop = True
			If i.movesleft > 0
				i.active = True
				i.visible = True
				i.blinktimer = 0
				Return
			End If
			End If
			End if
		Next
	End Method
	'activate unit at position	
	Method activatemovableunitatpos(x:int,y:int)
		For Local i:=Eachin myunit
			If i.x = x And i.y = y
			If i.movesleft > 0
				i.active = True
				i.ontop = True
				i.visible = True
				i.blinktimer = 0
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
	Method moveactiveunitto(x:Int,y:Int)
		' if destination is water then return
		If myworld.map[x,y] <= 5 Then Return
		' find unit and move
		For Local i:=Eachin myunit
			If i.active = True And i.movesleft >= 1				
				If i.x = x And i.y = y Then Return
				' see if we can move here.
				If rectsoverlap(x,y,1,1,i.x-1,i.y-1,3,3)					
					' at old position set one unit to visible
					' and ontop
					For Local i2:=Eachin myunit
						If i<>i2
						If i2.x = i.x And i2.y = i.y
							i2.visible = True							 
							i2.ontop = True							 
							Exit
						End If
						End If
					Next					
					' at new pos set units to invible
					' and not ontop
					For Local i2:=Eachin myunit
						If i2.x = x And i2.y = y
							i2.visible = False
							i2.ontop = False
						End If
					Next					
					i.x = x
					i.y = y
					i.visible = True
					i.ontop = True
					i.blinktimer = 0
					i.movesleft -= 1
					If i.movesleft <= 0 Then 
						i.visible = True
						i.active = False
						myunitmethod.activateamovableunit()
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
			If movesleft <= 0 
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
		canvas.Color = New Color(0,0.3,0)
		canvas.DrawRect(x,y,tw,th)
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
End Class

Global mycontrols:controls
Global myworld:world
Global mytile:tile
Global myunit:List<unit> = New List<unit>
Global myunitmethod:unitmethod
Global mycity:List<city> = New List<city>

Class MyWindow Extends Window
	Method New()
		Title="CivClone"
		myworld = New world(Width,Height,16,16)
		mytile = New tile()
		myunit.Add(New unit(5,5))
		myunitmethod = New unitmethod()
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		mycontrols.addunit()
		mycontrols.moveunit()
		mycontrols.buildcity()
		mycontrols.activateunit()
		mycontrols.endofturn()
		'Draw world
		myworld.draw(canvas)
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
		canvas.DrawRect(0,Height-20,50,20)
		canvas.Color = New Color(1,1,1)
		canvas.DrawText("Turn:"+turn,0,Height-15)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

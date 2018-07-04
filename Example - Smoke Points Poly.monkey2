'
' CLouds from explosions test

'
' What I am trying to do here is to create smoke that expands
' and gets shaped by the game level. If on side of the smoke hits
' a wall then the points that make up the smoke there will not move
' into the level so the smoke stays inside the level.
' The smoke is a series of points that gets drawn as a poly.
'
'
'

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class cloud
	Field px:Float,py:Float
	Field mypoint:Stack<point>
	Field timeout:Int=200
	Field deleteme:Bool=False
	Class point
		Field px:Float,py:Float
		Field mx:Float,my:Float		
		Method New(x:Int,y:Int,mx:Float,my:Float)
			Self.px = x
			Self.py = y
			Self.mx = mx
			Self.my = my						
		End Method		
	End Class
	Method New(x:Int,y:Int)
		Self.px = x
		Self.py = y
		mypoint = New Stack<point>
		createcloud()
	End Method
	Method createcloud()
		For Local i:Float=-Pi Until Pi Step .5
			Local a:Float=Cos(i)/Rnd(5,9)
			Local b:Float=Sin(i)/Rnd(5,9)
			mypoint.Push(New point(px,py,a,b))
		Next
	End Method
	Method update()
		timeout-=1
		If timeout<0 Then deleteme = True
		For Local i:Int=0 Until mypoint.Length
			Local x:Float = mypoint.Get(i).px
			Local y:Float = mypoint.Get(i).py
			x += mypoint.Get(i).mx
			y += mypoint.Get(i).my
			mypoint.Get(i).px = x
			mypoint.Get(i).py = y
		Next
	End Method
	Method draw(canvas:Canvas)
		For Local i:Int=0 Until mypoint.Length
			canvas.Color = Color.Red
			Local x:Int=mypoint.Get(i).px
			Local y:Int=mypoint.Get(i).py
			canvas.DrawCircle(px+x,py+y,4)
		Next
		' draw the poly
		Local pol:Float[]
		pol = New Float[mypoint.Length*2]
		For Local i:Int=0 Until mypoint.Length
			pol[i*2] = mypoint.Get(i).px+px
			pol[i*2+1] = mypoint.Get(i).py+py
			
		Next
		canvas.Color = Color.Grey
		canvas.DrawPoly(pol)
	End Method
End Class

Class MyWindow Extends Window
	Field mycloud:cloud
	Method New()
		mycloud = New cloud(100,100)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		mycloud.update()
		If mycloud.deleteme = True Then
			'mycloud = New cloud(Rnd(100,400),Rnd(100,300))
			mycloud = New cloud(100,100)
		End If
		mycloud.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Class MyWindow Extends Window

	Field numpoints:Int=20
	Field point:Vec2i[]
	Field wrap:Stack<Vec2i>
	Method New()
		wrapit()

	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method
		canvas.Color=Color.White
		For Local i:Int=0 Until point.Length
			canvas.DrawRect(point[i].x,point[i].y,2,2)
		Next
		
		For Local i:Int=1 Until wrap.Length
			
			canvas.DrawLine(wrap[i].x,wrap[i].y,wrap[i-1].x,wrap[i-1].y)
		Next
			canvas.DrawLine(wrap[0].x,wrap[0].y,wrap[wrap.Length-1].x,wrap[wrap.Length-1].y)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	

	Method wrapit()
		SeedRnd(Microsecs())
		point = New Vec2i[numpoints]
		For Local i:Int=0 Until numpoints
			point[i].x = Rnd(100,640-100)
			point[i].y = Rnd(100,480-100)
		Next
		wrap = New Stack<Vec2i>
		
		Local lp:Vec2i = New Vec2i(1000,1000)
		For Local i:Int=0 Until numpoints
			If point[i].x<lp.x Then lp.x = point[i].x ; lp.y=point[i].y
		Next

		Local endpoint:Vec2i = New Vec2i()
	    Repeat
	    	wrap.Push(lp)
	    	endpoint = point[0]
	
	    	For Local i:Int=1 Until numpoints
	        	If ((lp=endpoint) Or (orientation(lp.x,lp.y,endpoint.x,endpoint.y,point[i].x,point[i].y)=-1))
	    	    	endpoint = point[i]
	       		End If
			Next
	        lp=endpoint
	
	    Until Not(endpoint <> wrap.Get(0))
	End Method
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

	' Return the angle from - to in float
	Function getangle:Float(x1:Int,y1:Int,x2:Int,y2:Int)
		Return ATan2(y2-y1, x2-x1)
	End Function	
	'line a to b and point left(<0) or center(0) or right(>0) is c
	Function orientation:Int(ax:Int,ay:Int,bx:Int,by:Int,cx:Int,cy:Int)
		Return Sgn((bx-ax)*(cy-ay)-(by-ay)*(cx-ax))	
	End Function

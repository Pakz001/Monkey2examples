#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class world
	Class kagent
		Field kx:Int,ky:Int
	End Class
	Class kobstacle
		Field kx:Int,ky:Int
		Field incx:Int,incy:Int
		Field kw:Int,kh:Int
		Field kd:String
		Method New(x:Int,y:Int,w:Int,h:Int,d:String)
			Self.kx = x
			Self.ky = y
			Self.kw = w
			Self.kh = h
			If d = "u" Then incy = -1
			If d = "d" Then incy = 1
			Self.kd = d
		End Method
		Method update()			
			kx += incx
			ky += incy
			If collidemap() Then
				If kd = "u" Then 
					kd = "d"
					incy = 1					
				Elseif kd = "d"
					kd = "u"
					incy = -1
				End If
			End If 
		End Method
		Method draw(canvas:Canvas)
			canvas.Color = Color.Blue
			canvas.DrawOval(kx+kw/2,ky+kh/2,kw,kh)
		End Method
		Method collidemap:Bool()
			Local cx:Int=(kx+kw/2)/myworld.tw
			Local cy:Int=(ky+kh/2)/myworld.th
			For Local y1:Int=cy-2 To cy+2
			For Local x1:Int=cx-2 To cx+2
				If x1<0 Or y1<0 Or x1>=myworld.mapw Or y1>=myworld.maph Then Continue
				If myworld.map[x1,y1] = 1
					Local x2:Int=x1*myworld.tw
					Local y2:Int=y1*myworld.th					
					If rectsoverlap(kx+kw/2,ky+kh/2,kw,kh,x2,y2,myworld.tw,myworld.th) Then Return True
				End if
			Next
			Next
			Return False
		End Method
		Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
		    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
		    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
		    Return True
		End Function
	End Class
	'
	Field sw:Int,sh:Int
	Field tw:Float,th:Float
	Field mapw:Int,maph:Int
	Field map:Int[,]
	Field myagent:Stack<kagent> = New Stack<kagent>
	Field myobstacle:Stack<kobstacle> = New Stack<kobstacle>
	Method New(sw:Int,sh:Int)
		Self.sw = sw
		Self.sh = sh
		setmap1()
	End Method
	Method update()
		For Local i:Int=0 Until myobstacle.Length
			myobstacle.Get(i).update()
		Next
	End Method
	Method setmap1()
		Local l:String[] = New String[10]
		' 0 - floor
		' 1 - wall
		' a - start position
		' z - end position
		' u - move up obstacle
		' d - move down obstacle
		l[0]="00000011111111000000"
		l[1]="000000101010d1000000"
		l[2]="00000010101001000000"
		l[3]="11111010d0d001011111"
		l[4]="10001110000001110001"
		l[5]="1a0000000000000000z1"
		l[6]="10001110000001110001"
		l[7]="11111010101001011111"
		l[8]="0000001u1u1u01000000"
		l[9]="00000011111111000000"
		map = New Int[l[0].Length,l.GetSize(0)]
		mapw = map.GetSize(0)
		maph = map.GetSize(1)
		tw = Float(sw)/Float(map.GetSize(0))
		th = Float(sh)/Float(map.GetSize(1))
		For Local y:Int=0 Until map.GetSize(1)
		For Local x:Int=0 Until map.GetSize(0)
			Local t:String=l[y].Mid(x,1)
			Select t
				Case "0"
					map[x,y] = 0
				Case "1"
					map[x,y] = 1
				Case "u","d"
					myobstacle.Push(New kobstacle(x*tw,y*th,tw/2,th/2,t))
			End Select
		Next
		Next
	End Method
	Method draw(canvas:Canvas)
		For Local y:Int=0 Until map.GetSize(1)
		For Local x:Int=0 Until map.GetSize(0)
			Select map[x,y]
				Case 0
					canvas.Color = Color.DarkGrey
				Case 1
					canvas.Color = Color.Grey
			End Select
			canvas.DrawRect(x*tw,y*th,tw+1,th+1)
		Next
		Next
		' draw the obstacles
		For Local i:Int=0 Until myobstacle.Length
			myobstacle.Get(i).draw(canvas)
		Next
	End Method
End Class

Global myworld:world

Class MyWindow Extends Window

	Method New()
		myworld = New world(Width,Height)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		myworld.update()
		myworld.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

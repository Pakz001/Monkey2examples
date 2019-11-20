#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global mapwidth:Int=200,mapheight:Int=200
Global numpoints:Int=20

Class MyWindow Extends Window
	
	Field nm:Int
	
	Field point:Vec2i[]
	Field pointvisited:Bool[]
	Field map:Int[,]

	Method New()
		newmap()
	End Method
			
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		nm+=1
		If nm>500 Then newmap() ; nm=0
		'
		drawmap(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	

	Method newmap()
		map = New Int[mapwidth,mapheight]
		point = New Vec2i[numpoints]
		For Local i:Int=0 Until point.GetSize(0)
			point[i].y = Rnd(4,mapheight-4)
			point[i].x = Rnd(4,mapwidth-4)
		Next
		pointvisited = New Bool[numpoints]
		'
		Local exitloop:Bool=False
		While exitloop=False			
			' pick a random point and connect it to 
			' a unconnected point
			Local p1:Int=Rnd(numpoints)
			Local p2:Int
			Local exitloop2:Bool=False
			While exitloop2=False
				p2 = Rnd(numpoints)
				If pointvisited[p2] = False Then 
					exitloop2 = True
					pointvisited[p2] = True
				End If
			Wend
			' Tunnel point1 to point 2
			'
			Local angle:Float=getangle(point[p1].x,point[p1].y,point[p2].x,point[p2].y)
			Local tx:Float=point[p1].x,ty:Float=point[p1].y
			Local cnt:Int,cnt2:Int
			Local m2:Float
			Local phase1:Bool=False
			While distance(tx,ty,point[p2].x,point[p2].y) > 2
				
				cnt+=1
				If distance(tx,ty,point[p2].x,point[p2].y) > 20 And cnt>10 And phase1=False Then
					angle+=Rnd(-1,1)
					cnt=0		
					phase1=True	
					Elseif distance(tx,ty,point[p2].x,point[p2].y) < 20					
					phase1=False
				End If			
				If phase1=True Then cnt2+=1
				If cnt2>5 Then phase1=False;cnt2=0;cnt=0
				If phase1=False Then angle=getangle(tx,ty,point[p2].x,point[p2].y)
			
				
				tx+=Cos(angle)
				ty+=Sin(angle)
				
				For Local y:Int=-1 To 1
				For Local x:Int=-1 To 1
					If tx>4 And tx<mapwidth-4 And ty>4 And ty<mapheight-4
					map[tx+x,ty+y] = 1
					End If
				Next
				Next
			'Next
			Wend
			
			'
			exitloop=True
			For Local i:Int=0 Until pointvisited.GetSize(0)
				If pointvisited[i] = False Then
					exitloop=False
				End If
			Next
			
		Wend
		'

	End Method
	
	Method drawmap(canvas:Canvas)
		Local tw:Float=(Float(Width)/Float(mapwidth))
		Local th:Float=(Float(Height)/Float(mapheight))
		For Local y:Int=0 Until mapheight
		For Local x:Int=0 Until mapwidth
			If map[x,y] = 1
				canvas.Color = Color.White
				canvas.DrawRect(Float(x)*tw,Float(y)*th,tw,th)
			End If
		Next
		Next
	End Method
	
End	Class
    Function distance:Float(x1:Float,y1:Float,x2:Float,y2:Float)   
    Return Abs(x2-x1)+Abs(y2-y1)   
    End Function
	' Return the angle from - to in float
	Function getangle:Float(x1:Int,y1:Int,x2:Int,y2:Int)
		Return ATan2(y2-y1, x2-x1)
	End Function	    
Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

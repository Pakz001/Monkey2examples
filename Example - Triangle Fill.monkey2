#Import "<std>"
#Import "<mojo>"

'
' Fill triangles using the bresenham algorithm
'

Using std..
Using mojo..

Class filledtriangle
	Field x1:Int,y1:Int
	Field x2:Int,y2:Int
	Field x3:Int,y3:Int
	Field lowesty:Int
	Field sizey:Int
	Field lefty:Int[]
	Field righty:Int[]
	Method New(canvas:Canvas,x1:Int,y1:int,x2:int,y2:int,x3:int,y3:int)
		If x1<0 Then x1=0 
		If y1<0 Then y1=0
		If x2<0 Then x2=0
		If y2<0 Then y2=0
		If x3<0 Then x3=0
		If y3<0 Then y3=0
		'find lowest
		If y1<y2 And y1<y3 Then lowesty = y1
		If y2<y1 And y2<y3 Then lowesty = y2
		If y3<y1 And y3<y2 Then lowesty = y3
		'find height
		If y1>y2 And y1>y3 Then sizey = y1-lowesty
		If y2>y1 And y2>y3 Then sizey = y2-lowesty
		If y3>y1 And y3>y2 Then sizey = y3-lowesty
		'
		'
		If sizey = 0 Then Return
		lefty = New Int[sizey+1]
		righty = New Int[sizey+1]
		bline(x1,y1,x2,y2)
		bline(x2,y2,x3,y3)
		bline(x1,y1,x3,y3)
		For Local y:Int=0 until sizey
			canvas.DrawLine(lefty[y],lowesty+y,righty[y],lowesty+y)
		Next
	End Method
	Method bline:Void(x4:Int,y4:Int,x5:Int,y5:Int)
	    Local dx:Int, dy:Int, sx:Int, sy:Int, e:Int
	    dx = Abs(x5 - x4)
	    sx = -1
	    If x4 < x5 Then sx = 1      
	    dy = Abs(y5 - y4)
	    sy = -1
	    If y4 < y5 Then sy = 1
	    If dx < dy Then 
	        e = dx / 2 
	    Else 
	        e = dy / 2          
	    End If
	    Local exitloop:Bool=False
	    While exitloop = False
			' Here we fill the left and right sides arrays.
			' we draw lines between these later on to fill the triangle		  	      		
	      	
	    	If lefty[y4-lowesty] = 0 Then 
	     		lefty[y4-lowesty] = x4
	    	Elseif righty[y4-lowesty] = 0
	   			righty[y4-lowesty] = x4	
	     	Else
		    	If lefty[y4-lowesty] = x4 Then 
			    	lefty[y4-lowesty] = x4
				Else
					righty[y4-lowesty] = x4	
				End If   	
	      	End If
	  

	      If x4 = x5 
	          If y4 = y5
	              exitloop = True
	          End If
	      End If
	      If dx > dy Then
	          x4 += sx ; e -= dy 
	           If e < 0 Then e += dx ; y4 += sy
	      Else
	          y4 += sy ; e -= dx 
	          If e < 0 Then e += dy ; x4 += sx
	      Endif

	    Wend
	
	End Method
		
End Class

Class MyWindow Extends Window
	Field cnt:Int
	Field mytriangle:filledtriangle
	Method New()
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		SeedRnd(cnt)
		For Local i:=0 Until 100
		Local x1:Int=Rnd(50,Width-50)
		Local y1:Int=Rnd(50,Height-50)
		Local x2:Int=x1+Rnd(-80,80)
		Local y2:Int=y1+Rnd(-80,80)
		Local x3:Int=x1+Rnd(-80,80)
		Local y3:Int=y1+Rnd(-80,80)		
		mytriangle = New filledtriangle(canvas,x1,y1,x2,y2,x3,y3)
		Next
		If Keyboard.KeyReleased(Key.Space) Then cnt+=1
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

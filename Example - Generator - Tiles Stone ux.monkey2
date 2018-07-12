#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class tilegen
	Field map:Int[,]
	Field imw:Int,imh:Int
	Field im:Image
	Field imcan:Canvas
	Field col:Color
	Method New(w:Int,h:Int,col:Color)
		Self.imw = w
		Self.imh = h
		Self.col = col
		im = New Image(w,h)
		imcan = New Canvas(im)
		map = New Int[w,h]
		generateim()
		createim()
	End Method 
	Method generateim()
		Local bh:Int=imh/3
		Local bw:Int=Rnd(imw/4,imw/2)
		'mapblock(0,0,32,32)
		Local x:Int=0
		Local y:Int=0
		Repeat
		Repeat 
			mapblock(x,y,bw,bh)	
			x+=bw
			bw=Rnd(imw/4,imw/2)
			If (x+9)+bw>=imw Then 
				mapblock(x,y,(imw-x-1),bh)	
				Exit
			End If
		Forever
		x=0
		bw=Rnd(imw/4,imw/2)
		y+=bh
		Until y>=imh
	End Method
	Method mapblock(x:Int,y:Int,w:Int,h:Int)
		If w<3 Or h<3 Then Return
		If x+w >= imw Or y+h >= imh Then Return
		'light edges
		For Local x2:Int=x Until x+w
			map[x2,y] = 1
			
			If x2+1<x+w-1 Then map[x2+1,y+1] = 4
			If x2+2<x+w-1 Then map[x2+2,y+2] = 4
		Next
		For Local y2:Int=y Until y+h
			map[x+w-1,y2] = 1
			If y2+3<y+h Then map[x+w-2,y2+1] = 4
			If y2+4<y+h Then map[x+w-3,y2+1] = 4
		Next
		'dark edges
		For Local y2:Int=y+1 Until y+h
			map[x,y2] = 1
			If y2+3<y+h Then map[x+1,y2+1] = 2
			If y2+4<y+h Then map[x+2,y2+1] = 2
		Next
		For Local x2:Int=x Until x+w
			map[x2,y+h-1] = 1
			If x2+2<x+w Then map[x2+1,y+h-2] = 2
			If x2+3<x+w Then map[x2+1,y+h-3] = 2
		Next
		' Fill remaining
		For Local y2:Int=y Until y+h
		For Local x2:Int=x Until x+w
			If map[x2,y2] = 0 Then map[x2,y2] = 3
		Next
		Next
		' edge smear TOP
		For Local x2:Int=x Until x+w
			If Rnd()<.1 Then map[x2,y+1] = 2
			If Rnd()<.1 Then 
				map[x2,y+3] = 4
				If Rnd()<.3
					map[x2,y+4] = 4
				End If
			End If
		Next		
'		' edge smear LEFT
		For Local y2:Int=y+1 Until y+(h-1)
			If Rnd() < .2 Then 
				map[x+1,y2] = 1
				Local d:Int=Rnd(1,3)
				Local y3:Int=y2
				While y3<y+h And y3<y2+d
					map[x+1,y3] = 1
					y3+=1
				Wend
			End If
			If Rnd() < .2
				If x+3 < imw Then map[x+3,y2] = 2
			End If
		Next
		' edge smear RIGHT
		For Local y2:Int=y+1 Until y+(h-1)
			If Rnd() < .2 Then 
				map[x+w-2,y2] = 3
				Local d:Int=Rnd(1,3)
				Local y3:Int=y2
				While y3<y+h And y3<y2+d
					map[x+w-4,y3] = 4
					y3+=1
				Wend
			End If			
		Next
		' edge smear BOTTOM
		For Local x2:Int=x Until x+w
			If Rnd()<.2 Then map[x2,y+h-2] = 1
			If Rnd()<.3 Then 
				map[x2,y+h-3] = 2
				If Rnd()<.5
					map[x2,y+h-4] = 2
				End If
			End If
		Next		
		
	End Method
	Method createim()
		For Local y:Int=0 Until imh
		For Local x:Int=0 Until imw
			'If map[x,y] = 0 Then Continue
			Select map[x,y]
				Case 0
					imcan.Color = col.Blend(Color.Black,.8)
				Case 1
					imcan.Color = col.Blend(Color.Black,.6)
				Case 2
					imcan.Color = col.Blend(Color.Black,.4)
				Case 3
					imcan.Color = col
				Case 4
					imcan.Color = col.Blend(Color.White,.5)
			End Select
			imcan.DrawPoint(x,y)	
		Next
		Next
		imcan.Flush()
	End Method
End Class 

Class MyWindow Extends Window
	Field mywall:tilegen
	Method New()
		mywall = New tilegen(64,64,Color.Brown)
	End method

	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method
		'
		canvas.DrawImage(mywall.im,100,100,0,3,3)
		If Keyboard.KeyDown(Key.Space)
			canvas.Color = Color.White
			For Local y:Int=0 Until Height Step 64
			For Local x:Int=0 Until Width Step 64
				Local w:tilegen = New tilegen(64,64,Color.Brown)
				canvas.DrawImage(w.im,x,y,0,1,1)
			Next
			Next
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

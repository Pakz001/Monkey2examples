'What it does is rndomly find a pos on the map (thousand times per second)
'if that map pos is water then see if you can move it down
'see if it can move left
' see if it can move right
'see if it can move left down
' replace the old position with no water and the place where to go with water value

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class map
	Field map:= New Int[50,50] 

	Method New()
		For Local y:=22 Until 50
		For Local x:=0 Until 50
			map[x,y] = 1
		Next
		Next
		For Local y:=0 Until 50
			map[0,y] = 1
			map[49,y] = 1
		Next
		makewater(20,15,10,10)
	End Method 
	Method update()
		If Mouse.ButtonDown(MouseButton.Left)
			Local x:Int= Mouse.X/16
			Local y:Int = Mouse.Y/16
			If x>0 And x<50 And y>0 And y<50 
				map[x,y] = 2
			End If
		End If
		If Mouse.ButtonDown(MouseButton.Right)
			Local x:Int= Mouse.X/16
			Local y:Int = Mouse.Y/16
			If x>0 And x<50 And y>0 And y<50 
				map[x,y] = 1
			End If
		End If
		If Mouse.ButtonDown(MouseButton.Middle)
			Local x:Int= Mouse.X/16
			Local y:Int = Mouse.Y/16
			If x>0 And x<50 And y>0 And y<50 
				map[x,y] = 0
			End If
		End If

		For Local i := 0 Until 800
		updatewater(Rnd()*49,Rnd()*49)
		Next
	End Method 
	Method updatewater(x:Int,y:Int)
		If map[x,y] = 2 Then
		If x-1>0 And x+1 < 50 And y-1>0 And y+1 <50
			Select Round(Rnd(0,3))
			Case 0
			If map[x-1,y] = 0
			If map[x+1,y] = 2
				map[x-1,y] = 2
				map[x,y] = 0				
			End If
			Endif
			Case 1
			If map[x-1,y] = 2
			If map[x+1,y] = 0
				map[x+1,y] = 2
				map[x,y] = 0				
			End If
			End If
			Case 2
			If map[x,y+1] = 0
				map[x,y+1] = 2
				map[x,y] = 0
			End If				
			Case 3
			If map[x-1,y] = 0
			If map[x-1,y+1] = 0
			If map[x,y+1] = 2
				map[x,y] = 0
				map[x-1,y+1] = 2
			End If	
			End If 
			End If 
			End Select
		End If
		End If
	End Method 
	Method makewater(x:Int,y:Int,w:Int,h:Int)
		For Local y1:=y Until y+h
		For Local x1:=x Until x+w
			map[x1,y1] = 2
		Next
		Next
	End Method
	Method draw(canvas:Canvas)
		For Local y:=0 Until 50
		For Local x:=0 Until 50
			If map[x,y] = 0
				canvas.Color = Color.Black
				canvas.DrawRect(x*16,y*16,16,16)
			End If 
			If map[x,y] = 1
				canvas.Color = Color.Grey
				canvas.DrawRect(x*16,y*16,16,16)
			End If 
			If map[x,y] = 2
				canvas.Color = Color.Blue
				canvas.DrawRect(x*16,y*16,16,16)
			End If 
		Next
		Next
	End Method 
End Class 

Global mymap:map

Class MyWindow Extends Window

	Method New()
		mymap = New map()
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		mymap.update()
		mymap.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

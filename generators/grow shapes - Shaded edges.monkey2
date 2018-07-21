#Import "<std>"
#Import "<mojo>"


'
' Create rocks or shapes with shaded edges.
' This is done by taking the angle from the center of the shape to
' the edge and turning this into a light or dark color. 
'

Using std..
Using mojo..


Class MyWindow Extends Window
	Field im:Image[,]
	Field can:Canvas[,]
	Method New()
		im = New Image[10,10]
		can = New Canvas[10,10]
		For Local y:Int=0 Until 7
		For Local x:Int=0 Until 9		
			createblob(x,y)
		Next
		Next		
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		For Local y:Int=0 Until 7
		For Local x:Int=0 Until 9
		canvas.DrawImage(im[x,y],x*64,y*64,0,2,2)
		Next
		Next
		canvas.DrawImage(im[0,0],320-32*4,240-32*4,0,4,4)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	Method createblob(a:Int,b:Int)
		im[a,b] = New Image(64,64)
		im[a,b].Handle = New Vec2f(0,0)
		can[a,b] = New Canvas(im[a,b])
		can[a,b].Clear(New Color(0,0,0,0))
		Local tmp:Int[,] = New Int[im[a,b].Width,im[a,b].Height]
		tmp[im[a,b].Width/2,im[a,b].Height/2] = 1
		For Local i:Int=0 Until (im[a,b].Width*im[a,b].Height)*10
			Local x:Int=Rnd(1,im[a,b].Width-2)
			Local y:Int=Rnd(1,im[a,b].Height-2)
			If tmp[x,y] = 1 Then tmp[x+Rnd(-1,2),y+Rnd(-1,2)] = 1
		Next
		' Create light and dark edges
		For Local y:Int=1 Until im[a,b].Height-1
		For Local x:Int=1 Until im[a,b].Width-1
			If tmp[x,y] = 0
				For Local y2:Int=y-1 To y+1
				For Local x2:Int=x-1 To x+1
					If tmp[x2,y2] = 1
						Local angle:Float=getangle(x,y,im[a,b].Width/2,im[a,b].Height/2)
						If angle>0 And angle<Pi 
							tmp[x2,y2] = 2
						Else
							tmp[x2,y2] = 3
						End If						
					End If
				Next
				Next
			End If		
		Next
		Next
		'
		can[a,b].Color = Color.Grey
		For Local y:Int=0 Until im[a,b].Height
		For Local x:Int=0 Until im[a,b].Width
			If tmp[x,y] = 0 Then Continue
			Select tmp[x,y]
				Case 1
				can[a,b].Color = Color.Grey
				Case 2
				can[a,b].Color = Color.LightGrey
				Case 3
				can[a,b].Color = Color.DarkGrey
			End Select
			can[a,b].DrawRect(x,y,1,1)
		Next
		Next
		can[a,b].Flush()
	End Method
	Function getangle:float(x1:Int,y1:Int,x2:Int,y2:Int)
		Return ATan2(y2-y1, x2-x1)
	End Function 	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

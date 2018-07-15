#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global w:Int=40
Global h:Int=40

Class MyWindow Extends Window
	Field ex1:Int[,]
	Field ex2:Int[,]
	Method New()
		reset()
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		If Keyboard.KeyDown(Key.Key1) 
			For Local i:Int=0 Until 50
				ex1 = grow(ex1)
				ex2 = grow(ex2)
			Next
		End If
		
		'
		draw(canvas,ex1,50,50,5,5)
		draw(canvas,ex2,370,50,5,5)
		
		canvas.DrawText("Press '1' - to grow arrays.",0,0)
		canvas.DrawText("Press 'c' - to clear arrays.",0,10)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
		If Keyboard.KeyReleased(Key.C) Then reset()
	End Method	
	Method grow:Int[,](ar:Int[,])
		
		Local ret:Int[,] = New Int[ar.GetSize(0),ar.GetSize(1)]
		For Local y2:Int=0 Until ar.GetSize(1)
		For Local x2:Int=0 Until ar.GetSize(0)
			ret[x2,y2] = ar[x2,y2]
		Next
		Next
		Local y:Int
		Local x:Int
		While (x<1 Or y<1 Or x>=w-1 Or y>=h-1)
			x = Rnd(w)
			y = Rnd(h)
			If x<1 Or y<1 Or x>=w-1 Or y>=h-1 Then Continue
			If ar[x,y] = 1				
				ret[x+Rnd(-1,2),y+Rnd(-1,2)] = 1								
			End If
		Wend
		Return ret
	End Method
	Method draw(canvas:Canvas,ar:Int[,],x:Int,y:Int,tw:Int,th:Int)
		canvas.Color = Color.White
		For Local y2:Int = 0 Until ar.GetSize(1)
		For Local x2:Int = 0 Until ar.GetSize(0)
			If ar[x2,y2] = 1 Then 
				canvas.DrawRect(x+x2*tw,y+y2*th,tw,th)
			End If
		Next
		Next		
	End Method
	Method reset()
		ex1 = New Int[w,h]
		ex2 = New Int[w,h]
		
		ex1[10,10] = 1
		For Local n:Int=0 Until 15
			ex2[20+n,10+n] = 1
			ex2[19+n,10+n] = 1
			ex2[20-n,10+n] = 1
			ex2[19-n,10+n] = 1
		Next
	End Method	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

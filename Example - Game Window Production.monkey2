#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..
' City current production window. 

'
' These are the variables for the city production window.
' x and y and w and height and the 
' current amount and required amount of resources
'
Global prodx:Int
Global prody:Int
Global prodw:Int
Global prodh:Int
Global prodcurrentresourcescount:Int
Global prodrequiredresourcescount:Int


Class MyWindow Extends Window

	Method New()
		' Set up the window variables
		prodx = 100
		prody = 100
		prodw = 150
		prodh = 200
		prodcurrentresourcescount = 4
		prodrequiredresourcescount = 7

	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		'
		canvas.DrawText("Press Space or Press Left Mouse for Random production.",0,0)
		' Run the function that draws the city build
		' overview window.
		drawproductionwindow(canvas)
		' If we press the space bar then make the build resources
		' variable a random number
		If Keyboard.KeyReleased(Key.Space) Or Mouse.ButtonReleased(MouseButton.Left) Then 
			If Rnd(2)<1 ' once in a while
				prodrequiredresourcescount = Rnd(30)
				prodcurrentresourcescount = Rnd(0,prodrequiredresourcescount)
				

			Else 'every other once in a while
				prodrequiredresourcescount = Rnd(330)
				prodcurrentresourcescount = Rnd(0,prodrequiredresourcescount)
				
			End If		 			 	
		End If
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

' Based on the Civilization 1 city build
' production window
'
Function drawproductionwindow(canvas:Canvas)
	'draw the white outline
	canvas.Color = Color.White
	canvas.DrawRect(prodx-2,prody-2,prodw+4,prodh+4)
	'Draw the black screen
	canvas.Color = Color.Black
	canvas.DrawRect(prodx,prody,prodw,prodh)
	' Draw a title label
	canvas.Color = Color.White
	canvas.DrawText("Currently creating : ",prodx,prody-15)
	' Count how much space we must have between the resources
	' images.
	Local mx:Float=16,my:Float=16
	Local exitloop:Bool=False
	While exitloop = False
		If ( (Float(prodw-16)/my) * (Float(prodh-8)/my )) > prodrequiredresourcescount
		exitloop = True
		Else
		mx -= .1
		my -= .1
		End If
	Wend
	
	'Drawing function(draw the resource)
	Local mydrawresource := Lambda:Void(x:Int,y:Int)
		' Draw the resource image
		canvas.Color = Color.Grey
		canvas.DrawCircle(x,y,8)		
		canvas.Color = New Color(.2,.2,.2)
		canvas.DrawCircle(x,y,7)
		canvas.Color = New Color(.7,.7,.7)
		canvas.DrawCircle(x,y,6)				
		canvas.Color = Color.White
		canvas.DrawCircle(x-1,y-1,2)				
	End Lambda
	
	' Draw the food images 
	Local x:Float,y:Float
	Local count:Int
	Repeat
		' Draw the resources images
		mydrawresource(prodx+x+8,prody+y+8)
		' Left top down
		x+=mx
		count+=1
		If count>prodcurrentresourcescount Then Exit
		' if we are at the bottom then
		' increase x and reset y
		If x > Float(prodw-16) Then
			y += my
			x = 0
			' If the screen if filled then exit
			If y > Float(prodh-16) Then 
				Exit
			End If
		End If
	Forever
	
End Function

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

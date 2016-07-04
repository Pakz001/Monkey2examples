#Import "<std>"
#Import "<mojo>"
 
Using std..
Using mojo..
 
Class MyWindow Extends Window
 
	Method OnRender( canvas:Canvas ) Override
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()
		App.RequestRender()	   	
	   	' create a pixmap
	   	Local pixmap:=New Pixmap(640, 480)
	   	' clear the pixmap
	   	pixmap.Clear(New Color(Rnd(0,1),Rnd(0,1),Rnd(0,1),1))
	   	'create a image with from the pixmap
	   	Local img:=New Image(pixmap)
	   	' draw the image
	   	canvas.DrawImage(img,0,0)
	   	canvas.Color = Color.Black
	   	canvas.DrawRect(0,0,320,20)
	   	canvas.Color = Color.White
	   	canvas.DrawText("FPS:"+App.FPS,0,0)
	End Method
	
End Class
 
Function Main()
 
	New AppInstance
	
	New MyWindow
	
	App.Run()
End Function

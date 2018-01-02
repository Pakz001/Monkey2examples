' Fire Power Remake Project (Based on the Amiga Game from 1987)

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global tilewidth:Int=64
Global tileheight:Int=64

Class tile
	Field sand1im:Image
	Field sand1can:Canvas
	Field sandshadowtopim:Image
	Field sandshadowtopcan:Canvas
	Field sandshadowleftim:Image
	Field sandshadowleftcan:Canvas
	Field sandshadowrightim:Image
	Field sandshadowrightcan:Canvas
	Field sandshadowbottomim:Image
	Field sandshadowbottomcan:Canvas

	Method New()
		sand1im = New Image(tilewidth,tileheight)
		sand1can = New Canvas(sand1im)
		makesand1(sand1can)		
		sandshadowtopim = New Image(tilewidth,tileheight)
		sandshadowtopcan = New Canvas(sandshadowtopim)
		makesandshadowtop(sandshadowtopcan)
		sandshadowleftim = New Image(tilewidth,tileheight)
		sandshadowleftcan = New Canvas(sandshadowleftim)
		makesandshadowleft(sandshadowleftcan)
		sandshadowrightim = New Image(tilewidth,tileheight)
		sandshadowrightcan = New Canvas(sandshadowrightim)
		makesandshadowright(sandshadowrightcan)
		sandshadowbottomim = New Image(tilewidth,tileheight)
		sandshadowbottomcan = New Canvas(sandshadowbottomim)
		makesandshadowbottom(sandshadowbottomcan)

	End Method
	Method makesand1(canvas:Canvas)
		canvas.Color = Color.White
		' background color
		canvas.Clear(Color.Yellow.Blend(Color.Red,.3))
		' Noise
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(tileheight)
			canvas.Color = Color.Yellow.Blend(Color.Black,Rnd(0.3,0.5))
			canvas.DrawPoint(x,y)
		Next
		canvas.Flush()
	End Method
	Method makesandshadowtop(canvas:Canvas)
		' make standard sand tile
		makesand1(canvas)
		' add noise top top
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(Rnd(tileheight/4))
			canvas.Color = Color.Yellow.Blend(Color.Black,Rnd(0.3,0.5))
			canvas.DrawPoint(x,y)
		Next		
		canvas.Flush()
	End Method
	Method makesandshadowleft(canvas:Canvas)
		' make standard sand tile
		makesand1(canvas)
		' add noise left
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=Rnd(Rnd(tilewidth/4))
			Local y:Int=Rnd(tileheight)
			canvas.Color = Color.Yellow.Blend(Color.Black,Rnd(0.3,0.5))
			canvas.DrawPoint(x,y)
		Next		
		canvas.Flush()
	End Method
	Method makesandshadowright(canvas:Canvas)
		' make standard sand tile
		makesand1(canvas)
		' add noise right
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=tilewidth-Rnd(Rnd(tilewidth/4))
			Local y:Int=Rnd(tileheight)
			canvas.Color = Color.Yellow.Blend(Color.Black,Rnd(0.3,0.5))
			canvas.DrawPoint(x,y)
		Next		
		canvas.Flush()
	End Method
	Method makesandshadowbottom(canvas:Canvas)
		' make standard sand tile
		makesand1(canvas)
		' add noise bottom
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=Rnd(tilewidth)
			Local y:Int=tileheight-Rnd(tileheight/4)
			canvas.Color = Color.Yellow.Blend(Color.Black,Rnd(0.3,0.5))
			canvas.DrawPoint(x,y)
		Next		
		canvas.Flush()
	End Method


	Method drawsand1(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(sand1im,x,y)
	End Method
	Method drawsandshadowtop(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(sandshadowtopim,x,y)
	End Method
	Method drawsandshadowleft(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(sandshadowleftim,x,y)
	End Method
	Method drawsandshadowright(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(sandshadowrightim,x,y)
	End Method
	Method drawsandshadowbottom(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(sandshadowbottomim,x,y)
	End Method

End Class

Global mytile:tile

Class MyWindow Extends Window

	Method New()
		mytile = New tile()
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		
		mytile.drawsand1(canvas,100,100)
		mytile.drawsandshadowtop(canvas,100,100-64)
		mytile.drawsandshadowleft(canvas,100-64,100)
		mytile.drawsandshadowright(canvas,100+64,100)
		mytile.drawsandshadowbottom(canvas,100,100+64)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

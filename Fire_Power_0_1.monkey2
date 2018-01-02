' Fire Power Remake Project (Based on the Amiga Game from 1987)

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global tilewidth:Int=64
Global tileheight:Int=64

Class tile
	'Sand (desert) tiles
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
	'Road tiles
	Field roadhorim:Image
	Field roadhorcan:Canvas
	Field roadverim:Image
	Field roadvercan:Canvas
	Field roadtopleftim:Image
	Field roadtopleftcan:Canvas
	Method New()
		' Create sand tiles
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
		' Create road tiles
		roadhorim = New Image(tilewidth,tileheight)
		roadhorcan = New Canvas(roadhorim)
		makeroadhor(roadhorcan)
		roadtopleftim = New Image(tilewidth,tileheight)
		roadtopleftcan = New Canvas(roadtopleftim)
		makeroadtopleft(roadtopleftcan)
		roadverim = New Image(tilewidth,tileheight)
		roadvercan = New Canvas(roadverim)
		makeroadver(roadvercan)

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
	' road section
	Method makeroadhor(canvas:Canvas)
		canvas.Clear(Color.Grey)
		'road noise
		For Local i:Int=0 Until tilewidth*tileheight/40
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(tileheight)
			canvas.Color = Color.Grey.Blend(Color.White,Rnd(1))
			canvas.DrawPoint(x,y)
		Next
		'road top side
		canvas.Color = Color.Grey.Blend(Color.White,.2)
		canvas.DrawRect(0,0,tilewidth,tileheight/24)
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(0,tileheight/24,tilewidth,tileheight/24)
		'road bottom side
		canvas.Color = Color.Grey.Blend(Color.White,.2)				
		canvas.DrawRect(0,tileheight-(tileheight/12),tilewidth,tileheight/24)
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(0,tileheight-tileheight/24,tilewidth,tileheight/24)
		
		canvas.Flush()
	End Method
	Method makeroadtopleft(canvas:Canvas)
		canvas.Clear(Color.Grey)
		'road noise
		For Local i:Int=0 Until tilewidth*tileheight/40
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(tileheight)
			canvas.Color = Color.Grey.Blend(Color.White,Rnd(1))
			canvas.DrawPoint(x,y)
		Next
		'road right side
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(tilewidth-tilewidth/12,0,tilewidth/24,tileheight)
		canvas.Color = Color.Grey.Blend(Color.White,.2)
		canvas.DrawRect(tilewidth-tilewidth/24,0,tilewidth/24,tileheight)
		'road bottom side
		canvas.Color = Color.Grey.Blend(Color.White,.2)				
		canvas.DrawRect(0,tileheight-(tileheight/12),tilewidth,tileheight/24)
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(0,tileheight-tileheight/24,tilewidth,tileheight/24)
		
		canvas.Flush()		
	End Method
	Method makeroadver(canvas:Canvas)
		canvas.Clear(Color.Grey)
		'road noise
		For Local i:Int=0 Until tilewidth*tileheight/40
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(tileheight)
			canvas.Color = Color.Grey.Blend(Color.White,Rnd(1))
			canvas.DrawPoint(x,y)
		Next
		'road right side
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(tilewidth-tilewidth/12,0,tilewidth/24,tileheight)
		canvas.Color = Color.Grey.Blend(Color.White,.2)
		canvas.DrawRect(tilewidth-tilewidth/24,0,tilewidth/24,tileheight)
		'road left side
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(0,0,tilewidth/24,tileheight)
		canvas.Color = Color.Grey.Blend(Color.White,.2)
		canvas.DrawRect(tilewidth/24,0,tilewidth/24,tileheight)

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
	Method drawroadhor(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(roadhorim,x,y)
	End Method
	Method drawroadtopleft(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(roadtopleftim,x,y)
	End Method
	Method drawroadver(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(roadverim,x,y)
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
		
		mytile.drawroadhor(canvas,400,100)
		mytile.drawroadtopleft(canvas,400+64,100)
		mytile.drawroadver(canvas,400+64,100-64)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

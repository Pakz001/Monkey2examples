' Fire Power Remake Project (Based on the Amiga Game from 1987)

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global tilewidth:Int=48
Global tileheight:Int=48

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
	Field sandshadowbottomleftim:Image
	Field sandshadowbottomleftcan:Canvas
	Field sandshadowbottomrightim:Image
	Field sandshadowbottomrightcan:Canvas
	Field sandshadowtopleftim:Image
	Field sandshadowtopleftcan:Canvas
	Field sandshadowtoprightim:Image
	Field sandshadowtoprightcan:Canvas
	'Road tiles
	Field roadhorim:Image
	Field roadhorcan:Canvas
	Field roadverim:Image
	Field roadvercan:Canvas
	Field roadtopleftim:Image
	Field roadtopleftcan:Canvas
	Field roadbottomrightim:Image
	Field roadbottomrightcan:Canvas
	Field roadtoprightim:Image
	Field roadtoprightcan:Canvas
	Field roadbottomleftim:Image
	Field roadbottomleftcan:Canvas
	Field roadbottomleftrightim:Image
	Field roadbottomleftrightcan:Canvas
	Field roadbottomtoprightim:Image
	Field roadbottomtoprightcan:Canvas
	Field roadbottomtopleftim:Image
	Field roadbottomtopleftcan:Canvas
	Field roadtopleftrightim:Image
	Field roadtopleftrightcan:Canvas
	Field roadbottomtopleftrightim:Image
	Field roadbottomtopleftrightcan:Canvas
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

		sandshadowbottomleftim = New Image(tilewidth,tileheight)
		sandshadowbottomleftcan = New Canvas(sandshadowbottomleftim)
		makesandshadowbottomleft(sandshadowbottomleftcan)
		sandshadowbottomrightim = New Image(tilewidth,tileheight)
		sandshadowbottomrightcan = New Canvas(sandshadowbottomrightim)
		makesandshadowbottomright(sandshadowbottomrightcan)

		sandshadowtopleftim = New Image(tilewidth,tileheight)
		sandshadowtopleftcan = New Canvas(sandshadowtopleftim)
		makesandshadowtopleft(sandshadowtopleftcan)
		sandshadowtoprightim = New Image(tilewidth,tileheight)
		sandshadowtoprightcan = New Canvas(sandshadowtoprightim)
		makesandshadowtopright(sandshadowtoprightcan)


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
		roadbottomrightim = New Image(tilewidth,tileheight)
		roadbottomrightcan = New Canvas(roadbottomrightim)
		makeroadbottomright(roadbottomrightcan)
		roadtoprightim = New Image(tilewidth,tileheight)
		roadtoprightcan = New Canvas(roadtoprightim)
		makeroadtopright(roadtoprightcan)
		roadbottomleftim = New Image(tilewidth,tileheight)
		roadbottomleftcan = New Canvas(roadbottomleftim)
		makeroadbottomleft(roadbottomleftcan)
		roadbottomleftrightim = New Image(tilewidth,tileheight)
		roadbottomleftrightcan = New Canvas(roadbottomleftrightim)
		makeroadbottomleftright(roadbottomleftrightcan)
		roadbottomtoprightim = New Image(tilewidth,tileheight)
		roadbottomtoprightcan = New Canvas(roadbottomtoprightim)
		makeroadbottomtopright(roadbottomtoprightcan)
		roadbottomtopleftim = New Image(tilewidth,tileheight)
		roadbottomtopleftcan = New Canvas(roadbottomtopleftim)
		makeroadbottomtopleft(roadbottomtopleftcan)
		roadtopleftrightim = New Image(tilewidth,tileheight)
		roadtopleftrightcan = New Canvas(roadtopleftrightim)
		makeroadtopleftright(roadtopleftrightcan)
		roadbottomtopleftrightim = New Image(tilewidth,tileheight)
		roadbottomtopleftrightcan = New Canvas(roadbottomtopleftrightim)
		makeroadbottomtopleftright(roadbottomtopleftrightcan)


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
	Method makesandshadowbottomleft(canvas:Canvas)
		' make standard sand tile
		makesand1(canvas)
		' add noise bottom
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=Rnd(tilewidth)
			Local y:Int=tileheight-Rnd(tileheight/4)
			canvas.Color = Color.Yellow.Blend(Color.Black,Rnd(0.3,0.5))
			canvas.DrawPoint(x,y)
		Next		
		' add noise left
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=Rnd(Rnd(tilewidth/4))
			Local y:Int=Rnd(tileheight-tileheight/4)
			canvas.Color = Color.Yellow.Blend(Color.Black,Rnd(0.3,0.5))
			canvas.DrawPoint(x,y)
		Next		

		canvas.Flush()
	End Method

	Method makesandshadowbottomright(canvas:Canvas)
		' make standard sand tile
		makesand1(canvas)
		' add noise bottom
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=Rnd(tilewidth)
			Local y:Int=tileheight-Rnd(tileheight/4)
			canvas.Color = Color.Yellow.Blend(Color.Black,Rnd(0.3,0.5))
			canvas.DrawPoint(x,y)
		Next		
		' add noise right
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=tilewidth-Rnd(Rnd(tilewidth/4))
			Local y:Int=Rnd(tileheight-tileheight/4)
			canvas.Color = Color.Yellow.Blend(Color.Black,Rnd(0.3,0.5))
			canvas.DrawPoint(x,y)
		Next		

		canvas.Flush()
	End Method

	Method makesandshadowtopleft(canvas:Canvas)
		' make standard sand tile
		makesand1(canvas)
		' add noise top top
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(Rnd(tileheight/4))
			canvas.Color = Color.Yellow.Blend(Color.Black,Rnd(0.3,0.5))
			canvas.DrawPoint(x,y)
		Next		

		' add noise left
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=Rnd(Rnd(tilewidth/4))
			Local y:Int=Rnd(tileheight/4,tileheight)
			canvas.Color = Color.Yellow.Blend(Color.Black,Rnd(0.3,0.5))
			canvas.DrawPoint(x,y)
		Next		

		canvas.Flush()
	End Method

	Method makesandshadowtopright(canvas:Canvas)
		' make standard sand tile
		makesand1(canvas)
		' add noise top top
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(Rnd(tileheight/4))
			canvas.Color = Color.Yellow.Blend(Color.Black,Rnd(0.3,0.5))
			canvas.DrawPoint(x,y)
		Next		
		' add noise right
		For Local i:Int=0 Until tilewidth*tileheight/10
			Local x:Int=tilewidth-Rnd(Rnd(tilewidth/4))
			Local y:Int=Rnd(tileheight/4,tileheight)
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

	Method makeroadbottomright(canvas:Canvas)
		canvas.Clear(Color.Grey)
		'road noise
		For Local i:Int=0 Until tilewidth*tileheight/40
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(tileheight)
			canvas.Color = Color.Grey.Blend(Color.White,Rnd(1))
			canvas.DrawPoint(x,y)
		Next
		'road left side
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(0,0,tilewidth/24,tileheight)
		canvas.Color = Color.Grey.Blend(Color.White,.2)
		canvas.DrawRect(tilewidth/24,0,tilewidth/24,tileheight)
		'road top side
		canvas.Color = Color.Grey.Blend(Color.White,.2)				
		canvas.DrawRect(0,0,tilewidth,tileheight/24)
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(0,tileheight/24,tilewidth,tileheight/24)
		
		canvas.Flush()		
	End Method
	Method makeroadtopright(canvas:Canvas)
		canvas.Clear(Color.Grey)
		'road noise
		For Local i:Int=0 Until tilewidth*tileheight/40
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(tileheight)
			canvas.Color = Color.Grey.Blend(Color.White,Rnd(1))
			canvas.DrawPoint(x,y)
		Next
		'road left side
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(0,0,tilewidth/24,tileheight)
		canvas.Color = Color.Grey.Blend(Color.White,.2)
		canvas.DrawRect(tilewidth/24,0,tilewidth/24,tileheight)
		'road bottom side
		canvas.Color = Color.Grey.Blend(Color.White,.2)				
		canvas.DrawRect(0,tileheight-(tileheight/12),tilewidth,tileheight/24)
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(0,tileheight-tileheight/24,tilewidth,tileheight/24)
		
		canvas.Flush()		
	End Method
	Method makeroadbottomleft(canvas:Canvas)
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
		'road top side
		canvas.Color = Color.Grey.Blend(Color.White,.2)				
		canvas.DrawRect(0,0,tilewidth,tileheight/24)
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(0,tileheight/24,tilewidth,tileheight/24)
		
		canvas.Flush()		
	End Method
	Method makeroadbottomleftright(canvas:Canvas)
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
		
		canvas.Flush()		
	End Method
	Method makeroadbottomtopright(canvas:Canvas)
		canvas.Clear(Color.Grey)
		'road noise
		For Local i:Int=0 Until tilewidth*tileheight/40
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(tileheight)
			canvas.Color = Color.Grey.Blend(Color.White,Rnd(1))
			canvas.DrawPoint(x,y)
		Next
		'road left side
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(0,0,tilewidth/24,tileheight)
		canvas.Color = Color.Grey.Blend(Color.White,.2)
		canvas.DrawRect(tilewidth/24,0,tilewidth/24,tileheight)
		
		canvas.Flush()		
	End Method
	Method makeroadbottomtopleft(canvas:Canvas)
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
		
		canvas.Flush()		
	End Method
	Method makeroadtopleftright(canvas:Canvas)
		canvas.Clear(Color.Grey)
		'road noise
		For Local i:Int=0 Until tilewidth*tileheight/40
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(tileheight)
			canvas.Color = Color.Grey.Blend(Color.White,Rnd(1))
			canvas.DrawPoint(x,y)
		Next
		'road bottom side
		canvas.Color = Color.Grey.Blend(Color.White,.2)				
		canvas.DrawRect(0,tileheight-(tileheight/12),tilewidth,tileheight/24)
		canvas.Color = Color.Grey.Blend(Color.Black,.8)
		canvas.DrawRect(0,tileheight-tileheight/24,tilewidth,tileheight/24)
		
		canvas.Flush()		
	End Method
	Method makeroadbottomtopleftright(canvas:Canvas)
		canvas.Clear(Color.Grey)
		'road noise
		For Local i:Int=0 Until tilewidth*tileheight/40
			Local x:Int=Rnd(tilewidth)
			Local y:Int=Rnd(tileheight)
			canvas.Color = Color.Grey.Blend(Color.White,Rnd(1))
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
	Method drawsandshadowbottomleft(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(sandshadowbottomleftim,x,y)		
	End Method
	Method drawsandshadowbottomright(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(sandshadowbottomrightim,x,y)		
	End Method
	Method drawsandshadowtopleft(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(sandshadowtopleftim,x,y)		
	End Method
	Method drawsandshadowtopright(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(sandshadowtoprightim,x,y)		
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
	Method drawroadbottomright(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(roadbottomrightim,x,y)
	End Method
	Method drawroadtopright(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(roadtoprightim,x,y)
	End Method
	Method drawroadbottomleft(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(roadbottomleftim,x,y)
	End Method
	Method drawroadbottomleftright(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(roadbottomleftrightim,x,y)
	End Method
	Method drawroadbottomtopright(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(roadbottomtoprightim,x,y)
	End Method
	Method drawroadbottomtopleft(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(roadbottomtopleftim,x,y)
	End Method
	Method drawroadtopleftright(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(roadtopleftrightim,x,y)
	End Method
	Method drawroadbottomtopleftright(canvas:Canvas,x:Int,y:Int)
		canvas.DrawImage(roadbottomtopleftrightim,x,y)
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
		
		mytile.drawsandshadowbottomleft(canvas,100-64,100+64)
		mytile.drawsandshadowbottomright(canvas,100+64,100+64)
		mytile.drawsandshadowtopleft(canvas,100-64,100-64)
		mytile.drawsandshadowtopright(canvas,100+64,100-64)

		
		mytile.drawroadhor(canvas,400,200)
		mytile.drawroadtopleft(canvas,400+64,200)
		mytile.drawroadver(canvas,400+64,200-64)
		mytile.drawroadbottomright(canvas,400-64,200)
		mytile.drawroadver(canvas,400-64,200+64)
		mytile.drawroadtopright(canvas,400-64,200+128)
		mytile.drawroadbottomleft(canvas,400+64,200-128)
		mytile.drawroadbottomtopleftright(canvas,100,400)
		mytile.drawroadbottomleftright(canvas,200,400)
		mytile.drawroadbottomtopright(canvas,200+64,400)
		mytile.drawroadbottomtopleft(canvas,200+128,400)
		mytile.drawroadtopleftright(canvas,200+256,400)

		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Class spriteeditor
	Field canvasx:Int,canvasy:Int
	Field canvaswidth:Float,canvasheight:Float
	Field gridwidth:Float,gridheight:Float
	Field c64color:Color[]
	Field spritewidth:Int,spriteheight:Int
	Method New()
		inic64colors()
		canvasx = 0
		canvasy = 0
		spritewidth = 8
		spriteheight = 8		
		canvaswidth=320
		canvasheight=240
		gridwidth = canvaswidth/spritewidth		
		gridheight = canvasheight/spriteheight
		
	End Method
	Method drawgrid(canvas:Canvas)
		
		canvas.Color = Color.Grey
		
		For Local y:Int=0 Until spriteheight
		For Local x:Int=0 Until spritewidth
			Local pointx:Int=(x*gridwidth)+canvasx
			Local pointy:Int=(y*gridheight)+canvasy
			canvas.DrawLine(pointx,pointy,pointx+gridwidth,pointy)			
			canvas.DrawLine(pointx,pointy,pointx,pointy+gridheight)
		Next
		Next
	End Method
	Method draw(canvas:Canvas)
		drawgrid(canvas)
	End Method
	Method inic64colors()
		c64color = New Color[16]
		c64color[0 ] = New Color(0  ,0  ,0  )'Black
		c64color[1 ] = New Color(255,255,255)'White
		c64color[2 ] = New Color(136,0  ,0  )'Red
		c64color[3 ] = New Color(170,255,238)'Cyan
		c64color[4 ] = New Color(204,68 ,204)'Violet / Purple
		c64color[5 ] = New Color(0  ,204,85 )'Green
		c64color[6 ] = New Color(0  ,0  ,170)'Blue
		c64color[7 ] = New Color(238,238,119)'Yellow
		c64color[8 ] = New Color(221,136,85 )'Orange
		c64color[9 ] = New Color(102,68 ,0  )'Brown
		c64color[10] = New Color(255,119,119)'Light red
		c64color[11] = New Color(51 ,51 ,51 )'Dark grey / Grey 1
		c64color[12] = New Color(119,119,119)'Grey 2
		c64color[13] = New Color(170,255,102)'Light green
		c64color[14] = New Color(0  ,136,255)'Light blue
		c64color[15] = New Color(187,187,187)'Light grey / grey 3
	End Method

End Class



Class MyWindow Extends Window
	Field myspriteeditor:spriteeditor
	
	Method New()
		myspriteeditor = New spriteeditor()
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		
		myspriteeditor.draw(canvas)
		
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global instance:AppInstance

Class spriteeditor
	' This is a class that holds x and y variables.
	' used for : floodfill
	Class pathnode
		Field x:Int,y:Int
		Method New(x:Int,y:Int)
			Self.x = x
			Self.y = y
		End Method
	End Class
	'tool view
	Field toolx:Int,tooly:Int
	Field toolwidth:Int,toolheight:Int
	Field toolim:Image[]
	Field toolcan:Canvas[]
	Field toolselected:Int=0
	Field toolpencilid:Int=0
	Field tooleraserid:Int=1
	Field toolfillid:Int=2
	Field toollineid:Int=3
	Field numtools:Int
	

	' sprite library
	Field spritelibx:Int,spriteliby:Int
	Field spritelibwidth:Int,spritelibheight:Int
	Field numspritelib:Int
	Field spritelibim:Image[]
	Field spritelibcan:Canvas[]
	Field spritelibmap:Int[,,]
	Field spritelibselected:Int=0
	Field spritelibscale:Float
	
	'preview
	Field previewim:Image
	Field previewcan:Canvas
	Field previewx:Int,previewy:Int
	Field previewwidth:Int,previewheight:Int
	Field previewcellwidth:Int,previewcellheight:Int
	
	'sprite view
	Field map:Int[,]
	Field canvasx:Int,canvasy:Int 'canvas x and y position on the scrern
	Field canvaswidth:Float,canvasheight:Float 'width and height of our canvas
	Field gridwidth:Float,gridheight:Float	 ' grids width and height
	Field spritewidth:Int,spriteheight:Int ' our main sprite width and height
	
	' palette
	
	Field c64color:Color[] ' our colors
	Field paletteselected:Int ' our selected color from palette
	Field paletteeraser:Int
	Field palettex:Int,palettey:Int 'screen x and y
	Field palettewidth:Float,paletteheight:Float ' our palette screen w and h
	Field palettecellwidth:Float,palettecellheight:Float 'cell width and height of color
	Field numpalette:Int 'number of colors
	Method New()
		
		
		
		'palette setup
		inic64colors()
		paletteeraser = 0
		palettex = 640-150
		palettey = 0
		palettewidth = 150
		paletteheight = 150
		numpalette = 16
		palettecellwidth = 32
		palettecellheight = 32		

		'sprite canvas setup
		canvasx = 0
		canvasy = 0
		spritewidth = 8
		spriteheight = 8
		map = New Int[spritewidth,spriteheight]		
		canvaswidth=320
		canvasheight=320
		gridwidth = canvaswidth/spritewidth		
		gridheight = canvasheight/spriteheight

		' tool view
		toolx = 340
		tooly = 200
		toolwidth = 100
		toolheight = 100
		numtools = 8
		toolim = New Image[numtools]
		toolcan = New Canvas[numtools]
		For Local i:Int=0 Until numtools
			toolim[i] = New Image(32,32)
			toolcan[i] = New Canvas(toolim[i])
			toolcan[i].Clear(Color.Black)
			toolcan[i].Flush()
		Next

		setuptoolview()
			
		'spritelib setup
		spritelibx = 0
		spriteliby = canvasheight+32
		spritelibwidth = 640
		spritelibheight = 480
		numspritelib = 32
		spritelibselected = 0
		spritelibscale = 5
		spritelibim = New Image[numspritelib]
		spritelibcan = New Canvas[numspritelib]		
		For Local i:Int=0 Until numspritelib
			spritelibim[i] = New Image(spritewidth*spritelibscale,spriteheight*spritelibscale)
			spritelibcan[i] = New Canvas(spritelibim[i])
			spritelibcan[i].Clear(Color.Black)
			spritelibcan[i].Flush()
		Next	
		spritelibmap = New Int[numspritelib,spritewidth,spriteheight]	
		' previewview setup
		previewx = 640-100
		previewy = 200
		previewcellwidth = 5
		previewcellheight = 5
		previewwidth = spritewidth*previewcellwidth
		previewheight = spriteheight*previewcellheight
		previewim = New Image(previewwidth,previewheight)
		previewcan = New Canvas(previewim)
		updatepreview()
		
	End Method

	Method toolview(canvas:Canvas)
		canvas.Color=Color.Black
		canvas.DrawRect(toolx,tooly,toolwidth,toolheight)
		canvas.Color=Color.White
		'Print toolx+","+tooly
		Local num:Int=0
		For Local x:Int=toolx Until toolx+toolwidth Step 32
			Local pointx:Int=x
			Local pointy:Int=tooly
			If toolselected = num 
				canvas.Color = Color.Yellow
				canvas.DrawRect(pointx,pointy,32,32)
				canvas.Color = Color.White
				canvas.Scissor = New Recti(pointx+2,pointy+2,pointx+30,pointy+30)
				canvas.DrawImage(toolim[num],pointx,pointy)
				canvas.Scissor = New Recti(0,0,640,480)
			Else
				canvas.DrawImage(toolim[num],pointx,pointy)
			End If
			If Mouse.ButtonDown(MouseButton.Left)
				If rectsoverlap(Mouse.X,Mouse.Y,1,1,pointx,pointy,32,32)
					toolselected = num
				End If
			End If				
			num+=1
			If num>=numtools Then Exit
		Next
		
	End Method

	Method setuptoolview()
		'read icons
		Local pencil := New Int[][] (
		New Int[](12,12,12,12,12,12,12,12),
		New Int[](12,1,1,1,1,12,12,12),
		New Int[](12,1,1,1,12,1,12,12),
		New Int[](12,1,1,12,1,1,1,12),
		New Int[](12,1,12,1,1,1,1,1),
		New Int[](12,12,1,1,1,1,1,1),
		New Int[](12,12,12,1,1,1,1,1),
		New Int[](12,12,12,12,1,1,1,1))		
		For Local y:Int=0 Until 8
		For Local x:Int=0 Until 8
			toolcan[toolpencilid].Color = c64color[pencil[y][x]]
			toolcan[toolpencilid].DrawRect(x*4,y*4,4,4)
		Next
		Next
		toolcan[toolpencilid].Flush()
		
		Local eraser := New Int[][] (
		New Int[](12,12,12,12,12,12,12,12),
		New Int[](12,12,12,1,12,12,12,12),
		New Int[](12,12,1,1,1,12,12,12),
		New Int[](12,1,1,12,1,1,12,12),
		New Int[](12,12,1,1,12,1,1,12),
		New Int[](12,12,12,1,1,1,12,12),
		New Int[](12,12,12,12,1,12,12,12),
		New Int[](12,12,12,12,12,12,12,12))
		For Local y:Int=0 Until 8
		For Local x:Int=0 Until 8
			toolcan[tooleraserid].Color = c64color[eraser[y][x]]
			toolcan[tooleraserid].DrawRect(x*4,y*4,4,4)
		Next
		Next
		toolcan[tooleraserid].Flush()

		Local fill := New Int[][] (
		New Int[](12,12,12,1,12,12,12,12),
		New Int[](12,12,1,1,1,12,12,12),
		New Int[](12,1,1,1,1,1,12,12),
		New Int[](1,1,1,1,1,1,1,12),
		New Int[](12,1,1,1,1,1,1,1),
		New Int[](1,12,1,1,1,1,1,12),
		New Int[](12,12,12,1,1,1,12,12),
		New Int[](1,12,12,12,1,12,12,12))
		For Local y:Int=0 Until 8
		For Local x:Int=0 Until 8
			toolcan[toolfillid].Color = c64color[fill[y][x]]
			toolcan[toolfillid].DrawRect(x*4,y*4,4,4)
		Next
		Next
		toolcan[toolfillid].Flush()

		Local line := New Int[][] (
		New Int[](12,12,12,12,12,12,12,12),
		New Int[](12,1,12,12,12,12,12,12),
		New Int[](12,12,1,12,12,12,12,12),
		New Int[](12,12,12,1,12,12,12,12),
		New Int[](12,12,12,12,1,12,12,12),
		New Int[](12,12,12,12,12,1,12,12),
		New Int[](12,12,12,12,12,12,1,12),
		New Int[](12,12,12,12,12,12,12,12))
		For Local y:Int=0 Until 8
		For Local x:Int=0 Until 8
			toolcan[toollineid].Color = c64color[line[y][x]]
			toolcan[toollineid].DrawRect(x*4,y*4,4,4)
		Next
		Next
		toolcan[toollineid].Flush()
		
	End Method

	Method spritelibview(canvas:Canvas)
		canvas.Color = Color.Black
		canvas.DrawRect(spritelibx,spriteliby,spritelibwidth,spritelibheight)
		canvas.Color = Color.White
		Local num:Int=0
		For Local y:Int=spriteliby Until spriteliby+spritelibheight-spriteheight*spritelibscale Step spriteheight*spritelibscale
		For Local x:Int=spritelibx Until spritelibx+spritelibwidth Step spritewidth*spritelibscale
			Local pointx:Int=x
			Local pointy:Int=y

			If num = spritelibselected
				canvas.Color = Color.White
				canvas.DrawRect(pointx,pointy,spritewidth*spritelibscale,spriteheight*spritelibscale)
				canvas.Scissor = New Recti(pointx+2,pointy+2,pointx+spritewidth*spritelibscale-3,pointy+spriteheight*spritelibscale-3)
				'canvas.Scissor(z1)
				canvas.DrawImage(spritelibim[num],pointx,pointy)	
				'Local z2:=New Recti(0,0,640,480)
				canvas.Scissor = New Recti(0,0,640,480)
			Else
				canvas.Color = Color.White
				canvas.DrawImage(spritelibim[num],pointx,pointy)	
				
			End If

			


			
			If Mouse.ButtonDown(MouseButton.Left)
				If rectsoverlap(Mouse.X,Mouse.Y,1,1,pointx,pointy,spritewidth*spritelibscale,spriteheight*spritelibscale)
					spritelibselected = num
					spritelibcopytocanvas()
				End If					
			End If
					
			num+=1
			If num>=numspritelib Then Exit
		Next
			If num>=numspritelib Then Exit
		Next
	End Method

	Method updatespritelib()
		For Local y:Int=0 Until spriteheight
		For Local x:Int=0 Until spritewidth
			Local pointx:Float=x*spritelibscale
			Local pointy:Float=y*spritelibscale
			spritelibcan[spritelibselected].Color = c64color[map[x,y]]
			spritelibcan[spritelibselected].DrawRect(pointx,pointy,spritelibscale,spritelibscale)
			spritelibmap[spritelibselected,x,y] = map[x,y]
		Next
		Next
		spritelibcan[spritelibselected].Flush()
	End Method

	Method spritelibcopytocanvas()
		For Local y:Int=0 Until spriteheight
		For Local x:Int=0 Until spritewidth
			map[x,y] = spritelibmap[spritelibselected,x,y]
		Next
		Next		
	End Method

	Method spriteview(canvas:Canvas)
		
		canvas.Color = Color.Grey
		
		For Local y:Int=0 Until spriteheight
		For Local x:Int=0 Until spritewidth
			Local pointx:Int=(x*gridwidth)+canvasx
			Local pointy:Int=(y*gridheight)+canvasy
			'canvas.DrawRect()
			canvas.Color = c64color[map[x,y]]			
			canvas.DrawRect(pointx,pointy,gridwidth,gridheight)
			
			'
			' Mouse down (LEFT)
			If Mouse.ButtonDown(MouseButton.Left)
				If rectsoverlap(Mouse.X,Mouse.Y,1,1,pointx,pointy,gridwidth,gridheight)=True								
					If toolselected = toolpencilid
						map[x,y] = paletteselected
					End If
					If toolselected = tooleraserid
						map[x,y] = paletteeraser
					End If
					If toolselected = toolfillid
						fillatposition(x,y)
					End If
				End If					
			End If
			
			' Mouse down (MIDDLE)
			If Mouse.ButtonDown(MouseButton.Middle)
				If rectsoverlap(Mouse.X,Mouse.Y,1,1,pointx,pointy,gridwidth,gridheight)
					paletteselected = map[x,y]
				End If
			End if
			' Copy to clipboard
			If Keyboard.KeyReleased(Key.C)
				copytoclipboard()
			End if

		Next
		Next
		updatepreview()
		updatespritelib()
	End Method
	
	Method fillatposition(x:Int,y:Int)
		Local ol:List<pathnode> = New List<pathnode>
	 	' Add the start position on the list
	 	ol.AddLast(New pathnode(x,y))
	 	' set the cloes map at the start position to distance 1
	 	Local colorundermouse:Int=map[x,y]
	 	map[x,y] = paletteselected
	 	
	 	' some helper arrays. We can determine the top,right,and bottom
	 	' and left position cells with these numbers.
	 	Local dx:Int[] = New Int[](0,1,0,-1)
	 	Local dy:Int[] = New Int[](-1,0,1,0)
	 	' While there is contents in the list
	 	While ol.Count() <> 0
		 	
	 		' Get the current location
	 		Local x1:Int=ol.First.x
	 		Local y1:Int=ol.First.y
	 		' Remove the current location from the list
	 		ol.RemoveFirst()
	 		' Get 4 new positions around the current positions
			For Local i:=0 Until 4
				' Set new x and y
				Local nx:Int=x1+dx[i]
				Local ny:Int=y1+dy[i]
				' If the coordinates are inside the map
				If nx>=0 And ny>=0 And nx<spritewidth And ny<spriteheight
					' If the closedmap is not written to yet
		 			If map[nx,ny] = colorundermouse And map[nx,ny] <> paletteselected
		 				' Set the new distance based on the current distance
		 				map[nx,ny] = paletteselected
		 				' Add new position to the list
		 				ol.AddLast(New pathnode(nx,ny))
		 			End If
	 			End If
			Next
	 	Wend
 	 		
	End Method
	
	Method spritegrid(canvas:Canvas)
		
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
	Method paletteview(canvas:Canvas)
		canvas.Color = Color.Grey
		canvas.DrawRect(palettex,palettey,palettewidth,paletteheight)
		Local cc:Int=0
		For Local y:Int=0 Until paletteheight-palettecellheight Step palettecellheight
		For Local x:Int=0 Until palettewidth-palettecellwidth Step palettecellwidth
			If cc>=numpalette Then Exit			
			Local pointx:Float=x+palettex
			Local pointy:Float=y+palettey
			'
			' Draw our color
			canvas.Color = c64color[cc]
			canvas.DrawRect(pointx,pointy,palettecellwidth,palettecellheight)
			'
			' Draw a white bar around the currently selected color
			If paletteselected = cc
				canvas.OutlineMode = OutlineMode.Solid
				canvas.OutlineWidth = 3
				canvas.OutlineColor = Color.Black
				canvas.DrawRect(pointx+2,pointy+2,palettecellwidth-4,palettecellheight-4)
				canvas.OutlineMode = OutlineMode.Solid
				canvas.OutlineWidth = 1
				canvas.OutlineColor = Color.Yellow
				canvas.DrawRect(pointx+2,pointy+2,palettecellwidth-4,palettecellheight-4)	
				canvas.OutlineMode = OutlineMode.None
			End If
			'
			' Select our color
			If Mouse.ButtonDown(MouseButton.Left)				
				If rectsoverlap(Mouse.X,Mouse.Y,1,1,pointx,pointy,palettecellwidth,palettecellheight) = True
					paletteselected = cc
				End If
			End if
			'
			cc+=1			
		Next
		Next
		'canvas.Color = c64color[2]
	End Method
	
	Method updatepreview()			
		previewcan.Clear(Color.Black)	
		For Local y:Int=0 Until map.GetSize(1)
		For Local x:Int=0 Until map.GetSize(0)
			Local pointx:Int=x*previewcellwidth
			Local pointy:Int=y*previewcellheight
			previewcan.Color = c64color[map[x,y]]
			previewcan.DrawRect(pointx,pointy,previewcellwidth,previewcellheight)
		Next
		Next
		previewcan.Flush()
	End Method
	Method previewview(canvas:Canvas)		
		canvas.Color = Color.White
		canvas.DrawRect(previewx,previewy,previewwidth,previewheight)
		canvas.DrawImage(previewim,previewx+1,previewy+1,0,.95,.95)		
	End Method
	
	Method draw(canvas:Canvas)
		spriteview(canvas)
		spritegrid(canvas)
		paletteview(canvas)
		previewview(canvas)
		spritelibview(canvas)
		toolview(canvas)
	End Method
	Method inic64colors()
		c64color = New Color[16]
		c64color[0 ] = New Color(intof(0)  ,intof(0)  ,intof(0)  )'Black
		c64color[1 ] = New Color(intof(255),intof(255),intof(255))'White
		c64color[2 ] = New Color(intof(136),intof(0)  ,intof(0)  )'Red
		c64color[3 ] = New Color(intof(170),intof(255),intof(238))'Cyan
		c64color[4 ] = New Color(intof(204),intof(68) ,intof(204))'Violet / Purple
		c64color[5 ] = New Color(intof(0)  ,intof(204),intof(85) )'Green
		c64color[6 ] = New Color(intof(0)  ,intof(0)  ,intof(170))'Blue
		c64color[7 ] = New Color(intof(238),intof(238),intof(119))'Yellow
		c64color[8 ] = New Color(intof(221),intof(136),intof(85) )'Orange
		c64color[9 ] = New Color(intof(102),intof(68) ,intof(0)  )'Brown
		c64color[10] = New Color(intof(255),intof(119),intof(119))'Light red
		c64color[11] = New Color(intof(51) ,intof(51) ,intof(51) )'Dark grey / Grey 1
		c64color[12] = New Color(intof(119),intof(119),intof(119))'Grey 2
		c64color[13] = New Color(intof(170),intof(255),intof(102))'Light green
		c64color[14] = New Color(intof(0)  ,intof(136),intof(255))'Light blue
		c64color[15] = New Color(intof(187),intof(187),intof(187))'Light grey / grey 3
	End Method
	
	
	
	Function intof:Float(a:Int)
		Return 1.0/255.0*a
	End Function

	Method copytoclipboard()
		Local out:String="Field map := New Int[][] ("+String.FromChar(10)
		For Local y:Int=0 Until spriteheight
			Local a:String
		For Local x:Int=0 Until spritewidth
			a+=map[x,y]+","
		Next
		Local l:Int=a.Length
		a=a.Slice(0,a.Length-1)
		out += "New Int[]("+a+"),"+String.FromChar(10)
		Next
		out=out.Slice(0,out.Length-2)
		out+=")"
		instance.ClipboardText = out
	End Method


End Class



Class MyWindow Extends Window
	Field myspriteeditor:spriteeditor
	
	Method New()
		myspriteeditor = New spriteeditor()
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		canvas.Clear(New Color(0,0,0,1))		
		myspriteeditor.draw(canvas)

		
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
'	New AppInstance		
	instance = New AppInstance
	New MyWindow
	
	App.Run()
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)   	
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End

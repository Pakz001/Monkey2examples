'
' Wave Function Collapse (2d tilemap)
'

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class wfc
	Field mapwidth:Int,mapheight:Int
	Field screenwidth:Int,screenheight:Int
	Field tilewidth:Float,tileheight:Float
	Field map:Int[,]
	Method New(sw:Int,sh:Int)
		map = New Int[5,5]
		map = mapinit()
		mapwidth = map.GetSize(0)
		mapheight = map.GetSize(1)
		screenwidth = sw
		screenheight = sh
		tilewidth = Float(screenwidth)/Float(mapwidth)
		tileheight = Float(screenheight)/Float(mapheight)
	End Method
	Method mapinit:Int[,]()
		Local s:String[] = New String[15]		
		s[0] ="000000000000000"
		s[1] ="000000000000000"
		s[2] ="000000000000000"
		s[3] ="000000000000000"
		s[4] ="000000000000000"
		s[5] ="000074600000000"
		s[6] ="000081500000000"
		s[7] ="000081500000000"
		s[8] ="000081500000000"
		s[9] ="000081500000000"
		s[11]="000081500000000"
		s[12]="007444444446000"
		s[13]="338111111115333"
		s[14]="228111111115222"
		s[15]="441111111111444"
		Local m:Int[,] = New Int[15,15]
		Return m
	End Method
	Method drawmap(canvas:Canvas)
		For Local y:Int=0 Until mapheight
		For Local x:Int=0 Until mapwidth
			Local x1:Int=x*tilewidth
			Local y1:Int=y*tileheight
			Select map[x,y]
				Case 0 'air
					canvas.Color = Color.Blue.Blend(Color.White,.5)
					canvas.DrawRect(x1,y1,tilewidth+1,tileheight+1)
				Case 1 'sand
					canvas.Color = Color.Brown
					canvas.DrawRect(x1,y1,tilewidth+1,tileheight+1)
				Case 2 'water
					canvas.Color = Color.Blue
					canvas.DrawRect(x1,y1,tilewidth+1,tileheight+1)
				Case 3 'water top
					canvas.Color = Color.Blue
					canvas.DrawRect(x1,y1,tilewidth+1,tileheight+1)
					canvas.Color = Color.Blue.Blend(Color.White,.3)
					canvas.DrawRect(x1,y1,tilewidth+1,3)
				Case 4 'sand top
					canvas.Color = Color.Brown
					canvas.DrawRect(x1,y1,tilewidth+1,tileheight+1)
					canvas.Color = Color.Green.Blend(Color.White,.3)
					canvas.DrawRect(x1,y1,tilewidth+1,3)
				Case 5 'sand right
					canvas.Color = Color.Brown
					canvas.DrawRect(x1,y1,tilewidth+1,tileheight+1)
					canvas.Color = Color.Green.Blend(Color.Black,.3)
					canvas.DrawRect(x1+tilewidth-3,y1,3,tileheight+1)
				Case 6 'sand right top
					canvas.Color = Color.Brown
					canvas.DrawRect(x1,y1,tilewidth+1,tileheight+1)
					canvas.Color = Color.Green.Blend(Color.Black,.3)
					canvas.DrawRect(x1,y1,tilewidth+1,3)
					canvas.DrawRect(x1,y1,tilewidth-3,tileheight+1)					
				Case 7 'sand left top
					canvas.Color = Color.Brown
					canvas.DrawRect(x1,y1,tilewidth+1,tileheight+1)
					canvas.Color = Color.Green.Blend(Color.Black,.3)
					canvas.DrawRect(x1,y1,tilewidth+1,3)
					canvas.DrawRect(x1,y1,0,tileheight+1)					
				Case 8 ' sand left
					canvas.Color = Color.Brown
					canvas.DrawRect(x1,y1,tilewidth+1,tileheight+1)
					canvas.Color = Color.Green.Blend(Color.Black,.3)
					canvas.DrawRect(x1,y1,3,tileheight+1)
					
			End Select
		Next
		Next
	End Method
End Class

Global mywfc:wfc

Class MyWindow Extends Window

	Method New()
		mywfc = New wfc(Width,Height)
	End method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		mywfc.drawmap(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

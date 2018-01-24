'Work in progress !!!! Not finished yet!!!!

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Global tilewidth:Int
Global tileheight:Int        

Class player
	' player x and y
	Field px:Float
	Field py:Float
	' player widht and heigth
	Field pw:Int
	Field ph:Int
	' How fast left move and right
	Field horspeed:Int=3
	
	Method New(x:Int,y:Int,w:Int,h:Int)
		px = x
		py = y
		pw = w
		ph = h
	End Method
	' Player controls
	Method controls()
		For Local i:Int=0 Until horspeed
			If Keyboard.KeyDown(Key.Right)
				px += 1
			End If
			If Keyboard.KeyDown(Key.Left)
				px -= 1
			End If
			
		Next
	End Method

	' Draw the player on the screen
	Method draw(canvas:Canvas)
		canvas.Color = Color.Blue
		canvas.DrawRect(px,py,pw,ph)
	End Method
	' Helper function
	Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    	If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    	If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    	Return True
	End Function

End Class

Global myplayer:player

Class MyWindow Extends Window
    Field map := New Int[][] (
        New Int[]( 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ),
        New Int[]( 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
        New Int[]( 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
        New Int[]( 1, 0, 0, 0, 0, 0, 1, 1, 1, 1 ),
        New Int[]( 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
        New Int[]( 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
        New Int[]( 1, 1, 1, 1, 1, 0, 0, 0, 0, 1 ),
        New Int[]( 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
        New Int[]( 1, 1, 1, 1, 1, 0, 0, 0, 0, 1 ),
        New Int[]( 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 ),
        New Int[]( 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ) )	
	Method New()
		' Set The title of the window...
		Title="Tilemap example Array of Arrays....."
		tilewidth = Width/map[0].Length
		tileheight = Height/map.Length
		myplayer = New player(4*tilewidth,4*tileheight,tilewidth/2,tileheight/2)
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		' Clear with black color
		canvas.Clear(Color.Black)
		canvas.Color = Color.White
		For Local y:Int=0 Until map.Length
		For Local x:Int=0 Until map[0].Length
			If map[y][x] = 1				
				canvas.DrawRect(x*tilewidth,y*tileheight,tilewidth,tileheight)
			End If
		Next
		Next		
		myplayer.controls()
		myplayer.draw(canvas)
		
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

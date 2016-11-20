#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class listview
	Field wx:Int,wy:Int,ww:Int,wh:Int
	Field sbx:int,sby:Float
	Field sbw:Int=12
	Field sbh:Int=14
	Field numitems:Int=50
	Field item:= New String[50]
	Field ih:Int 'num of items in window
	Field ipos:Int 
	Method New(x:Int,y:Int,w:Int,h:Int)
		wx = x ; wy = y ; ww = w ; wh = h
		' Scroll bar
		sbx = wx+ww-(sbw+2)
		sby = wy+5
		' items
		ih = (wh-10)/15
		For Local i:=0 Until 50
			item[i] = "Item "+i
		Next
	End Method
	Method update()
		If Keyboard.KeyDown(Key.Down)
			ipos+=1
			If ipos+ih>numitems Then ipos-=1
		Endif
	End Method 
	Method draw(canvas:Canvas)
		window(canvas)
	End Method
	Method window(canvas:Canvas)
		canvas.Color = Color.Grey
		canvas.DrawRect(wx,wy,ww,wh)
		outline(canvas, wx,wy,ww,wh,
						Color.Black,
						Color.Black)
		outline(canvas, wx+1,wy+1,ww-2,wh-2,
						Color.White,
						Color.DarkGrey)
		' Item box
		outline(canvas, wx+5,wy+5,
						ww-20,wh-10,
						Color.Black,
						Color.White)
		outline(canvas, wx+6,wy+6,
						ww-22,wh-12,
						Color.Grey,
						Color.Black)
		canvas.Color = New Color(.2,.2,.2)
		canvas.DrawRect(wx+7,wy+7,ww-24,wh-14)
		' Scroll box
		canvas.Color = New Color(.2,.2,.2)
		canvas.DrawRect(sbx,sby,sbw,wh-11)
		outline(canvas, sbx,sby,sbw,wh-11,
						Color.Black,
						Color.Black)
		' Scrol pull bar
		canvas.Color = New Color(.6,.6,.6)
		canvas.DrawRect(sbx,sby,sbw,sbh)
		outline(canvas,sbx,sby,sbw,sbh,Color.Black,Color.Black)
		drawitems(canvas)
	End Method
	Method drawitems(canvas:Canvas)
		For Local i:=0 Until ih
			canvas.DrawText(    item[i+ipos],
								wx+10,
								(wy+10)+i*15)
		Next
	End Method 
	Method outline(canvas:Canvas,   x:Int,y:Int,
									w:Int,h:Int,
									col1:Color,col2:Color)
		canvas.Color = col1
		canvas.DrawLine(x,y,x+w,y)
		canvas.DrawLine(x,y,x,y+h)
		canvas.Color = col2
		canvas.DrawLine(x+w,y,x+w,y+h)
		canvas.DrawLine(x,y+h,x+w,y+h)
	End Method 
End Class

Global list:listview

Class MyWindow Extends Window

	Method New()
		list = New listview(100,100,200,300)
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		list.update()
		list.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

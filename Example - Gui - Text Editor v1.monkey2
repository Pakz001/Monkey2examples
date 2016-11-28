' if last correction fixed a syntax error then do not show/remove suggestion/codecompletion
#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class texteditor
	Field wx:int,wy:Int,ww:Int,wh:Int
	Field lines:String[]
	Field maxlinewidth:Int=99
	Field maxnumlines:Int=99
	Field currentline:Int=0
	Field cursorposx:Int	
	Method New(x:Int,y:Int,w:Int,h:int)

		wx = x
		wy = y
		ww = w
		wh = h		
		lines = New String[99]
		lines[0] = "Testing..."
		lines[1] = "Line two.."
		cursorposx = lines[0].Length
	End Method 
	Method update()		
		Local a:Int = Keyboard.GetChar()				
		If a>0
			Print "Last keycode : "+ a
			If a = 65743 'cursor right
				Local l1:Int=lines[currentline].Length
				cursorposx+=1
				If cursorposx>l1 Then ' if cursor right and end of text
					currentline += 1
					cursorposx = 0
				End If
				Return
			End If
			If a = 65746 'cursor up
				currentline -= 1
				If currentline<0 Then currentline=0
				Local l1:Int=lines[currentline].Length
				If cursorposx > l1 Then cursorposx=l1
				Return
			End If
			If a = 65744 'cursor left
				cursorposx-=1
				If cursorposx < 0 Then 
					cursorposx = 0				
					If currentline >0 Then currentline-=1
					cursorposx = lines[currentline].Length
				End If
				Return
			End If
			If a = 65745 'cursor down				
				currentline+=1
				Local l1:Int=lines[currentline].Length
				If cursorposx>l1 Then 'if the cursor position of previous line then
								' put cursor at end of shorter next line
					cursorposx = l1
					Return
				Endif
				Return
			End If
			' backspace
			If a=8 And lines[currentline].Length>0 Then 				
				If cursorposx=0 ' if at left of line
				If currentline>0 'copy line(s) into previous line (backspace on begin of line)
					Local aa:String=lines[currentline-1]
					Local bb:String=lines[currentline]
					cursorposx = aa.Length
					lines[currentline-1] = aa+bb
					For Local i:=currentline until maxnumlines-1
						lines[i] = lines[i+1]
					Next
					currentline-=1
				End If 
				Return
				Endif								
				Local l1:Int=lines[currentline].Length
				cursorposx-=1
				If cursorposx+1 = l1 Then ' if at end of line
					lines[currentline] = lines[currentline].Left(l1-1)
					Return
				Endif
				If cursorposx>0 And cursorposx<l1  'If in middle of line
					lines[currentline] = lines[currentline].Left(cursorposx) + lines[currentline].Right(l1-cursorposx-1)				
					Return				
				End If
			End If
			
			Local l1:Int=lines[currentline].Length
			Local aa:String=lines[currentline].Mid(0,cursorposx)
			Local bb:String=lines[currentline].Mid(cursorposx,l1-cursorposx)
			lines[currentline] = aa+String.FromChar(a)+bb
			cursorposx+=1			
		
		End If
	End Method
	Method draw(canvas:Canvas)
		canvas.Color = Color.Black
		canvas.DrawRect(wx,wy,ww,wh)
		outline(canvas,wx+1,wy+1,ww-2,wh-2,Color.White,Color.Grey)
		For Local line:=0 Until 10
			If lines[line] <> ""
				For Local i:=0 Until lines[line].Length
					canvas.DrawText(lines[line].Mid(i,1),wx+(i*10),wy+(line*15))
				next			
			End If
		Next
		canvas.DrawRect(wx+(cursorposx*10),wy+(currentline*15)+12,10,3)
	End Method
	Method outline(canvas:Canvas,x:Int,y:Int,w:Int,h:Int,col1:Color,col2:Color)
		canvas.Color = col1
		canvas.DrawLine(x,y,x+w,y)
		canvas.DrawLine(x,y,x,y+h)
		canvas.Color = col2
		canvas.DrawLine(x,y+h,x+w,y+h)
		canvas.DrawLine(x+w,y,x+w,y+h)
	End Method
End Class

Global mytexteditor:texteditor

Class MyWindow Extends Window

	Method New()
		mytexteditor = New texteditor(100,100,320,150)
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		mytexteditor.update()
		mytexteditor.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

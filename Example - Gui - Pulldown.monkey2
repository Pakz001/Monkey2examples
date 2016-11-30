#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class pulldownmenu
	Class menudata
		Field id:String
		Field item:Stack<String>		
		Method New(id:String)
			Self.id = id
		End Method
	End Class
	Class menu
		Field id:String
		Field title:String
		Method New(id:String,title:String)
			Self.id=id
			Self.title=title
		End Method
	End Class
	Field mymenu:Stack<pulldownmenu.menu> = New Stack<pulldownmenu.menu>
	Method New()
		mymenu.Push(New menu("About","About"))
	End Method
	Method update()
	End Method
	Method draw(canvas:Canvas)
		canvas.Color = Color.White
		Local x:Int=0
		For Local i:=Eachin mymenu
			canvas.DrawText(i.title,x*64,0)
			x+=64
		Next
	End Method
End Class

Global mypulldownmenu:pulldownmenu

Class MyWindow Extends Window

	Method New()
		mypulldownmenu = New pulldownmenu()
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		mypulldownmenu.update()
		mypulldownmenu.draw(canvas)
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

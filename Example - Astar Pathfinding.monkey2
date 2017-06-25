#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Const mapwidth:Int=40
Const mapheight:Int=30
Const tilewidth:Int=16
Const tileheight:Int=16
Global sx:Int 'path start x
Global sy:Int 'path start y
Global ex:Int 'path end x
Global ey:Int 'path end y
'Global map:Int[mapwidth][]
'Global olmap:Int[mapwidth][]
'Global clmap:Int[mapwidth][]

Class pathfinder
	Class openlist
	    Field x:Int
	    Field y:Int
	    Field f:Int
	    Field g:Int
	    Field h:Int
	    Field px:Int
	    Field py:Int
	    Method New(    x:Int=0,y:Int=0,f:Int=0,
	                g:Int=0,h:Int=0,px:Int=0,py:Int=0)
	        Self.x=x
	        Self.y=y
	        Self.f=f
	        Self.g=g
	        Self.h=h
	        Self.px=px
	        Self.py=py
	    End Method
	End Class
	Class closedlist
	    Field x:Int
	    Field y:Int
	    Field px:Int
	    Field py:Int 
	    Method New(x:Int,y:Int,px:Int,py:Int)
	        Self.x = x
	        Self.y = y
	        Self.px = px
	        Self.py = py
	    End Method
	End Class
	Class pathnode
	    Field x:Int
	    Field y:Int
	    Method New(x:Int,y:Int)
	        Self.x = x
	        Self.y = y
	    End Method
	End Class
	Field ol:List<openlist> 
	Field cl:List<closedlist>
	Field path:List<pathnode>
	Method New()
		ol = New List<openlist>
		cl = New List<closedlist>
		path = New List<pathnode>
		
	End Method
End Class

Global mypath:pathfinder

Class MyWindow Extends Window

	Method New()
	End Method
	
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender() ' Activate this method 
		' if key escape then quit
		If Keyboard.KeyReleased(Key.Escape) Then App.Terminate()		
	End Method	
	
End	Class

Function Main()
	New AppInstance		
	New MyWindow
	App.Run()
End Function

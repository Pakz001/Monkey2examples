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
	Field cl:List<closedlist>
	Field path:List<pathnode>
	Field ol:List<openlist>
	Field map:Int[,]
	Field olmap:Int[,]
	Field clmap:Int[,]
	Field mapwidth:Int
	Field mapheight:Int
	Method New()
		
		ol = New List<openlist>
		cl = New List<closedlist>
		path = New List<pathnode>


	map = New Int[mapwidth,mapheight]
	olmap = New Int[mapwidth,mapheight]
	clmap = New Int[mapwidth,mapheight]
		
	End Method

	method findpath:Bool()
	    If sx = ex And sy = ey Then Return False
	    For Local y:=0 Until mapheight
	    For Local x:=0 Until mapwidth
	        olmap[x,y] = 0
	        clmap[x,y] = 0
	    Next
	    Next
	    ol.Clear()
	    cl.Clear()
	    path.Clear()
	    ol.AddFirst(New openlist(sx,sy))
	    Local tx:Int
	    Local ty:Int
	    Local tf:Int
	    Local tg:Int
	    Local th:Int
	    Local tpx:Int
	    Local tpy:Int
	    Local newx:Int
	    Local newy:Int
	    Local lowestf:Int
	    olmap[sx,sy] = 1
	    While ol.Empty = False
	        lowestf = 100000
	        For Local i:=Eachin ol
	            If i.f < lowestf
	                lowestf = i.f
	                tx = i.x
	                ty = i.y
	                tf = i.f
	                tg = i.g
	                th = i.h
	                tpx = i.px
	                tpy = i.py
	            End If
	        Next
	        If tx = ex And ty = ey
	            cl.AddLast(New closedlist(tx,ty,tpx,tpy))
	            findpathback()
	            Return True
	        Else
	            removefromopenlist(tx,ty)
	            olmap[tx,ty] = 0
	            clmap[tx,ty] = 1
	            cl.AddLast(New closedlist(tx,ty,tpx,tpy))
	            For Local y:=-1 To 1
	            For Local x:=-1 To 1
	                newx = tx+x
	                newy = ty+y
	                If newx>=0 And newy>=0 And newx<mapwidth And newy<mapheight
	                If olmap[newx,newy] = 0
	                If clmap[newx,newy] = 0
	                    olmap[newx,newy] = 1
	                    Local gg:Int = map[newx,newy]+1
	                    Local hh:Int = distance(newx,newy,ex,ey)
	                    Local ff:Int = gg+hh
	                    ol.AddLast(New openlist(newx,newy,ff,gg,hh,tx,ty))
	                End If
	                End If
	                End If
	            Next
	            Next
	        End If
	    Wend
	    Return False
	End method

	
	Method findpathback:Bool()
	    Local x:Int=ex
	    Local y:Int=ey
	    path.AddFirst(New pathnode(x,y))
	    Repeat
	        For Local i:=Eachin cl
	            If i.x = x And i.y = y
	                x = i.px
	                y = i.py
	                path.AddFirst(New pathnode(x,y))
	            End If
	        Next
	        If x = sx And y = sy Then Return True	        
	    Forever    
	    Return False
	End method
	method removefromopenlist:Void(x1:Int,y1:Int)
	    For Local i:=Eachin ol
	        If i.x = x1 And i.y = y1
	            ol.Remove(i)
	            Exit
	        End If
	    Next
	End Method
	
	Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
	    Return Abs(x2-x1)+Abs(y2-y1)
	End Function	
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

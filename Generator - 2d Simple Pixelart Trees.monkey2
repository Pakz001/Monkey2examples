#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Class tree
	Field px:Int,py:Int
	Field pw:Float,ph:Float
	Field mapone:Int[][]
	Field treecolor1:Color = New Color(Rnd(.5,.8),Rnd(.8,1),0)
	Field treecolor2:Color = New Color(Rnd(.3,.7),Rnd(.7,.8),0)
	Field treecolor3:Color = New Color(Rnd(.25,.5),Rnd(.5,.7),0)
	Field treecolor4:Color = New Color(Rnd(),Rnd(),0)
	Field treecolor1:Int=Rnd(230,255)
	Field treecolor1r:Int=Rnd(50,200)
	Field treecolor2:Int=Rnd(190,220)
	Field treecolor3:Int=Rnd(130,180)
	Field treecolor4:Int=Rnd(70,120)
	Field basecolor1:Color = New Color(.5,.24,0)
	Field basecolor2:Color = New Color(.8,.4,0)
	Field basecolor3:Color = New Color(.9,.45,.0)
	'Field basecolor1:Int=150
	'Field basecolor2:Int=190
	'Field basecolor3:Int=220
	Method New(x:Int,y:Int,w:Int,h:Int)
		If Rnd(3)<2 Then treecolor1r = 0
		px = x
		py = y
		pw = w
		ph = h
		mapone = New Int[w][]
		For Local i:Int=0 Until w
			mapone[i] = New Int[h]
		Next
		maketree()
	End Method
	Method maketree()
		Local mx:Float=0.05
		Local my:Float=.1
		Local y:Float=1
		Local x:Float=pw/2+1
		Local base:Float=0
		Local bounce:Float=.1
		Local col:Int
		Local num:Float=2
		Local stap:Float=Rnd(0.001,0.005)
		Local stap2:Float=Rnd(0.01,0.2)
		Local stap3:Float=Rnd(0.5,1.5)
		' Place two black pixels at the top of the tree
		mapone[x-1][0] = 1
		mapone[x-2][0] = 1
		' create the tree
		While (y+5)<=(ph-(ph/20)) 
			y+=my
			x+=mx
			' stay inside the image
			If x>=pw Then x=pw-2
			If x<=0 Then x=0
			' change color of the tree depending
			' on the current y location
			If y<ph/1.4 Then col = treecolor4										
			If y<ph/1.6 Then col = treecolor3
			If y<ph/1.9 Then col = treecolor2
			If y<ph/4 Then col = treecolor1
			' fill the current line
			filltoleft(x,y,pw-x,col)
			' black pixel to the left and right
			mapone[x][y] = 1
			mapone[pw-x][y] = 1				
			' next step in the tree shape
			mx-=stap
			If y<ph/1.45 Then 
				If mx<0 
					If x < ((pw/2)+num) Then mx=bounce ; bounce+=stap2 ; num+=stap3
				End If				
			Else	
				If mx<0	
				If x<((pw/2)+num) Then bounce=.1 ; mx=bounce ; num-=stap3
				Endif
			End If
		Wend
		' Make sure the bottom of the tree is also drawn
		filltoleft(x,y,pw-x,1)
		' Make the tree trunk
		maketreebase()
	End Method
	'
	' Fill from x to tox on y line using col(or)
	' We go from right to left and fill the line with 
	' a number. (tree inside color)
	'
	Method filltoleft(x:Int,y:Int,tox:Int,col:Int)		
		Local ls:Int=(pw/2)
		Local len1:Int=(x-ls)/2
		Local len2:Int=(x-ls)/1.7		
		For Local x2:Int=x To tox Step -1
			mapone[x2][y] = col
			If col = treecolor2 Then
			If Rnd(4) < 1 And distance(x2,0,tox,0) < len1 And y<ph/2 Then mapone[x2][y] = treecolor1
			If Rnd(4) < 1 And distance(x2,0,x,0)< len1 And y<ph/2 Then mapone[x2][y] = treecolor1
			If Rnd(2)<1.3 And distance(x2,0,ls-len1,0) < 2 And y<ph/2 Then mapone[x2][y] = treecolor1
			If Rnd(2)<1.3 And distance(x2,0,ls+len1,0) < 2 And y<ph/2 Then mapone[x2][y] = treecolor1
			End If
			If col=treecolor1
			If Rnd(2) < 1 And y>5 And distance(x2,0,ls,0) < 3 Then mapone[x2][y] = treecolor2
			End If
			If col=treecolor3
			If Rnd(2)<1.3 And distance(x2,0,ls,0) < len2 And y<ph/1.8 Then mapone[x2][y] = treecolor2
			End If
			If col=treecolor4
			If Rnd(2)<1.3 And distance(x2,0,ls,0) < len2 And y<ph/1.45 Then mapone[x2][y] = treecolor3
			End If

		Next
	End Method
	Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)  
    	Return Abs(x2-x1)+Abs(y2-y1)  
  	End Function 
	Method maketreebase()
		' treebase
		For Local y:Int=ph-(ph/5) Until ph
		For Local x:Int=(pw/2)-(pw/8) Until (pw/2)+(pw/8)
			If x<0 Or y<0 Or x>=pw Or y>= ph Then Continue
			mapone[x][y] = basecolor1
			If x=(pw/2)-(pw/8) Then mapone[x][y] = 1
			If x=(pw/2)+(pw/8)-1 Then mapone[x][y]=1
			If y=ph-1 Then mapone[x][y]=1
		Next
		Next
		For Local y:Int=ph-(ph/5) Until ph-(ph/5)
		For Local x:Int=(pw/2)-(pw/8) Until (pw/2)+(pw/8)
			If x<0 Or y<0 Or x>=pw Or y>= ph Then Continue
			mapone[x][y] = 1
		Next
		Next

		' tree base center lighting
		For Local y:Int=ph-(ph/7) Until ph-1
		For Local x:Int=(pw/2)-(pw/30) Until (pw/2)+(pw/30)
			If x<0 Or y<0 Or x>=pw Or y>= ph Then Continue
			mapone[x][y] = basecolor3
		Next
		Next
		For Local y:Int=ph-(ph/7) Until ph-1
		For Local x:Int=(pw/2) Until (pw/2)+(pw/30)
			If x<0 Or y<0 Or x>=pw Or y>= ph Then Continue
			mapone[x][y] = basecolor2
		Next
		Next
		'Remove two black pixels from the bottom of the treebase
		mapone[(pw/2)-(pw/8)][ph-1] = 0
		mapone[(pw/2)+(pw/8)-1][ph-1] = 0


	End Method
	
	Method draw(canvas:Canvas)
		For Local y:Int=0 Until ph
		For Local x:Int=0 Until pw
			If mapone[x][y] = 0 Then Continue
			Select mapone[x][y]
				Case 1
					SetColor 0,0,0					
				Case treecolor1
					SetColor treecolor1r/2,treecolor1,0
				Case treecolor2
					SetColor treecolor1r/1.5,treecolor2,0
				Case treecolor3
					SetColor treecolor1r/1.2,treecolor3,0
				Case treecolor4
					SetColor treecolor1r,treecolor4,0
				Case basecolor1
					SetColor basecolor1,basecolor1/2,0
				Case basecolor2
					SetColor basecolor2,basecolor2/2,0
				Case basecolor3
					SetColor basecolor3,basecolor3/2,0					
			End Select
			DrawRect px+(x*1),py+(y*1),1,1
		Next
		Next
	End Method
End Class


Class MyWindow Extends Window

	Method New()
	End method
	
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

' I took this from the monkey 2 forum. Keeping it here so I can access it quickly.

#import "<std>"
#import "<mojo>"
#import "<mojox>"
 
Using std..
Using mojo..
Using mojox..
 
Class MyWindow Extends Window
 
	Method New()
		Super.New( "Button Demo",640,480,WindowFlags.Resizable )
		
		Local button:=New PushButton( "Click ME!" )
		button.Layout="float"			'normal size
		button.Gravity=New Vec2f( 0,0 )	'top-left
		button.MaxSize=New Vec2i( 100,0 )
		
		button.Clicked=Lambda()
			Alert( "Well done sir!" )
		End
		
		ContentView=button
	End
	
End
 
Function Main()
 
	New AppInstance
	
	New MyWindow
	
	App.Run()
End

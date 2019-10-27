#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..


Class MyWindow Extends Window

	Method New()
		'Our target angle
		Local tan:Float=Pi+0.5
		'Our angle
		Local angle:Float=TwoPi-0.2
		' Our difference (Negative if left target angle is shorter or positive if right turn is closer)
    	Local difference:Float = tan - angle
        While (difference < -Pi) 
        	difference += TwoPi
        Wend
        While (difference > Pi) 
        	difference -= TwoPi
        Wend
        Print difference
		
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

Namespace myapp3d

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"

#Import "../UnlitMaterial"

#Import "textures/cat.png"
#Import "textures/cat_RGB.png"

Using std..
Using mojo..
Using mojo3d..


Class MyWindow Extends Window
	
	Field _scene:Scene
	Field _camera:Camera
	Field _light:Light
	Field _donut:Model
	Field _box:Model
	
	Field _boxes:= New Stack<Model>
	
	Field _pbr1:PbrMaterial
	Field _unlit1:UnlitMaterial
	
	Field _catRGB:Texture
	Field _catRGBA:Texture
	
	Method New( title:String="Simple mojo3d app",width:Int=1920,height:Int=1080,flags:WindowFlags=WindowFlags.Resizable | WindowFlags.HighDPI )
		Super.New( title,width,height,flags )
	End

	
	Method OnCreateWindow() Override
		
		SetConfig( "MOJO3D_RENDERER","forward" )
		SwapInterval = 0
		
		'---------------------------------- create (current) scene ---------------------------------- 
		_scene=New Scene
		_scene.ClearColor = New Color( 0.2, 0.2, 0.2 )
		_scene.AmbientLight = _scene.ClearColor * 0.25
		_scene.FogColor = _scene.ClearColor
		_scene.FogNear = 30.0
		_scene.FogFar = 110.0
		
		'---------------------------------- create camera ---------------------------------- 
		_camera=New Camera( Self )
		_camera.AddComponent<FlyBehaviour>()
		_camera.Move( 0,2.5,-15 )
		_camera.FOV = 35
		_camera.Far = 200
		
		' ---------------------------------- create light ---------------------------------- 
		_light=New Light
		_light.Color = Color.White' * 10
		_light.CastsShadow=True
		_light.Rotate( 45, 45, 0 )
		
		'----------------------------------  create materials ---------------------------------- 
		
		_catRGB = Texture.Load( "asset::cat_RGB.png", TextureFlags.None )
		_catRGBA = Texture.Load( "asset::cat.png", TextureFlags.None )

		_unlit1 =New UnlitMaterial( Color.White )
		_unlit1.ColorTexture = _catRGBA
'		_unlit1.BlendMode = BlendMode.Additive
		
		_pbr1 = New PbrMaterial( Color.White, 0, 0.5 )
		_pbr1.ColorTexture = _catRGB
		
		'---------------------------------- create objs ---------------------------------- 
		
		_box=Model.CreateBox( New Boxf(-2,-2,-2,2,2,2), 1,1,1, _pbr1 )
		_box.Move(2,2.5,-2 )
		_boxes.Add( _box )
		
'		_donut=Model.CreateTorus( 2,.5,48,24, _unlit2 )
'		_donut.Move( -3,2.5,0 )
'		_donut.Rotate(-90,30,0)
		
		Local z:= 20.0
		For Local x := 1 To 15
			For Local y := 1 To 10
				Local box := _box.Copy()
				box.Position = New Vec3f((x-5)*5,(y-5)*4,z)
				box.Color = New Color( Rnd(0.3,0.9), Rnd(0.3,0.9), Rnd(0.3,0.9) )
				box.CastsShadow = False
				_boxes.Add( box )
				z += 0.4
			Next
		Next
		Print z
	End
	
	'---------------------------------- Render Loop ---------------------------------- 
	
	Method OnRender( canvas:Canvas ) Override
		RequestRender()
		
		If Keyboard.KeyPressed( Key.Space )
			_light.Visible = Not _light.Visible
			If _light.Visible
				For Local b := Eachin _boxes
					b.Materials = New Material[]( _pbr1 )
				Next
			Else
				For Local b := Eachin _boxes
					b.Materials = New Material[]( _unlit1 )
				Next
			End
		End
		
		For Local b := Eachin _boxes
			b.Rotate( -.2,.4,-.6 )
		Next
		
'		_donut.Rotate( .2,.4,.6 )
		
		_scene.Update()
		_camera.View = Self
		_camera.Render( canvas )
		canvas.DrawText( "FPS: " + App.FPS, 10, 10 )
		canvas.DrawText( "Hit Space Bar to toggle between PbrMaterial and UnlitMaterial",10,30 )
	End
	
End


Function Main()
	New AppInstance
	New MyWindow
	App.Run()
End

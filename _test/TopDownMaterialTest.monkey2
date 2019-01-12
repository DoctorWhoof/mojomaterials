Namespace myapp3d

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"

#Import "../TopDownMaterial"

#Import "textures/miramar-skybox.jpg"
#Import "textures/water_normal0.png"
#Import "textures/water_normal1.png"
#Import "textures/uvGridSmall.png"
#Import "textures/stonewall.jpg"


Using std..
Using mojo..
Using mojo3d..


Class MyWindow Extends Window
	
	Field _scene:Scene
	Field _camera:Camera
	Field _light:Light
	Field _plane:Model
	Field _box:Model
	
	Field _pbr1:TopDownMaterial
	
	Method New( title:String="Simple mojo3d app",width:Int=1920,height:Int=1080,flags:WindowFlags=WindowFlags.Resizable | WindowFlags.HighDPI )
		Super.New( title,width,height,flags )
	End

	
	Method OnCreateWindow() Override
		
		SetConfig( "MOJO3D_RENDERER","forward" )
		SwapInterval = 0
		
		'---------------------------------- create (current) scene ---------------------------------- 
		_scene=New Scene
		_scene.EnvTexture = Texture.Load( "asset::miramar-skybox.jpg", TextureFlags.FilterMipmap|TextureFlags.Cubemap|TextureFlags.Envmap )
		_scene.SkyTexture = _scene.EnvTexture
		_scene.AmbientLight = New Color( 0.2, 0.35, 0.5, 1.0 )
		_scene.FogColor = New Color( 0.78, 0.74, 0.74, 0.5 )
		_scene.FogNear = 20.0
		_scene.FogFar = 100.0
		
		'---------------------------------- create camera ---------------------------------- 
		_camera=New Camera( Self )
		_camera.AddComponent<FlyBehaviour>()
		_camera.Position = New Vec3f( -6, 8,-10 ) * 1.25
		_camera.FOV = 45
		_camera.Far = 1000
		_camera.PointAt( New Vec3f( 0, 1.5, 0 ) )
		
		' ---------------------------------- create light ---------------------------------- 
		_light=New Light
		_light.Color = Color.White' * 10
		_light.CastsShadow=True
		_light.Rotate( 45, 45, 0 )
		
		'----------------------------------  create materials ---------------------------------- 
		
		Local grid := Texture.Load( "asset::uvGridSmall.png", TextureFlags.FilterMipmap )
		Local stone := Texture.Load( "asset::stonewall.jpg", TextureFlags.FilterMipmap )
		
		_pbr1 = New TopDownMaterial( Color.White, 0, 0.5 )
		_pbr1.ColorTextureA = grid
		_pbr1.ColorTextureB = stone
		_pbr1.Min = -0.5
		_pbr1.Max = 1.5
		
		'---------------------------------- create objs ---------------------------------- 
		
		_box=Model.CreateBox( New Boxf(-3,-3,-3,3,3,3), 1,1,1, _pbr1 )
		_box.Move(0,3,-2 )
		
		_plane= New Model
		_plane.Mesh = Mesh.CreateRect( New Rectf(-1000,-1000,1000,1000 ) )
		_plane.Material = New PbrMaterial( Color.DarkGrey, 0.5, 0.5 )
		_plane.RotateX(90)
	End
	
	'---------------------------------- Render Loop ---------------------------------- 
	
	Method OnRender( canvas:Canvas ) Override
		RequestRender()
'		_box.Rotate( 1,1,1)
		_scene.Update()
		_camera.View = Self
		_camera.Render( canvas )
		canvas.DrawText( "FPS: " + App.FPS, 10, 10 )
	End
	
End


Function Main()
	New AppInstance
	New MyWindow
	App.Run()
End

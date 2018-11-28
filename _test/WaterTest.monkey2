Namespace myapp3d

#Import "<std>"
#Import "<mojo>"
#Import "<mojo3d>"

#Import "../WaterFowMaterial"

#Import "textures/miramar-skybox.jpg"
#Import "textures/water_normal0.png"
#Import "textures/water_normal1.png"
#Import "textures/cat_RGB.png"


Using std..
Using mojo..
Using mojo3d..


Class MyWindow Extends Window
	
	Field _scene:Scene
	Field _camera:Camera
	Field _light:Light
	Field _plane:Model
	Field _box:Model
	
	Field _pbr1:PbrMaterial
	Field _waterMat:WaterFowMaterial
	
	Method New( title:String="Simple mojo3d app",width:Int=1920,height:Int=1080,flags:WindowFlags=WindowFlags.Resizable | WindowFlags.HighDPI )
		Super.New( title,width,height,flags )
	End

	
	Method OnCreateWindow() Override
		
		SetConfig( "MOJO3D_RENDERER","forward" )
		SwapInterval = 0
		
		'---------------------------------- create (current) scene ---------------------------------- 
		_scene=New Scene
		_scene.EnvTexture = Texture.Load( "asset::miramar-skybox.jpg", TextureFlags.Cubemap | TextureFlags.FilterMipmap )
		_scene.SkyTexture = _scene.EnvTexture
		_scene.AmbientLight = New Color( 0.3, 0.45, 0.6, 1.0 )
		_scene.FogColor = New Color( 0.78, 0.74, 0.74, 0.5 )
		_scene.FogNear = 20.0
		_scene.FogFar = 1000.0
		
		'---------------------------------- create camera ---------------------------------- 
		_camera=New Camera( Self )
		_camera.AddComponent<FlyBehaviour>()
		_camera.Move( 0,5,-15 )
		_camera.FOV = 45
		_camera.Far = 1000
		_camera.PointAt( New Vec3f )
		
		' ---------------------------------- create light ---------------------------------- 
		_light=New Light
		_light.Color = Color.White' * 10
		_light.CastsShadow=True
		_light.Rotate( 45, 45, 0 )
		
		'----------------------------------  create materials ---------------------------------- 
		
		Local cat := Texture.Load( "asset::cat_RGB.png", TextureFlags.None )
		
		_pbr1 = New PbrMaterial( Color.White, 0, 0.5 )
		_pbr1.ColorTexture = cat
		
		_waterMat = New WaterFowMaterial
		_waterMat.ScaleTextureMatrix( 100,100 )
		_waterMat.ColorFactor=New Color( 0.025, 0.125, 0.15 )
		_waterMat.Roughness=0.5
		_waterMat.NormalTextures=New Texture[](	Texture.Load( "asset::water_normal0.png", TextureFlags.WrapST | TextureFlags.FilterMipmap ),
													Texture.Load( "asset::water_normal1.png", TextureFlags.WrapST | TextureFlags.FilterMipmap ) )
		_waterMat.Velocities=New Vec2f[](
			New Vec2f( .01,.03 ),
			New Vec2f( .02,.05 ) )
		
		'---------------------------------- create objs ---------------------------------- 
		
		_box=Model.CreateBox( New Boxf(-2,-2,-2,2,2,2), 1,1,1, _pbr1 )
		_box.Move(0,2.5,-2 )
		
		_plane= New Model
		_plane.Mesh = Mesh.CreateRect( New Rectf(-1000,-1000,1000,1000 ) )
		_plane.Material = _waterMat
		_plane.RotateX(90)
	End
	
	'---------------------------------- Render Loop ---------------------------------- 
	
	Method OnRender( canvas:Canvas ) Override
		RequestRender()
		_box.Rotate( -.2,.4,-.6 )
	
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

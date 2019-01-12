
Namespace mojo3d

#Import "<mojo3d>"
#Import "<std>"
#Import "shaders/distance.glsl@/shaders/"

Using mojo3d..
Using std..

#rem monkeydoc The DistanceMaterial class.
#end
Class DistanceMaterial Extends Material
	
	#rem monkeydoc Creates a new pbr material.
	All properties default to white or '1' except for emissive factor which defaults to black. 
	If you set an emissive texture, you will also need to set emissive factor to white to 'enable' it.
	The metalness value should be stored in the 'blue' channel of the metalness texture if the texture has multiple color channels.
	The roughness value should be stored in the 'green' channel of the metalness texture if the texture has multiple color channels.
	The occlusion value should be stored in the 'red' channel of the occlusion texture if the texture has multiple color channels.
	The above last 3 rules allow you to pack metalness, roughness and occlusion into a single texture.
	
	#end
	Method New()
		Init()
		AddInstance()
	End
	
	
	Method New( color:Color,metalness:Float=1.0,roughness:Float=1.0 )
		Init()
		ColorFactor=color
		MetalnessFactor=metalness
		RoughnessFactor=roughness
		AddInstance( New Variant[]( color,metalness,roughness ) )
	End
	
	
	Method New( material:DistanceMaterial )
		Super.New( material )
		AddInstance( material )
	End
	
	Method New( material:PbrMaterial )
		Init()
		ColorFactor=material.ColorFactor
		MetalnessFactor=material.MetalnessFactor
		RoughnessFactor=material.RoughnessFactor
		EmissiveFactor=material.EmissiveFactor
		AmbientFactor=material.AmbientFactor
		
		ColorTextureA=material.ColorTexture
		ColorTextureB=material.ColorTexture
		NormalTextureA=material.NormalTexture
		NormalTextureB=material.NormalTexture
		RoughnessTextureA=material.RoughnessTexture
		RoughnessTextureB=material.RoughnessTexture
		MetalnessTextureA=material.MetalnessTexture
		MetalnessTextureB=material.MetalnessTexture
		EmissiveTextureA=material.EmissiveTexture
		EmissiveTextureB=material.EmissiveTexture
		AmbientTexture=material.AmbientTexture
		
		AddInstance( New Variant[]( ColorFactor,MetalnessFactor,RoughnessFactor ) )
	End
	
	#rem monkeydoc Creates a copy of the pbr material.
	#end
	Method Copy:DistanceMaterial() Override
		Return New DistanceMaterial( Self )
	End
	
	'***** blending *****
	
	[jsonify=1]
	Property Near:Float()
		Return Uniforms.GetFloat( "Near" )
	Setter( value:Float )
		Uniforms.SetFloat( "Near",value )
	End
	
	[jsonify=1]
	Property Far:Float()
		Return Uniforms.GetFloat( "Far" )
	Setter( value:Float )
		Uniforms.SetFloat( "Far",value )
	End
	
	[jsonify=1]
	Property UvScaleNear:Float()
		Return Uniforms.GetFloat( "UvScaleNear" )
	Setter( value:Float )
		Uniforms.SetFloat( "UvScaleNear",value )
	End
	
	[jsonify=1]
	Property UvScaleFar:Float()
		Return Uniforms.GetFloat( "UvScaleFar" )
	Setter( value:Float )
		Uniforms.SetFloat( "UvScaleFar",value )
	End
	
	'not working right, normals don't scale like that
	[jsonify=1]
	Property NormalFactorNear:Float()
		Return Uniforms.GetFloat( "NormalFactorNear" )
	Setter( value:Float )
		Uniforms.SetFloat( "NormalFactorNear",value )
	End
	
	'not working right
	[jsonify=1]
	Property NormalFactorFar:Float()
		Return Uniforms.GetFloat( "NormalFactorFar" )
	Setter( value:Float )
		Uniforms.SetFloat( "NormalFactorFar",value )
	End
	
	[jsonify=1]
	Property MaskTexture:Texture()
		Return Uniforms.GetTexture( "MaskTexture" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "MaskTexture",texture )
		UpdateAttribMask()
	End
	
	'***** textures *****
	
	[jsonify=1]
	Property Boned:Bool()
		Return (AttribMask & 192)=192
	Setter( boned:Bool )
		If boned AttribMask|=192 Else AttribMask&=~192
	End
	
	[jsonify=1]
	Property ColorTextureA:Texture()
		Return Uniforms.GetTexture( "ColorTextureA" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "ColorTextureA",texture )
		UpdateAttribMask()
	End
	
	[jsonify=1]
	Property ColorTextureB:Texture()
		Return Uniforms.GetTexture( "ColorTextureB" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "ColorTextureB",texture )
		UpdateAttribMask()
	End
	
	[jsonify=1]
	Property AmbientTexture:Texture()
		Return Uniforms.GetTexture( "AmbientTexture" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "AmbientTexture",texture )
		UpdateAttribMask()
	End
	
	[jsonify=1]
	Property EmissiveTextureA:Texture()
		Return Uniforms.GetTexture( "EmissiveTextureA" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "EmissiveTextureA",texture )
		UpdateAttribMask()
	End
	
	[jsonify=1]
	Property EmissiveTextureB:Texture()
		Return Uniforms.GetTexture( "EmissiveTextureB" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "EmissiveTextureB",texture )
		UpdateAttribMask()
	End
	
	
	[jsonify=1]
	Property MetalnessTextureA:Texture()
		Return Uniforms.GetTexture( "MetalnessTextureA" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "MetalnessTextureA",texture )
		UpdateAttribMask()
	End
	
	[jsonify=1]
	Property MetalnessTextureB:Texture()
		Return Uniforms.GetTexture( "MetalnessTextureB" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "MetalnessTextureB",texture )
		UpdateAttribMask()
	End

	[jsonify=1]
	Property RoughnessTextureA:Texture()
		Return Uniforms.GetTexture( "RoughnessTextureA" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "RoughnessTextureA",texture )
		UpdateAttribMask()
	End
	
	[jsonify=1]
	Property RoughnessTextureB:Texture()
		Return Uniforms.GetTexture( "RoughnessTextureB" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "RoughnessTextureB",texture )
		UpdateAttribMask()
	End
	
	[jsonify=1]
	Property OcclusionTextureA:Texture()
		Return Uniforms.GetTexture( "OcclusionTextureA" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "OcclusionTextureA",texture )
		UpdateAttribMask()
	End
	
	[jsonify=1]
	Property OcclusionTextureB:Texture()
		Return Uniforms.GetTexture( "OcclusionTextureB" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "OcclusionTextureB",texture )
		UpdateAttribMask()
	End
	
	[jsonify=1]
	Property NormalTextureA:Texture()
		Return Uniforms.GetTexture( "NormalTextureA" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "NormalTextureA",texture )
		If texture AttribMask|=32 Else AttribMask&=~32
		UpdateAttribMask()
	End
	
	[jsonify=1]
	Property NormalTextureB:Texture()
		Return Uniforms.GetTexture( "NormalTextureB" )
	Setter( texture:Texture )
		Uniforms.SetTexture( "NormalTextureB",texture )
		If texture AttribMask|=32 Else AttribMask&=~32
		UpdateAttribMask()
	End
	
	'***** factors *****
	[jsonify=1]
	Property ColorFactor:Color()
		Return Uniforms.GetColor( "ColorFactor" )
	Setter( color:Color )
		Uniforms.SetColor( "ColorFactor",color )
	End
	
	[jsonify=1]
	Property AmbientFactor:Color()
		Return Uniforms.GetColor( "AmbientFactor" )
	Setter( color:Color )
		Uniforms.SetColor( "AmbientFactor",color )
	End
	
	[jsonify=1]
	Property EmissiveFactor:Color()
		Return Uniforms.GetColor( "EmissiveFactor" )
	Setter( color:Color )
		Uniforms.SetColor( "EmissiveFactor",color )
	End
	
	[jsonify=1]
	Property MetalnessFactor:Float()
		Return Uniforms.GetFloat( "MetalnessFactor" )
	Setter( factor:Float )
		Uniforms.SetFloat( "MetalnessFactor",factor )
	End
	
	[jsonify=1]
	Property RoughnessFactor:Float()
		Return Uniforms.GetFloat( "RoughnessFactor" )
	Setter( factor:Float )
		Uniforms.SetFloat( "RoughnessFactor",factor )
	End
	
	#rem monkeydoc Loads a DistanceMaterial from a 'file'.
	
	A .pbr file is actually a directory containing a number of textures in png format. These textures are:
	
	color.png (required)
	emissive.png
	metalness.png
	roughness.png
	occlusion.png
	normal.png
	
	#end
'	Function Load:DistanceMaterial( path:String,textureFlags:TextureFlags=TextureFlags.WrapST|TextureFlags.FilterMipmap )
'		
'		Local scene:=Scene.GetCurrent(),editing:=scene.Editing
'		
'		If editing
'			scene.Jsonifier.BeginLoading()
'		Endif
'
'		Local material:=New DistanceMaterial
'		
'		Local texture:=scene.LoadTexture( path,textureFlags )
'		If texture
'			material.ColorTextureA=texture
'			Return material
'		Endif
'		
'		texture=LoadTexture( path,"color",textureFlags )
'		If texture
'			material.ColorTextureA=texture
'		Endif
'		
'		texture=LoadTexture( path,"emissive",textureFlags )
'		If texture
'			material.EmissiveTextureA=texture
'			material.EmissiveFactor=Color.White
'		Endif
'		
'		texture=LoadTexture( path,"metalness",textureFlags )
'		If texture
'			material.MetalnessTextureA=texture
'		Endif
'		
'		texture=LoadTexture( path,"roughness",textureFlags )
'		If texture
'			material.RoughnessTextureA=texture
'		Endif
'		
'		texture=LoadTexture( path,"occlusion",textureFlags )
'		If texture
'			material.OcclusionTextureA=texture
'		Endif
'		
'		texture=LoadTexture( path,"normal",textureFlags )
'		If Not texture texture=LoadTexture( path,"unormal",textureFlags,True )
'		If texture
'			material.NormalTextureA=texture
'		Endif
'		
'		Local jobj:=JsonObject.Load( path+"/material.json" )
'		If jobj
'			If jobj.Contains( "colorFactor" ) material.ColorFactor=jobj.GetColor( "colorFactor" )
'			If jobj.Contains( "emissiveFactor" ) material.EmissiveFactor=jobj.GetColor( "emissiveFactor" )
'			If jobj.Contains( "metalnessFactor" ) material.MetalnessFactor=jobj.GetNumber( "metalnessFactor" )
'			If jobj.Contains( "roughnessFactor" ) material.RoughnessFactor=jobj.GetNumber( "roughnessFactor" )
'		Endif
'		
'		If editing
'			scene.Jsonifier.EndLoading()
'			scene.Jsonifier.AddInstance( material,"mojo3d.DistanceMaterial.Load",New Variant[]( path,textureFlags ) )
'		Endif
'		
'		Return material
'	End
	
	Private
	
	Field _boned:Bool
	
	Method Init()
		Uniforms.DefaultTexture=Texture.ColorTexture( Color.White )
		
		ShaderName="distance"
		AttribMask=1|2|4

		AmbientTexture=Null

		ColorTextureA=Null
		EmissiveTextureA=Null
		MetalnessTextureA=Null
		RoughnessTextureA=Null
		OcclusionTextureA=Null
		NormalTextureA=Null
		
		ColorTextureB=Null
		EmissiveTextureB=Null
		MetalnessTextureB=Null
		RoughnessTextureB=Null
		OcclusionTextureB=Null
		NormalTextureB=Null
		
		ColorFactor=Color.White
		AmbientFactor=Color.Black
		EmissiveFactor=Color.Black
		MetalnessFactor=1.0
		RoughnessFactor=1.0
		Near= 2.5
		Far = 25.0
		UvScaleNear = 1.0
		UvScaleFar = 10.0
		NormalFactorNear = 1.0 'not working right
		NormalFactorFar = 1.0 'not working right
	End
	
	
	Method UpdateAttribMask()
		If Uniforms.NumTextures<>0 AttribMask|=24 Else AttribMask&=~24
	End
	
End



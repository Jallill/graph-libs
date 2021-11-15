// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( PP_GlitchPPSRenderer ), PostProcessEvent.AfterStack, "PP_Glitch", true )]
public sealed class PP_GlitchPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "PixelationX" )]
	public FloatParameter _PixelationX = new FloatParameter { value = 1024f };
	[Tooltip( "Change Intensity" )]
	public FloatParameter _ChangeIntensity = new FloatParameter { value = 10f };
	[Tooltip( "RedOffset" )]
	public Vector4Parameter _RedOffset = new Vector4Parameter { value = new Vector4(0f,0f,0f,0f) };
	[Tooltip( "GreenOffset" )]
	public Vector4Parameter _GreenOffset = new Vector4Parameter { value = new Vector4(0f,0f,0f,0f) };
	[Tooltip( "BlueOffset" )]
	public Vector4Parameter _BlueOffset = new Vector4Parameter { value = new Vector4(0f,0f,0f,0f) };
	[Tooltip( "PixelationY" )]
	public FloatParameter _PixelationY = new FloatParameter { value = 1024f };
}

public sealed class PP_GlitchPPSRenderer : PostProcessEffectRenderer<PP_GlitchPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "PP_Glitch" ) );
		sheet.properties.SetFloat( "_PixelationX", settings._PixelationX );
		sheet.properties.SetFloat( "_ChangeIntensity", settings._ChangeIntensity );
		sheet.properties.SetVector( "_RedOffset", settings._RedOffset );
		sheet.properties.SetVector( "_GreenOffset", settings._GreenOffset );
		sheet.properties.SetVector( "_BlueOffset", settings._BlueOffset );
		sheet.properties.SetFloat( "_PixelationY", settings._PixelationY );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif

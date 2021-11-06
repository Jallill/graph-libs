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
	[Tooltip( "Pixelation" )]
	public FloatParameter _Pixelation = new FloatParameter { value = 8f };
	[Tooltip( "Change Intensity" )]
	public FloatParameter _ChangeIntensity = new FloatParameter { value = 10f };
}

public sealed class PP_GlitchPPSRenderer : PostProcessEffectRenderer<PP_GlitchPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "PP_Glitch" ) );
		sheet.properties.SetFloat( "_Pixelation", settings._Pixelation );
		sheet.properties.SetFloat( "_ChangeIntensity", settings._ChangeIntensity );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif

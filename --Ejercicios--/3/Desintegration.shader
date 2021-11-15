// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Desintegration"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Chomper_MetallicSmooth("Chomper_MetallicSmooth", 2D) = "white" {}
		_Chomper_Normal("Chomper_Normal", 2D) = "bump" {}
		_Chomper_Occlusion("Chomper_Occlusion", 2D) = "white" {}
		_Chomper_Albedo("Chomper_Albedo", 2D) = "white" {}
		_NoiseScale("Noise Scale", Float) = 9.17
		_Speed("Speed", Float) = 1
		[HDR]_DesintegrationTint("Desintegration Tint", Color) = (0.8235294,1.835294,2,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Chomper_Normal;
		uniform float4 _Chomper_Normal_ST;
		uniform sampler2D _Chomper_Albedo;
		uniform float4 _Chomper_Albedo_ST;
		uniform float4 _DesintegrationTint;
		uniform float _Speed;
		uniform float _NoiseScale;
		uniform sampler2D _Chomper_MetallicSmooth;
		uniform float4 _Chomper_MetallicSmooth_ST;
		uniform sampler2D _Chomper_Occlusion;
		uniform float4 _Chomper_Occlusion_ST;
		uniform float _Cutoff = 0.5;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Chomper_Normal = i.uv_texcoord * _Chomper_Normal_ST.xy + _Chomper_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Chomper_Normal, uv_Chomper_Normal ) );
			float2 uv_Chomper_Albedo = i.uv_texcoord * _Chomper_Albedo_ST.xy + _Chomper_Albedo_ST.zw;
			float mulTime80 = _Time.y * _Speed;
			float temp_output_79_0 = sin( mulTime80 );
			float simplePerlin2D82 = snoise( i.uv_texcoord*_NoiseScale );
			simplePerlin2D82 = simplePerlin2D82*0.5 + 0.5;
			float4 lerpResult93 = lerp( tex2D( _Chomper_Albedo, uv_Chomper_Albedo ) , _DesintegrationTint , ( 1.0 - step( ( temp_output_79_0 + 0.2 ) , simplePerlin2D82 ) ));
			o.Albedo = lerpResult93.rgb;
			float2 uv_Chomper_MetallicSmooth = i.uv_texcoord * _Chomper_MetallicSmooth_ST.xy + _Chomper_MetallicSmooth_ST.zw;
			float4 tex2DNode64 = tex2D( _Chomper_MetallicSmooth, uv_Chomper_MetallicSmooth );
			o.Metallic = tex2DNode64.r;
			o.Smoothness = tex2DNode64.a;
			float2 uv_Chomper_Occlusion = i.uv_texcoord * _Chomper_Occlusion_ST.xy + _Chomper_Occlusion_ST.zw;
			o.Occlusion = tex2D( _Chomper_Occlusion, uv_Chomper_Occlusion ).r;
			o.Alpha = 1;
			clip( step( temp_output_79_0 , simplePerlin2D82 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;584;1360;455;1387.65;628.1194;1.942186;True;False
Node;AmplifyShaderEditor.RangedFloatNode;100;-814.3826,-104.3569;Inherit;False;Property;_Speed;Speed;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;80;-549.2428,3.11536;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;83;-849.9739,66.72805;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;79;-393.477,4.915031;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-774.0419,266.322;Inherit;False;Property;_NoiseScale;Noise Scale;5;0;Create;True;0;0;0;False;0;False;9.17;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-177.5471,-49.92136;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;82;-581.2443,217.2477;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;96;115.6191,-67.6778;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;67;-299.1987,-809.1161;Inherit;True;Property;_Chomper_Albedo;Chomper_Albedo;4;0;Create;True;0;0;0;False;0;False;-1;a131a3e31f0c4794fbd8d1fd0d942b6a;a131a3e31f0c4794fbd8d1fd0d942b6a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;98;357.3755,-686.3873;Inherit;False;Property;_DesintegrationTint;Desintegration Tint;7;1;[HDR];Create;True;0;0;0;False;0;False;0.8235294,1.835294,2,0;0.8235294,1.835294,2,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;99;508.4742,-425.5446;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;85;88.34828,297.9657;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;64;-300.1688,-429.8107;Inherit;True;Property;_Chomper_MetallicSmooth;Chomper_MetallicSmooth;1;0;Create;True;0;0;0;False;0;False;-1;b777e10d28a944c4ea05d834c049bdf0;b777e10d28a944c4ea05d834c049bdf0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;93;813.2192,-660.9382;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;66;-308.7073,-240.0958;Inherit;True;Property;_Chomper_Occlusion;Chomper_Occlusion;3;0;Create;True;0;0;0;False;0;False;-1;8b8f71b26727fd347aa7a9584bad7892;8b8f71b26727fd347aa7a9584bad7892;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;65;-298.3157,-619.4011;Inherit;True;Property;_Chomper_Normal;Chomper_Normal;2;0;Create;True;0;0;0;False;0;False;-1;937c2229d98699c4f9ac979b18b24a85;937c2229d98699c4f9ac979b18b24a85;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;742.63,-229.0912;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Desintegration;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;80;0;100;0
WireConnection;79;0;80;0
WireConnection;95;0;79;0
WireConnection;82;0;83;0
WireConnection;82;1;84;0
WireConnection;96;0;95;0
WireConnection;96;1;82;0
WireConnection;99;0;96;0
WireConnection;85;0;79;0
WireConnection;85;1;82;0
WireConnection;93;0;67;0
WireConnection;93;1;98;0
WireConnection;93;2;99;0
WireConnection;0;0;93;0
WireConnection;0;1;65;0
WireConnection;0;3;64;1
WireConnection;0;4;64;4
WireConnection;0;5;66;1
WireConnection;0;10;85;0
ASEEND*/
//CHKSM=0D6B5E06421EBBDEA5E3CED32F1483AF0C1D88B0
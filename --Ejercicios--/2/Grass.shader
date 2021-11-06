// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Grass"
{
	Properties
	{
		_Grass01_Albedo("Grass01_Albedo", 2D) = "white" {}
		_Grass01_Normal("Grass01_Normal", 2D) = "bump" {}
		_Grass01_Occlusion("Grass01_Occlusion", 2D) = "white" {}
		_Freq("Freq", Float) = 50
		_WaveSize("Wave Size", Range( 0 , 1)) = 0.02352946
		_Position("Position", Vector) = (0,0,0,0)
		_Radius("Radius", Float) = 2
		_Gradient("Gradient", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _Freq;
		uniform float _WaveSize;
		uniform float3 _Position;
		uniform float _Radius;
		uniform float _Gradient;
		uniform sampler2D _Grass01_Normal;
		uniform float4 _Grass01_Normal_ST;
		uniform sampler2D _Grass01_Albedo;
		uniform float4 _Grass01_Albedo_ST;
		uniform sampler2D _Grass01_Occlusion;
		uniform float4 _Grass01_Occlusion_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 lerpResult51 = lerp( float3(0,-1,0) , ( sin( ( ( ase_worldPos * ( _Freq * 6.28318548202515 ) ) + _Time.y ) ) * float3(1,0,0) * _WaveSize ) , saturate( pow( ( distance( _Position , ase_worldPos ) / _Radius ) , _Gradient ) ));
			v.vertex.xyz += lerpResult51;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Grass01_Normal = i.uv_texcoord * _Grass01_Normal_ST.xy + _Grass01_Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Grass01_Normal, uv_Grass01_Normal ) );
			float2 uv_Grass01_Albedo = i.uv_texcoord * _Grass01_Albedo_ST.xy + _Grass01_Albedo_ST.zw;
			float4 tex2DNode2 = tex2D( _Grass01_Albedo, uv_Grass01_Albedo );
			o.Albedo = tex2DNode2.rgb;
			float2 uv_Grass01_Occlusion = i.uv_texcoord * _Grass01_Occlusion_ST.xy + _Grass01_Occlusion_ST.zw;
			o.Occlusion = tex2D( _Grass01_Occlusion, uv_Grass01_Occlusion ).r;
			o.Alpha = tex2DNode2.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;454;1258;585;4609.742;731.1441;4.373928;True;False
Node;AmplifyShaderEditor.CommentaryNode;18;-2138.379,276.1659;Inherit;False;1499.342;432.1808;Deformacion en el Eje vertical;8;29;28;27;23;22;21;20;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;19;-2129.379,323.1658;Inherit;False;348.8388;233.4428;Para que siempre se repita al comienzo la onda;3;26;25;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TauNode;24;-2081.039,444.3086;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2089.379,372.1658;Inherit;False;Property;_Freq;Freq;3;0;Create;True;0;0;0;False;0;False;50;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;33;-1957.14,936.7302;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;31;-1939.599,744.3649;Inherit;False;Property;_Position;Position;5;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1952.541,383.6086;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;30;-2372.341,320.8531;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1752.769,310.377;Inherit;True;2;2;0;FLOAT3;2,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;23;-1741.064,551.3205;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1550.822,965.3287;Inherit;False;Property;_Radius;Radius;6;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;32;-1625.149,800.4207;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1537.063,371.3207;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1316.823,1016.328;Inherit;False;Property;_Gradient;Gradient;7;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;34;-1428.823,849.3284;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1197.11,616.1079;Inherit;False;Property;_WaveSize;Wave Size;4;0;Create;True;0;0;0;False;0;False;0.02352946;0.0537046;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;21;-1131.803,441.5005;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;35;-1207.823,902.3284;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;29;-1338.875,366.9039;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;55;-502.0658,132.5539;Inherit;False;Constant;_Vector1;Vector 1;8;0;Create;True;0;0;0;False;0;False;0,-1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-897.8024,387.5005;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;38;-1046.823,931.3284;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-797.3237,-168.6517;Inherit;True;Property;_Grass01_Normal;Grass01_Normal;1;0;Create;True;0;0;0;False;0;False;-1;e031e487d0803524b981dad56a1d90c6;e031e487d0803524b981dad56a1d90c6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;51;-304.4998,192.3599;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;4;-796.0237,18.54834;Inherit;True;Property;_Grass01_Occlusion;Grass01_Occlusion;2;0;Create;True;0;0;0;False;0;False;-1;e19ec2a1f2c1df340aabaaaf1d8b6741;e19ec2a1f2c1df340aabaaaf1d8b6741;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-803.8239,-363.6516;Inherit;True;Property;_Grass01_Albedo;Grass01_Albedo;0;0;Create;True;0;0;0;False;0;False;-1;4188a9f5cacb8a54aa76e21640ad6576;4188a9f5cacb8a54aa76e21640ad6576;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;362.0267,-190.8;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Grass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;25;0
WireConnection;26;1;24;0
WireConnection;27;0;30;0
WireConnection;27;1;26;0
WireConnection;32;0;31;0
WireConnection;32;1;33;0
WireConnection;28;0;27;0
WireConnection;28;1;23;0
WireConnection;34;0;32;0
WireConnection;34;1;36;0
WireConnection;35;0;34;0
WireConnection;35;1;37;0
WireConnection;29;0;28;0
WireConnection;22;0;29;0
WireConnection;22;1;21;0
WireConnection;22;2;20;0
WireConnection;38;0;35;0
WireConnection;51;0;55;0
WireConnection;51;1;22;0
WireConnection;51;2;38;0
WireConnection;0;0;2;0
WireConnection;0;1;3;0
WireConnection;0;5;4;1
WireConnection;0;9;2;4
WireConnection;0;11;51;0
ASEEND*/
//CHKSM=45DEAD5E363CF0B86E7CD2A1B9FBEAD08FC8891A
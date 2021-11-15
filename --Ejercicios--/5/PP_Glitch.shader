// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PP_Glitch"
{
	Properties
	{
		_PixelationX("PixelationX", Float) = 1024
		_ChangeIntensity("Change Intensity", Float) = 10
		_RedOffset("RedOffset", Vector) = (0,0,0,0)
		_GreenOffset("GreenOffset", Vector) = (0,0,0,0)
		_BlueOffset("BlueOffset", Vector) = (0,0,0,0)
		_PixelationY("PixelationY", Float) = 1024

	}

	SubShader
	{
		LOD 0

		Cull Off
		ZWrite Off
		ZTest Always
		
		Pass
		{
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"

		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float2 _RedOffset;
			uniform float _ChangeIntensity;
			uniform float2 _GreenOffset;
			uniform float2 _BlueOffset;
			uniform float _PixelationX;
			uniform float _PixelationY;


			
			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float2 _Vector0 = float2(0,0);
				float temp_output_26_0 = saturate( ( ( sin( ( _Time.y * _ChangeIntensity ) ) + 1.0 ) / 2.0 ) );
				float2 lerpResult39 = lerp( _RedOffset , _Vector0 , temp_output_26_0);
				float2 texCoord28 = i.texcoord.xy * float2( 1,1 ) + lerpResult39;
				float4 tex2DNode27 = tex2D( _MainTex, texCoord28 );
				float2 lerpResult38 = lerp( _GreenOffset , _Vector0 , temp_output_26_0);
				float2 texCoord34 = i.texcoord.xy * float2( 1,1 ) + lerpResult38;
				float2 lerpResult37 = lerp( _BlueOffset , _Vector0 , temp_output_26_0);
				float2 texCoord36 = i.texcoord.xy * float2( 1,1 ) + lerpResult37;
				float4 appendResult23 = (float4(tex2DNode27.r , tex2D( _MainTex, texCoord34 ).g , tex2D( _MainTex, texCoord36 ).b , tex2DNode27.a));
				float2 texCoord5 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float pixelWidth4 =  1.0f / _PixelationX;
				float pixelHeight4 = 1.0f / _PixelationY;
				half2 pixelateduv4 = half2((int)(texCoord5.x / pixelWidth4) * pixelWidth4, (int)(texCoord5.y / pixelHeight4) * pixelHeight4);
				float2 lerpResult7 = lerp( texCoord5 , pixelateduv4 , temp_output_26_0);
				float4 lerpResult44 = lerp( appendResult23 , tex2D( _MainTex, lerpResult7 ) , temp_output_26_0);
				

				float4 color = lerpResult44;
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;584;1360;455;2555.527;398.0386;2.011185;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;9;-1650.493,242.3995;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1682.493,349.3995;Inherit;False;Property;_ChangeIntensity;Change Intensity;1;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1475.493,252.3994;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;8;-1284.493,250.3994;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1114.493,252.3994;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;41;-882.7764,242.4964;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;40;-1857.629,-564.1714;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;35;-1572.949,-793.7448;Inherit;False;Property;_BlueOffset;BlueOffset;4;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;33;-1580.442,-602.5977;Inherit;False;Property;_GreenOffset;GreenOffset;3;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;30;-1562.428,-401.0615;Inherit;False;Property;_RedOffset;RedOffset;2;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;26;-636.0325,216.9279;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1503.944,170.6642;Inherit;False;Property;_PixelationY;PixelationY;5;0;Create;True;0;0;0;False;0;False;1024;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1500.318,99.9632;Inherit;False;Property;_PixelationX;PixelationX;0;0;Create;True;0;0;0;False;0;False;1024;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;38;-1149.523,-583.0032;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;39;-1153.18,-397.925;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1401.458,-158.2562;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;37;-1201.349,-789.7805;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-851.5082,-446.1671;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;1,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCPixelate;4;-1158.959,5.501205;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT;16;False;2;FLOAT;16;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-846.5457,-572.0162;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;1,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-669.8918,-217.078;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-857.0533,-773.1631;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;1,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;32;-363.1928,-755.7231;Inherit;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;31;-364.6941,-547.0704;Inherit;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;7;-661.0408,-104.394;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;27;-363.1921,-335.9542;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-344.3318,10.38558;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;23;-4.7139,-313.0649;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;44;314.787,-141.9704;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;637.9214,-167.7946;Float;False;True;-1;2;ASEMaterialInspector;0;2;PP_Glitch;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;8;0;11;0
WireConnection;13;0;8;0
WireConnection;41;0;13;0
WireConnection;26;0;41;0
WireConnection;38;0;33;0
WireConnection;38;1;40;0
WireConnection;38;2;26;0
WireConnection;39;0;30;0
WireConnection;39;1;40;0
WireConnection;39;2;26;0
WireConnection;37;0;35;0
WireConnection;37;1;40;0
WireConnection;37;2;26;0
WireConnection;28;1;39;0
WireConnection;4;0;5;0
WireConnection;4;1;6;0
WireConnection;4;2;43;0
WireConnection;34;1;38;0
WireConnection;36;1;37;0
WireConnection;32;0;1;0
WireConnection;32;1;36;0
WireConnection;31;0;1;0
WireConnection;31;1;34;0
WireConnection;7;0;5;0
WireConnection;7;1;4;0
WireConnection;7;2;26;0
WireConnection;27;0;1;0
WireConnection;27;1;28;0
WireConnection;2;0;1;0
WireConnection;2;1;7;0
WireConnection;23;0;27;1
WireConnection;23;1;31;2
WireConnection;23;2;32;3
WireConnection;23;3;27;4
WireConnection;44;0;23;0
WireConnection;44;1;2;0
WireConnection;44;2;26;0
WireConnection;0;0;44;0
ASEEND*/
//CHKSM=E1B3571F572F47FC4FD6148FA8D0AEAC5DC970C8
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SurgerySim/BackgroundFade_FX"
{
	Properties
	{
		_AlbedoTexture("Albedo Texture", 2D) = "white" {}
		_NormalTexture("Normal Texture", 2D) = "white" {}
		_MetallicSmoothnessTexture("Metallic / Smoothness Texture", 2D) = "white" {}
		_MetallicValue("Metallic Value", Range( 0 , 1)) = 0
		_Smoothnessvalue("Smoothness value", Range( 0 , 1)) = 0
		_AmbientOcclusionTexture("Ambient Occlusion Texture", 2D) = "white" {}
		_EmissionTexture("Emission Texture", 2D) = "white" {}
		_EmissionTexturePower("Emission Texture Power", Range( 0 , 10)) = 0
		_StyleTextureColorBlend("StyleTextureColorBlend", Range( 0 , 1)) = 0.5
		_StyleTextureTint("StyleTextureTint", Color) = (1,1,1,0)
		_FresnelPower("FresnelPower", Range( 0 , 1)) = 0.5
		_FresnelGlowValue("Fresnel Glow Value", Range( 0 , 1)) = 0
		_FresnelGlowPower("Fresnel Glow Power", Range( 0 , 100)) = 0
		[HDR]_GlowColor("GlowColor", Color) = (0,0,0,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_HologramTexture("Hologram Texture", 2D) = "white" {}
		_LinearTransition("LinearTransition", Range( -1 , 6)) = 0
		_StyleTexturePannerSpeed("StyleTexturePannerSpeed", Range( 0 , 1)) = 0
		_StyleTextureTiling("Style Texture Tiling", Vector) = (1,1,0,0)
		_StyleTexturePannerDirection("StyleTexturePannerDirection", Vector) = (0,0,0,0)
		_TransitionBlur("Transition Blur", Range( -10 , 10)) = 0
		_VertexOffestPower("VertexOffest Power", Range( 0 , 1)) = 0
		_OpacityValue("OpacityValue", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _LinearTransition;
		uniform float _TransitionBlur;
		uniform float _VertexOffestPower;
		uniform float4 _StyleTextureTint;
		uniform sampler2D _HologramTexture;
		uniform float2 _StyleTextureTiling;
		uniform float _StyleTexturePannerSpeed;
		uniform float2 _StyleTexturePannerDirection;
		uniform float _StyleTextureColorBlend;
		uniform sampler2D _NormalTexture;
		uniform float4 _NormalTexture_ST;
		uniform sampler2D _AlbedoTexture;
		uniform float4 _AlbedoTexture_ST;
		uniform sampler2D _EmissionTexture;
		uniform float4 _EmissionTexture_ST;
		uniform float _EmissionTexturePower;
		uniform float4 _GlowColor;
		uniform float _FresnelPower;
		uniform float _FresnelGlowValue;
		uniform float _FresnelGlowPower;
		uniform sampler2D _MetallicSmoothnessTexture;
		uniform float4 _MetallicSmoothnessTexture_ST;
		uniform float _MetallicValue;
		uniform float _Smoothnessvalue;
		uniform sampler2D _AmbientOcclusionTexture;
		uniform float4 _AmbientOcclusionTexture_ST;
		uniform float _OpacityValue;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float4 transform58 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float LinearTransition56 = saturate( ( ( transform58.y + _LinearTransition ) / _TransitionBlur ) );
			float mulTime68 = _Time.y * _StyleTexturePannerSpeed;
			float2 panner36 = ( mulTime68 * _StyleTexturePannerDirection + float2( 0,0 ));
			float2 uv_TexCoord29 = v.texcoord.xy * _StyleTextureTiling + panner36;
			float4 lerpResult3 = lerp( _StyleTextureTint , ( tex2Dlod( _HologramTexture, float4( uv_TexCoord29, 0, 0.0) ) + 0.0 ) , _StyleTextureColorBlend);
			float4 StyleTexture67 = lerpResult3;
			float4 VertexOffset117 = ( float4( ( ( ase_vertex3Pos * LinearTransition56 ) * _VertexOffestPower ) , 0.0 ) * StyleTexture67 );
			v.vertex.xyz += VertexOffset117.rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTexture = i.uv_texcoord * _NormalTexture_ST.xy + _NormalTexture_ST.zw;
			float4 NormalTexture138 = tex2D( _NormalTexture, uv_NormalTexture );
			o.Normal = NormalTexture138.rgb;
			float2 uv_AlbedoTexture = i.uv_texcoord * _AlbedoTexture_ST.xy + _AlbedoTexture_ST.zw;
			float4 AlbedoTexture136 = tex2D( _AlbedoTexture, uv_AlbedoTexture );
			o.Albedo = AlbedoTexture136.rgb;
			float2 uv_EmissionTexture = i.uv_texcoord * _EmissionTexture_ST.xy + _EmissionTexture_ST.zw;
			float4 EmissionTexture139 = ( tex2D( _EmissionTexture, uv_EmissionTexture ) * _EmissionTexturePower );
			float mulTime68 = _Time.y * _StyleTexturePannerSpeed;
			float2 panner36 = ( mulTime68 * _StyleTexturePannerDirection + float2( 0,0 ));
			float2 uv_TexCoord29 = i.uv_texcoord * _StyleTextureTiling + panner36;
			float4 lerpResult3 = lerp( _StyleTextureTint , ( tex2D( _HologramTexture, uv_TexCoord29 ) + 0.0 ) , _StyleTextureColorBlend);
			float4 StyleTexture67 = lerpResult3;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform58 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float LinearTransition56 = saturate( ( ( transform58.y + _LinearTransition ) / _TransitionBlur ) );
			float4 StylePlusLinearTransition62 = ( _GlowColor * ( StyleTexture67 * LinearTransition56 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV14 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode14 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV14, _FresnelPower ) );
			float4 Fresnel49 = ( ( ( StyleTexture67 * fresnelNode14 ) * _FresnelGlowValue ) * _FresnelGlowPower );
			o.Emission = ( EmissionTexture139 + ( StylePlusLinearTransition62 * Fresnel49 ) ).rgb;
			float2 uv_MetallicSmoothnessTexture = i.uv_texcoord * _MetallicSmoothnessTexture_ST.xy + _MetallicSmoothnessTexture_ST.zw;
			float4 tex2DNode133 = tex2D( _MetallicSmoothnessTexture, uv_MetallicSmoothnessTexture );
			float4 MetallicSmoothnessTexture140 = ( ( tex2DNode133 * _MetallicValue ) * ( tex2DNode133 * _Smoothnessvalue ) );
			float4 temp_output_142_0 = MetallicSmoothnessTexture140;
			o.Metallic = temp_output_142_0.r;
			o.Smoothness = temp_output_142_0.r;
			float2 uv_AmbientOcclusionTexture = i.uv_texcoord * _AmbientOcclusionTexture_ST.xy + _AmbientOcclusionTexture_ST.zw;
			float4 AmbientOcclusionTexture141 = tex2D( _AmbientOcclusionTexture, uv_AmbientOcclusionTexture );
			o.Occlusion = AmbientOcclusionTexture141.r;
			float temp_output_119_0 = _OpacityValue;
			o.Alpha = temp_output_119_0;
			float temp_output_91_0 = ( LinearTransition56 * 1.0 );
			float4 temp_cast_7 = (temp_output_91_0).xxxx;
			float4 OpacityMask_StylePlusLinearTransition88 = ( ( ( ( 1.0 - LinearTransition56 ) * StyleTexture67 ) - temp_cast_7 ) + ( 1.0 - temp_output_91_0 ) );
			clip( OpacityMask_StylePlusLinearTransition88.r - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog vertex:vertexDataFunc 

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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
Version=17500
0;553;1370;457;466.9222;776.7556;1.519695;True;False
Node;AmplifyShaderEditor.CommentaryNode;73;-5422.425,-1279.991;Inherit;False;1717.316;629.0322;Texture Sample / Texture Tiling / Panner / Speed / Tint / Color Blend;13;69;71;68;36;48;29;23;6;4;3;67;75;76;Style Texture Properties;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-5372.425,-834.4818;Float;False;Property;_StyleTexturePannerSpeed;StyleTexturePannerSpeed;18;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;71;-5287.091,-1042.953;Float;False;Property;_StyleTexturePannerDirection;StyleTexturePannerDirection;20;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;68;-5093.184,-832.4001;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;48;-5329.505,-1211.149;Float;False;Property;_StyleTextureTiling;Style Texture Tiling;19;0;Create;True;0;0;False;0;1,1;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;36;-4921.417,-966.04;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;84;-3284.612,-1135.757;Inherit;False;1450.671;468.0781;Transition Direction / Transition blur;9;81;65;53;56;79;80;54;58;52;Linear Transition;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-4837.667,-1229.991;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;52;-3238.612,-1088.162;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;58;-3017.778,-1094.295;Inherit;True;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;-4515.379,-1040.366;Float;False;Constant;_Booster;Booster;15;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-3085.771,-876.6133;Float;False;Property;_LinearTransition;LinearTransition;17;0;Create;True;0;0;False;0;0;1.1;-1;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-4532.046,-1242.167;Inherit;True;Property;_HologramTexture;Hologram Texture;16;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-2772.86,-1013.328;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-4565.503,-770.5595;Float;False;Property;_StyleTextureColorBlend;StyleTextureColorBlend;8;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-4532.119,-958.2231;Float;False;Property;_StyleTextureTint;StyleTextureTint;9;0;Create;True;0;0;False;0;1,1,1,0;0,0.86376,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;-2826.5,-782.1782;Float;False;Property;_TransitionBlur;Transition Blur;21;0;Create;True;0;0;False;0;0;2.5;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-4219.285,-1160.166;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;78;-5373.815,-465.1739;Inherit;False;1926.828;468.5465;Comment;11;16;21;20;14;12;10;18;19;74;22;49;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;3;-4085.623,-953.9332;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;79;-2522.445,-900.7359;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-3897.811,-959.6359;Float;False;StyleTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-5323.815,-320.8347;Float;False;Property;_FresnelPower;FresnelPower;11;0;Create;True;0;0;False;0;0.5;0.19;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;81;-2327.66,-899.0353;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;128;-1770.906,-540.5231;Inherit;False;1804.903;789.4659;Comment;10;55;83;87;90;91;86;92;93;94;88;Opacity Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;127;-1432.741,-1306.547;Inherit;False;1064.731;526.994;Comment;6;61;85;100;60;101;62;Style + Linear Transition;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-2067.44,-1085.757;Float;True;LinearTransition;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-4504.024,-415.174;Inherit;False;67;StyleTexture;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;14;-4985.136,-384.693;Inherit;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-1382.741,-1214.129;Inherit;True;67;StyleTexture;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-4283.59,-410.3766;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-1720.906,-489.2572;Inherit;True;56;LinearTransition;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-1380.119,-1009.553;Inherit;True;56;LinearTransition;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-4333.153,-231.2567;Float;False;Property;_FresnelGlowValue;Fresnel Glow Value;12;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;126;-3314.147,-410.0142;Inherit;False;1364.89;488.8913;Comment;8;117;110;115;116;111;113;112;114;Vertex Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-4337.819,-109.1272;Float;False;Property;_FresnelGlowPower;Fresnel Glow Power;13;0;Create;True;0;0;False;0;0;1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1131.711,-1068.928;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-4053.771,-268.1864;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;100;-1114.2,-1256.547;Float;False;Property;_GlowColor;GlowColor;14;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0.9647059,2,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;110;-3259.391,-172.2205;Inherit;True;56;LinearTransition;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;111;-3264.147,-360.0143;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;90;-1628.399,-43.21995;Inherit;True;56;LinearTransition;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;83;-1470.996,-484.2972;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-1483.96,-230.9492;Inherit;True;67;StyleTexture;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-6628.952,-429.0217;Float;False;Property;_MetallicValue;Metallic Value;3;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;132;-6943.521,-722.3151;Inherit;True;Property;_EmissionTexture;Emission Texture;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-3901.372,-130.1141;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-6637.622,-636.3296;Float;False;Property;_EmissionTexturePower;Emission Texture Power;7;0;Create;True;0;0;False;0;0;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1288.674,-45.76301;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-2905.847,-264.3142;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;133;-6913.356,-501.3558;Inherit;True;Property;_MetallicSmoothnessTexture;Metallic / Smoothness Texture;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-1220.96,-486.9491;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-6630.042,-359.4355;Float;False;Property;_Smoothnessvalue;Smoothness value;4;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-2909.857,-35.62272;Float;False;Property;_VertexOffestPower;VertexOffest Power;22;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-868.7804,-1043.335;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-2573.258,-136.8232;Inherit;False;67;StyleTexture;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-6334.597,-495.3065;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-2574.357,-265.5233;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-6265.551,-357.1995;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;93;-949.1452,-0.1563339;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-6370.622,-715.3296;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-644.5101,-1090.946;Float;True;StylePlusLinearTransition;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-3680.49,-133.787;Float;False;Fresnel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;92;-968.5078,-266.2911;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;134;-6916.092,-274.7384;Inherit;True;Property;_AmbientOcclusionTexture;Ambient Occlusion Texture;5;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;94;-642.5615,-116.6343;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-26.37894,-677.7083;Inherit;False;62;StylePlusLinearTransition;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-2366.458,-229.2233;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-6213.823,-719.2646;Float;False;EmissionTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;129;47.06068,-528.3234;Inherit;False;49;Fresnel;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-6143.685,-475.7132;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;106;-6967.56,-1227.757;Inherit;True;Property;_AlbedoTexture;Albedo Texture;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;135;-6952.001,-940.4081;Inherit;True;Property;_NormalTexture;Normal Texture;1;0;Create;True;0;0;False;0;-1;None;None;True;0;True;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;149;303.4431,-683.066;Inherit;False;139;EmissionTexture;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;334.0955,-596.2233;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;141;-6553.918,-277.2211;Float;False;AmbientOcclusionTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-2182.757,-234.7235;Float;False;VertexOffset;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;-5989.175,-500.6341;Float;False;MetallicSmoothnessTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;-6600.353,-939.2762;Float;False;NormalTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-6572.99,-1207.904;Float;False;AlbedoTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;88;-334.126,-284.605;Float;True;OpacityMask_StylePlusLinearTransition;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;878.838,140.455;Inherit;False;117;VertexOffset;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;151;844.4529,-286.9066;Inherit;False;138;NormalTexture;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;121;476.4088,-7.68229;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-4713.333,-290.2747;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;93.56364,-96.36263;Float;False;Property;_OpacityValue;OpacityValue;23;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;65;-2396.624,-1029.851;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;717.0504,30.35089;Inherit;False;88;OpacityMask_StylePlusLinearTransition;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-5014.122,-200.2978;Float;False;Property;_Opacity;Opacity;10;0;Create;True;0;0;False;0;4.47;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;796.8257,-174.0678;Inherit;False;140;MetallicSmoothnessTexture;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;120;104.2165,17.03209;Float;False;Constant;_Opaque;Opaque;17;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;797.6292,-97.77971;Inherit;False;141;AmbientOcclusionTexture;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;169;525.6347,-630.6443;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;842.0974,-359.0583;Inherit;False;136;AlbedoTexture;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;281.6875,180.2509;Inherit;False;56;LinearTransition;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1108.11,-293.2046;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SurgerySim/BackgroundFade_FX;False;False;False;False;True;True;True;True;True;True;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;8.47;1,1,1,0;VertexScale;True;False;Cylindrical;False;Relative;0;;15;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;68;0;69;0
WireConnection;36;2;71;0
WireConnection;36;1;68;0
WireConnection;29;0;48;0
WireConnection;29;1;36;0
WireConnection;58;0;52;0
WireConnection;23;1;29;0
WireConnection;53;0;58;2
WireConnection;53;1;54;0
WireConnection;75;0;23;0
WireConnection;75;1;76;0
WireConnection;3;0;4;0
WireConnection;3;1;75;0
WireConnection;3;2;6;0
WireConnection;79;0;53;0
WireConnection;79;1;80;0
WireConnection;67;0;3;0
WireConnection;81;0;79;0
WireConnection;56;0;81;0
WireConnection;14;3;12;0
WireConnection;10;0;74;0
WireConnection;10;1;14;0
WireConnection;60;0;61;0
WireConnection;60;1;85;0
WireConnection;20;0;10;0
WireConnection;20;1;19;0
WireConnection;83;0;55;0
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;91;0;90;0
WireConnection;112;0;111;0
WireConnection;112;1;110;0
WireConnection;86;0;83;0
WireConnection;86;1;87;0
WireConnection;101;0;100;0
WireConnection;101;1;60;0
WireConnection;145;0;133;0
WireConnection;145;1;146;0
WireConnection;113;0;112;0
WireConnection;113;1;114;0
WireConnection;153;0;133;0
WireConnection;153;1;152;0
WireConnection;93;0;91;0
WireConnection;148;0;132;0
WireConnection;148;1;147;0
WireConnection;62;0;101;0
WireConnection;49;0;21;0
WireConnection;92;0;86;0
WireConnection;92;1;91;0
WireConnection;94;0;92;0
WireConnection;94;1;93;0
WireConnection;115;0;113;0
WireConnection;115;1;116;0
WireConnection;139;0;148;0
WireConnection;154;0;145;0
WireConnection;154;1;153;0
WireConnection;131;0;50;0
WireConnection;131;1;129;0
WireConnection;141;0;134;0
WireConnection;117;0;115;0
WireConnection;140;0;154;0
WireConnection;138;0;135;0
WireConnection;136;0;106;0
WireConnection;88;0;94;0
WireConnection;121;0;120;0
WireConnection;121;1;119;0
WireConnection;121;2;122;0
WireConnection;18;0;14;0
WireConnection;18;1;16;0
WireConnection;169;0;149;0
WireConnection;169;1;131;0
WireConnection;0;0;137;0
WireConnection;0;1;151;0
WireConnection;0;2;169;0
WireConnection;0;3;142;0
WireConnection;0;4;142;0
WireConnection;0;5;155;0
WireConnection;0;9;119;0
WireConnection;0;10;89;0
WireConnection;0;11;118;0
ASEEND*/
//CHKSM=A37FC3B97241264C918FC341432D181C8B74EABC
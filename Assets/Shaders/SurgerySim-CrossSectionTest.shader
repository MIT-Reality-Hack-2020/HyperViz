// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SurgerySim/CrossSectionTest"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_AlbedoTexture("Albedo Texture", 2D) = "white" {}
		_MetallicTexture("Metallic Texture", 2D) = "white" {}
		_AlbedoTint("Albedo Tint", Color) = (0.5754717,0.5754717,0.5754717,0)
		_MetalicSmoothnessValue("MetalicSmoothness Value", Range( 0 , 1)) = 0
		_CrossSectionStartPoint("Cross Section Start Point", Range( -10 , 10)) = 0.75
		_CrossSectionDistribution("Cross Section Distribution", Range( 1 , 2)) = 1
		_EmissionTexture("Emission Texture", 2D) = "white" {}
		_EmissionColor("Emission Color", Color) = (0.5754717,0.5754717,0.5754717,0)
		_EmissionPower("EmissionPower", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _AlbedoTexture;
		uniform float4 _AlbedoTexture_ST;
		uniform float4 _AlbedoTint;
		uniform sampler2D _EmissionTexture;
		uniform float4 _EmissionTexture_ST;
		uniform float4 _EmissionColor;
		uniform float _EmissionPower;
		uniform sampler2D _MetallicTexture;
		uniform float4 _MetallicTexture_ST;
		uniform float _MetalicSmoothnessValue;
		uniform float _CrossSectionStartPoint;
		uniform float _CrossSectionDistribution;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_AlbedoTexture = i.uv_texcoord * _AlbedoTexture_ST.xy + _AlbedoTexture_ST.zw;
			float4 AlbedoTexture22 = tex2D( _AlbedoTexture, uv_AlbedoTexture );
			o.Albedo = ( AlbedoTexture22 * _AlbedoTint ).rgb;
			float2 uv_EmissionTexture = i.uv_texcoord * _EmissionTexture_ST.xy + _EmissionTexture_ST.zw;
			float4 EmissionTexture19 = tex2D( _EmissionTexture, uv_EmissionTexture );
			o.Emission = ( ( EmissionTexture19 * _EmissionColor ) * _EmissionPower ).rgb;
			float2 uv_MetallicTexture = i.uv_texcoord * _MetallicTexture_ST.xy + _MetallicTexture_ST.zw;
			float4 MetallicSmoothnesTexture34 = ( tex2D( _MetallicTexture, uv_MetallicTexture ) * _MetalicSmoothnessValue );
			float4 temp_output_33_0 = MetallicSmoothnesTexture34;
			o.Metallic = temp_output_33_0.r;
			o.Smoothness = temp_output_33_0.r;
			o.Alpha = 1;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			clip( ( 1.0 - saturate( ( ( ase_vertex3Pos.z + _CrossSectionStartPoint ) / _CrossSectionDistribution ) ) ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
0;553;1370;457;2264.401;-928.2886;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;10;-1736.926,961.5362;Float;False;Property;_CrossSectionStartPoint;Cross Section Start Point;6;0;Create;True;0;0;False;0;0.75;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-1281.944,-340.0917;Inherit;True;Property;_EmissionTexture;Emission Texture;9;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;11;-1771.751,717.9649;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1419.213,762.6749;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-3351.899,937.6874;Inherit;False;Property;_MetalicSmoothnessValue;MetalicSmoothness Value;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1670.208,1081.926;Float;False;Property;_CrossSectionDistribution;Cross Section Distribution;7;0;Create;True;0;0;False;0;1;0;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-1265.944,-84.09171;Inherit;True;Property;_AlbedoTexture;Albedo Texture;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-977.9437,-340.0917;Inherit;False;EmissionTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;37;-3639.899,809.6874;Inherit;True;Property;_MetallicTexture;Metallic Texture;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-977.9437,-84.09171;Inherit;False;AlbedoTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;28;-561.8135,35.32167;Inherit;False;Property;_EmissionColor;Emission Color;10;0;Create;True;0;0;False;0;0.5754717,0.5754717,0.5754717,0;0.5754717,0.5754717,0.5754717,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;31;-300.0347,-56.28118;Inherit;False;19;EmissionTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-3191.899,825.6874;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-1291.309,983.1259;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-538.8403,-114.7564;Inherit;False;22;AlbedoTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-478.2267,244.2007;Inherit;False;Property;_EmissionPower;EmissionPower;11;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-223.0318,63.29275;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-3047.899,841.6874;Inherit;False;MetallicSmoothnesTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-547.1246,-336.9403;Inherit;False;Property;_AlbedoTint;Albedo Tint;3;0;Create;True;0;0;False;0;0.5754717,0.5754717,0.5754717,0;0.5754717,0.5754717,0.5754717,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;17;-3500.808,-239.0469;Inherit;False;991.39;590.1062;Comment;5;5;3;6;9;7;TEST1;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;15;-991.3829,907.1822;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-539.649,-43.11861;Inherit;False;23;NormalTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;3;-3426.05,122.026;Inherit;False;Property;_PlanePosition;_PlanePosition;5;0;Create;True;0;0;False;0;0,0,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;5;-3450.808,-105.2381;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;9;-3043.645,172.0593;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-977.9437,139.9083;Inherit;False;NormalTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-197.095,170.8734;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-242.321,274.2925;Inherit;False;34;MetallicSmoothnesTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-782.9625,254.9645;Inherit;False;19;EmissionTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;16;-793.2943,928.7587;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;-3030.961,-189.0469;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;7;-2744.418,39.87933;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-136.993,-188.9459;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;21;-1265.944,139.9083;Inherit;True;Property;_NormalTexture;Normal Texture;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;161.2,-16.9;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SurgerySim/CrossSectionTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;TransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;11;3
WireConnection;13;1;10;0
WireConnection;19;0;18;0
WireConnection;22;0;20;0
WireConnection;35;0;37;0
WireConnection;35;1;36;0
WireConnection;14;0;13;0
WireConnection;14;1;12;0
WireConnection;32;0;31;0
WireConnection;32;1;28;0
WireConnection;34;0;35;0
WireConnection;15;0;14;0
WireConnection;23;0;21;0
WireConnection;30;0;32;0
WireConnection;30;1;29;0
WireConnection;16;0;15;0
WireConnection;6;0;5;0
WireConnection;6;1;3;2
WireConnection;7;0;6;0
WireConnection;7;1;9;2
WireConnection;27;0;24;0
WireConnection;27;1;1;0
WireConnection;0;0;27;0
WireConnection;0;2;30;0
WireConnection;0;3;33;0
WireConnection;0;4;33;0
WireConnection;0;10;16;0
ASEEND*/
//CHKSM=259E226DB90418FDF02AC67D7FDB0B21F92E8E1E
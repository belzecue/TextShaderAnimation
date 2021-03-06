﻿Shader "Custom/TextMoveAnimation(Legacy)" {
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
			_NormalTime("NormalizationTime", Float) = 0
		_TextCount("TextCount", Int) = 1
		[MaterialToggle] PixelSnap("Pixel snap", Float) = 1
	}

		SubShader
	{

		Cull Back
		Lighting Off
		AlphaToMask On

		Pass
	{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma multi_compile PIXELSNAP_ON
#include "UnityCG.cginc"

		struct appdata_t
	{
		float4 vertex   : POSITION;
		float4 color    : COLOR;
		float2 texcoord : TEXCOORD0;
	};

	struct v2f
	{
		float4 pos   : SV_POSITION;
		fixed4 color : COLOR;
		half2 texcoord  : TEXCOORD0;
	};

	fixed4 _Color;
	int _TextCount;
	float _NormalTime;

	float4 TransportInterval(float4 pos) {
		pos.x -= 50 * (abs(_SinTime.z) + 1) * _NormalTime;
		return pos;
	}

	v2f vert(appdata_t IN)
	{
		v2f OUT;
		float4 pos = TransportInterval(IN.vertex);
		OUT.pos = UnityObjectToClipPos(pos);
		OUT.texcoord = IN.texcoord;
		OUT.color = _Color;
		return OUT;
	}

	sampler2D _MainTex;

	fixed4 frag(v2f IN) : SV_Target
	{
		fixed4 c = tex2D(_MainTex, IN.texcoord);
	c.rgb = IN.color;
	c.rgb *= c.a;
	return c;
	}
		ENDCG
	}
	}
	Fallback "GUI/Text Shader"
}

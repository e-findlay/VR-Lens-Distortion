Shader "Unlit/PixelPreDistort"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _C1 ("c1",Float) = -0.4
        _C2 ("c2",Float) = 0.3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _C1;
            float _C2;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = 2.0f*i.uv - float2(1.0f,1.0f);
                float r = length(float2(uv.x,uv.y));
                float theta = atan2(uv.y,uv.x);
                float f = r + _C1 * pow(r,3) + _C2 * pow(r,5);
                float x = 0.5f*(f*cos(theta)+1.0f);
                float y = 0.5f*(f*sin(theta)+1.0f);
                fixed4 col = tex2D(_MainTex, float2(x,y));
                return col;
            }
            ENDCG
        }
    }
}

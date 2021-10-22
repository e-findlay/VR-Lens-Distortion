Shader "Unlit/LCA"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _C1 ("c1r",Float) = 5.0
        _C2 ("c2r",Float) = 1.0
        _C1g ("c1g",Float) = 5.0
        _C2g ("c2g",Float) = 2.0
        _C1b ("c1b",Float) = 9.0
        _C2b ("c2b",Float) = 0.1

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
            float _C1g;
            float _C2g;
            float _C1b;
            float _C2b;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = 2.0f * i.uv - float2(1.0f,1.0f);
                float r = length(float2(uv.x,uv.y));
                float theta = atan2(uv.y,uv.x);
                float f_num = _C1 *pow(r,2) + _C2*pow(r,4) + _C1*_C1* pow(r,4) + _C2*_C2*pow(r,8) + _C1*_C2 * pow(r,6);
                float f_denom = 1.0f + 4.0f*_C1*r + 6.0f*_C2*pow(r,2);
                float f_r = f_num/f_denom;
                float x_r = 0.5f*(f_r*cos(theta)+1.0f);
                float y_r = 0.5f*(f_r*sin(theta)+1.0f);
                f_num = _C1g *pow(r,2) + _C2g*pow(r,4) + _C1g*_C1g* pow(r,4) + _C2g*_C2g*pow(r,8) + _C1g*_C2g * pow(r,6);
                f_denom = 1.0f + 4.0f*_C1g*r + 6.0f*_C2g*pow(r,2);
                float f_g = f_num/f_denom;
                float x_g = 0.5f*(f_g*cos(theta)+1.0f);
                float y_g = 0.5f*(f_g*sin(theta)+1.0f);
                f_num = _C1b *pow(r,2) + _C2b*pow(r,4) + _C1b*_C1b* pow(r,4) + _C2b*_C2b*pow(r,8) + _C1b*_C2b * pow(r,6);
                f_denom = 1.0f + 4.0f*_C1b*r + 6.0f*_C2b*pow(r,2);
                float f_b = f_num/f_denom;
                float x_b = 0.5f*(f_b*cos(theta)+1.0f);
                float y_b = 0.5f*(f_b*sin(theta)+1.0f);
                float red = tex2D(_MainTex, float2(x_r,y_r)).r;
                float green = tex2D(_MainTex, float2(x_g,y_g)).g;
                float blue = tex2D(_MainTex, float2(x_b,y_b)).b;
                return fixed4(red,green,blue,1);
            }
            ENDCG
        }
    }
}

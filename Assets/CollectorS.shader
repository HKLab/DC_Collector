Shader "Collector/CollectorS"
{
    Properties
    {
         _MainTex ("Texture", 2D) = "white" {}
        _SColor ("Src Color", Color) = (1,1,1,1)
        _DColor ("Dst Color", Color) = (1,1,1,1)
        _Color ("Color", Color) = (1,1,1,1)
        _AColor ("AColor", Color) = (0,0,0,0)
        _MPos ("MPos", Vector) = (0,0,0)
    }
    SubShader
    {
        Tags { "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" "CanUseSpriteAtlas"="true" "PreviewType"="Plane" }
        // No culling or depth
        ZWrite Off
        Cull Off

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
            
            float3 _MPos;

            v2f vert (appdata v)
            {
                v.vertex.xyz = v.vertex.xyz + _MPos.xyz;
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            fixed4 _SColor;
            fixed4 _DColor;
            fixed4 _Color;
            fixed3 _AColor;
            

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed s = clamp(ceil(abs(col.r - _SColor.r) + 
                    abs(col.g - _SColor.g) + abs(col.b - _SColor.b) +
                    abs(col.a - _SColor.a)), 0, 1);
                col = col * s + _DColor * (1 - s);
                col = col * _Color;
                col.rgb = col.rgb + _AColor.rgb;
                clip(col.a - 0.01);
                
                return col;
            }
            ENDCG
        }
    }
}

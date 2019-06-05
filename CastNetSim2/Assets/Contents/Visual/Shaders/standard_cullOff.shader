Shader "Custom/standard_cullOff_cutout" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
    _Cutoff ("Cutoff" , Range(0, 1)) = 0.5     // <== 追加.
    _NormalMapIntensity ("Normal Intensity", Float) = 1  
    _NormalMap("Normal Map", 2D) = "bump" {}
    _Glossiness ("Smoothness", Range(0,1)) = 0.5
    _Metallic ("Metallic", Range(0,1)) = 0.0
  }
  SubShader {
    Tags { "Queue"="AlphaTest" "RenderType"="TransparentCutout" } // <== 変更.
    LOD 200
    Cull Off
    
    CGPROGRAM
    // Physically based Standard lighting model, and enable shadows on all light types
    #pragma surface surf Standard fullforwardshadows alphatest:_Cutoff  // <== alphatest:_Cutoff 追加.

    // Use shader model 3.0 target, to get nicer looking lighting
    #pragma target 3.0

    sampler2D _MainTex;
    sampler2D _NormalMap;

    struct Input {
      float2 uv_MainTex;
    };

    half _Glossiness;
    half _Metallic;
    fixed4 _Color;
    half _NormalMapIntensity;

    void surf (Input IN, inout SurfaceOutputStandard o) {
      // Albedo comes from a texture tinted by color
      fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
      o.Albedo = c.rgb;
      // Metallic and smoothness come from slider variables
      o.Metallic = _Metallic;
      o.Smoothness = _Glossiness;
      o.Alpha = c.a;

      o.Normal = lerp( float3(0,0,1), UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex)), _NormalMapIntensity);
    }
    ENDCG
  }
  FallBack "Transparent/Cutout/Diffuse"    //<== 変更.
}
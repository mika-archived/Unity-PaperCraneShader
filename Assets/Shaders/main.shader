/*-------------------------------------------------------------------------------------------
 * Copyright (c) Fuyuno Mikazuki / Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

Shader "Mochizuki/Example Shader"
{
    Properties
    {
        _CurrentFrame    ("Current Frame",    Range(0, 2)) = 0.0
        _Color           ("Color",            Color)       = (0.5, 0.5, 0.5, 1)
        _BackgroundColor ("Background Color", Color)       = (1, 1, 1, 1)
        _LineColor       ("Line Color",       Color)       = (0, 0, 0, 1)
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off

            CGPROGRAM

            #pragma target 5.0
            // enable DirectX debugger in Visual Studio
            #pragma enable_d3d11_debug_symbols
            #pragma multi_compile_fwdbase

            #pragma vertex   vs
            #pragma hull     hs
            #pragma domain   ds
            #pragma geometry gs
            #pragma fragment fs

            #include "UnityCG.cginc"

            #include "vendors/UCLA GameLab Wireframe Functions.cginc"
            #include "includes/PC_core.cginc"

            ENDCG
        }
        
        Pass
        {
            Tags { "LightMode" = "ShadowCaster" }

            ZWrite On ZTest LEqual

            CGPROGRAM

            #pragma target 5.0
            // enable DirectX debugger in Visual Studio
            #pragma enable_d3d11_debug_symbols
            #pragma multi_compile_shadowcaster

            #pragma vertex   vs
            #pragma hull     hs
            #pragma domain   ds
            #pragma geometry gs
            #pragma fragment fs

            #include "UnityCG.cginc"

            #define  PC_PASS_SHADOWCASTER

            #include "vendors/UCLA GameLab Wireframe Functions.cginc"
            #include "includes/PC_core.cginc"


            ENDCG
        }
    }

    Fallback "Diffuse"
}
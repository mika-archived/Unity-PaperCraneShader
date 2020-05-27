/*-------------------------------------------------------------------------------------------
 * Copyright (c) Fuyuno Mikazuki / Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

#if defined(SHADOWS_BOX) && !defined(SHADOWS_CUBE_IN_DEPTH_TEX)
#define PC_PASS_CUBE_SHADOWCASTER
#endif

uniform float  _CurrentFrame;
uniform float4 _Color;
uniform float4 _LineColor;

struct v2h {
    float4 position : POSITION;
    float3 normal   : NORMAL;
};

struct h2d_const {
    float edges[4]  : SV_TESSFACTOR;
    float inside[2] : SV_INSIDETESSFACTOR;
};

struct h2d {
    float3 position : POS;
    float3 normal   : NORMAL;
};

struct d2g {
    uint   id            : IDENTIFIER;
    float  tessellation  : TESSELLATION;
    float4 position      : POS;
};

struct g2f {
#if defined(PC_PASS_CUBE_SHADOWCASTER)
#elif defined(PC_PASS_SHADOWCASTER)
    V2F_SHADOW_CASTER;
#else
    uint   id       : IDENTIFIER;
    float3 distance : TEXCOORD;
    float4 position : POSITION;
#endif
};

#include "PC_vertex.cginc"
#include "PC_tessellation.cginc"
#include "PC_geometry.cginc"
#include "PC_fragment.cginc"

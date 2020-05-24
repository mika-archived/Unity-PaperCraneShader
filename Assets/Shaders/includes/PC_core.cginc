/*-------------------------------------------------------------------------------------------
 * Copyright (c) Fuyuno Mikazuki / Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

#define TESSELLATION 3

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
    uint   id       : IDENTIFIER;
    float4 position : POSITION;
};

struct g2f {
    float4 position : POSITION;
    float3 distance : TEXCOORD0;
};

#include "PC_vertex.cginc"
#include "PC_tessellation.cginc"
#include "PC_geometry.cginc"
#include "PC_fragment.cginc"

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*-------------------------------------------------------------------------------------------
 * Copyright (c) Fuyuno Mikazuki / Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "PC_core.cginc"

h2d_const hs_const()
{
    h2d_const o = (h2d_const) 0;
    const float tess = TESSELLATION + 1;
    o.edges[0]  = tess;
    o.edges[1]  = tess;
    o.edges[2]  = tess;
    o.edges[3]  = tess;
    o.inside[0] = tess;
    o.inside[1] = tess;

    return o;
}

[domain("quad")]
[partitioning("pow2")]
[outputtopology("triangle_cw")]
[outputcontrolpoints(4)]
[patchconstantfunc("hs_const")]
h2d hs(InputPatch<v2h, 4> input, uint id : SV_OUTPUTCONTROLPOINTID)
{
    h2d o = (h2d) 0;
    o.position = input[id].position.xyz;
    o.normal   = input[id].normal;

    return o;
}

[domain("quad")]
d2g ds(const h2d_const data, const OutputPatch<h2d, 4> i, const float2 uv : SV_DOMAINLOCATION)
{
    d2g o = (d2g) 0;

    const float3 x = lerp(i[0].position, i[1].position, uv.x);
    const float3 y = lerp(i[3].position, i[2].position, uv.x);
    const float3 z = lerp(x, y, uv.y);

    o.position      = float4(z, 1.0f);
    o.id            = (uint) (uv.x * TESSELLATION) + ((uint) ((uv.y * TESSELLATION) * TESSELLATION)) + (uint) (uv.y * TESSELLATION);

    return o;
}
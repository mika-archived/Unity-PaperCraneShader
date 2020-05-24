// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*-------------------------------------------------------------------------------------------
 * Copyright (c) Fuyuno Mikazuki / Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "PC_core.cginc"

h2d_const hs_const(const InputPatch<v2h, 4> i)
{
    const float tessTable[2] = {
        1.0f,
        2.0f,
    };
    
    const float tessellation = tessTable[(int) clamp(_CurrentFrame, 0.0f, 2.0f)];

    h2d_const o = (h2d_const) 0;
    o.edges[0]  = tessellation;
    o.edges[1]  = tessellation;
    o.edges[2]  = tessellation;
    o.edges[3]  = tessellation;
    o.inside[0] = tessellation;
    o.inside[1] = tessellation;

    return o;
}

[domain("quad")]
[partitioning("pow2")]
[outputtopology("point")]
[outputcontrolpoints(4)]
[patchconstantfunc("hs_const")]
h2d hs(const InputPatch<v2h, 4> input, const uint id : SV_OUTPUTCONTROLPOINTID)
{
    h2d o = (h2d) 0;
    o.position = input[id].position.xyz;
    o.normal   = input[id].normal;

    return o;
}

[domain("quad")]
d2g ds(const h2d_const data, const OutputPatch<h2d, 4> i, const float2 uv : SV_DOMAINLOCATION)
{
    const float3 x = lerp(i[0].position, i[1].position, uv.x);
    const float3 y = lerp(i[3].position, i[2].position, uv.x);
    const float3 z = lerp(x, y, uv.y);

    d2g o = (d2g) 0;
    o.tessellation  = data.edges[0];
    o.position      = float4(z, 1.0f);
    o.worldPosition = UnityObjectToClipPos(o.position); // for debugging
    o.id            = (uint) (uv.x * o.tessellation) + ((uint) ((uv.y * o.tessellation) * o.tessellation)) + (uint) (uv.y * o.tessellation);

    return o;
}
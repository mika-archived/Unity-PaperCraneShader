/*-------------------------------------------------------------------------------------------
 * Copyright (c) Fuyuno Mikazuki / Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "PC_core.cginc"

bool isSkipGenerateTriangleOfEdge(const float tessellation, const uint id)
{
    const float edge = tessellation + 1;
    return step(id, edge) == 1 || (id % edge == 0);
}

float3 distanceOf(const float3 distance, const int index)
{
    return float3(
        lerp(0, distance.x, 1 - abs(sign(index - 0))),
        lerp(0, distance.y, 1 - abs(sign(index - 1))),
        lerp(0, distance.z, 1 - abs(sign(index - 2)))
    );

    /*
    if (index == 0) {
        return float3(distance.x, 0, 0);
    } else if (index == 1) {
        return float3(0, distance.y, 0);
    } else {
        return float3(0, 0, distance.z);
    }
    */
}

void doStep1(const d2g i, const float lengthOfEdge, inout g2f o[6], inout uint count)
{
    const float rad = radians(_CurrentFrame * 180);

    const float3 vertex[6] = {
        // 
        float3(0.0f, 0.0f, 0.0f),
        float3(0.0f, 0.0f - lengthOfEdge, 0.0f),
        float3(0.0f + lengthOfEdge, 0.0f, 0.0f),
        // 
        float3(0.0f + lengthOfEdge, 0.0f - lengthOfEdge, 0.0f),
        float3(0.0f + lengthOfEdge, 0.0f, 0.0f),
        float3(0.0f, 0.0f - lengthOfEdge, 0.0f),
    };

    [unroll]
    for (int j = 0; j < 3; j++)
    {
        o[j].id  = i.id * 10 + j;
        o[j].position = UnityObjectToClipPos(i.position.xyz + vertex[j]);
    }

    [unroll]
    for (int k = 3; k < 6; k++)
    {
        o[k].id = i.id * 10 + k;

        const float3 vert = vertex[k];

        const float x = lerp(vert.x, vert.x - lerp(0, lengthOfEdge, _CurrentFrame), 1 - abs(sign(k - 3)));
        const float y = lerp(vert.y, vert.y + lerp(0, lengthOfEdge, _CurrentFrame), 1 - abs(sign(k - 3)));
        const float z = lerp(vert.z, vert.z + sqrt(x * x + y * y) * sin(rad), 1 - abs(sign(k - 3)));
            
        o[k].position = UnityObjectToClipPos(i.position.xyz + float3(x, y, z));
    }
}

void doStep2(const d2g i, const float lengthOfEdge, inout g2f o[6], inout uint count)
{

}

[maxvertexcount(6)]
void gs(const point d2g IN[1], inout TriangleStream<g2f> stream)
{
    const d2g i = IN[0];

    if (isSkipGenerateTriangleOfEdge(i.tessellation, i.id)) {
        return;
    }

    const float tessellation = i.tessellation;
    const float lengthOfEdge = 0.02f / tessellation;

    g2f o[6] = {
        (g2f) 0,
        (g2f) 0,
        (g2f) 0,
        (g2f) 0,
        (g2f) 0,
        (g2f) 0,
    };

    // Post Direct3D10, static uniform branches have little performance impact.
    // ref: https://stackoverflow.com/questions/37827216/do-conditional-statements-slow-down-shaders
    //
    // But well, it's best not to use it.
    //
    // Question: Could this be classified as a static branch?
    const uint step = (int) clamp(_CurrentFrame, 0.0f, 2.0f);
    uint loops = 6;

    if (step == 0) 
    {
        doStep1(i, lengthOfEdge, o, loops);
    }
    else if (step == 1)
    {
        doStep2(i, lengthOfEdge, o, loops);
    }


    for (uint j = 1; j <= loops; j++)
    {
        stream.Append(o[j - 1]);
            
        if (j % 3 == 0)
        {
            stream.RestartStrip();
        }
    }
}
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
}

void doStep1(const d2g i, const float lengthOfEdge, inout g2f o[6], inout uint count)
{
    const float frame = _CurrentFrame;
    const float rad   = radians(frame * 180);

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
    for (uint j = 0; j < 6; j++)
    {
        const float3 vert = vertex[j];

        const float x = lerp(vert.x, vert.x - lerp(0, lengthOfEdge, frame), 1 - abs(sign(j - 3)));
        const float y = lerp(vert.y, vert.y + lerp(0, lengthOfEdge, frame), 1 - abs(sign(j - 3)));
        const float z = lerp(vert.z, vert.z + sqrt(x * x + y * y) * sin(rad), 1 - abs(sign(j - 3)));

        o[j].id = i.id * 10 + j;
        o[j].position = UnityObjectToClipPos(i.position.xyz + float3(x, y, z));
    }
}

void doStep2(const d2g i, const float lengthOfEdge, inout g2f o[6], inout uint count)
{
    const float frame = _CurrentFrame - 1.0f;
    const float rad   = radians(frame * 180);

    const float3 vertex[12] = {
        // triangle 1
        float3(0.0f, 0.0f, 0.0f),
        float3(0.0f, 0.0f - lengthOfEdge, 0.0f),
        float3(0.0f + lengthOfEdge, 0.0f, 0.0f),
        // triangle 2
        float3(0.0f, 0.0f, 0.0f),
        float3(0.0f, 0.0f - lengthOfEdge, 0.0f),
        float3(0.0f + lengthOfEdge, 0.0f, 0.0f),
        // square
        float3(0.0f, 0.0f, 0.0f),
        float3(0.0f + lengthOfEdge, 0.0f - lengthOfEdge, 0.0f),
        float3(0.0f + lengthOfEdge, 0.0f, 0.0f),
        float3(0.0f, 0.0f, 0.0f),
        float3(0.0f + lengthOfEdge, 0.0f - lengthOfEdge, 0.0f),
        float3(0.0f, 0.0f - lengthOfEdge, 0.0f),
    };

    // WORKAROUND: In HLSL, `round(x)` (where x is 0.5f) is specifed to return 0.
    const uint a = (uint) round(abs(i.position.x * 100.0f) / i.tessellation + 0.1f);
    const uint b = (uint) round(abs(i.position.y * 100.0f) / i.tessellation + 0.1f);

    // Perhaps the fact that dynamically determining the number of loops here could cause performance problems.
    count = (a + b) * 3;

    [unroll]
    for (uint j = 0; j < count; j++)
    {
        const float c = lengthOfEdge;
        const uint k = count == 6 ? j + 6 : (a == 1 ? j + 3 : j);
        const float3 vert = vertex[k];

        float x = 0.0f; // vert.x;
        float y = 0.0f; // vert.y;
        float z = 0.0f; // vert.z;


        // curve square's triangle
        x += lerp(0.0f, 0.0f - lerp(0, lengthOfEdge, frame),   1 - abs(sign(k - 8)));
        y += lerp(0.0f, 0.0f - lerp(0, lengthOfEdge, frame),   1 - abs(sign(k - 8)));
        z += lerp(0.0f, 0.0f + sqrt(x * x + y * y) * sin(rad), 1 - abs(sign(k - 8)));

        // curve triangle
        x += lerp(0.0f, 0.0f - lerp(0, lengthOfEdge * 2, frame), 1 - abs(sign(k - 2)));
        y += lerp(0.0f, 0.0f - lerp(0, lengthOfEdge * 2, frame), 1 - abs(sign(k - 2)));
        z += lerp(0.0f, 0.0f + sqrt(pow(c, 2) * 2) * sin(rad),   1 - abs(sign(k - 2)));

        // curve triangle
        x += lerp(0.0f, 0.0f - lerp(0, lengthOfEdge, frame),   1 - abs(sign(k)));
        y += lerp(0.0f, 0.0f - lerp(0, lengthOfEdge, frame),   1 - abs(sign(k)));
        z += lerp(0.0f, 0.0f + sqrt(x * x + y * y) * sin(rad), 1 - abs(sign(k)));

        o[j].id = i.id * 10 + j;
        o[j].position = UnityObjectToClipPos(i.position.xyz + float3(vert.x + x, vert.y + y, vert.z + z));
    }
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
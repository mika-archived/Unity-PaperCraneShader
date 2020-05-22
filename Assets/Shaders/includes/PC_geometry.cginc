/*-------------------------------------------------------------------------------------------
 * Copyright (c) Fuyuno Mikazuki / Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "./core.cginc"

float3 calcDistance(float3 distance, int index)
{
    if (index == 0) {
        return float3(distance.x, 0, 0);
    } else if (index == 1) {
        return float3(0, distance.y, 0);
    } else {
        return float3(0, 0, distance.z);
    }
}

[maxvertexcount(3)]
void gs(triangle d2g IN[3], inout TriangleStream<g2f> stream)
{
    /*
    d2g i = IN[0];

    // Step.1 (0 ~ 1)
    // Quad を三角形に折りたたむ
    const float u = 1.0f / 16;
    const float v = 1.0f / 16;

    float x = (i.id / 16) / 16.0f - 0.5f;
    float y = (i.id % 16) / 16.0f - 0.5f;
    bool r = i.id % 2 == 1;

    g2f o[3] = {
        (g2f) 0,
        (g2f) 0,
        (g2f) 0,
    };

    float3 vertex[3] = {
        float3(x + 0, y + 0, 0),
        float3(x + u, y + 0, 0),
        float3(x + u, y + v, 0),
    };

    [unroll]
    for (int j = 0; j < 3; j++)
    {
        o[j].position = UnityObjectToClipPos(vertex[j]);
    }

    float3 distance = UCLAGL_CalculateDistToCenter(o[0].position, o[1].position, o[2].position);

    [unroll]
    for (int k = 0; k < 3; k++)
    {
        o[k].distance = calcDistance(distance, k);

        stream.Append(o[k]);
    }

    stream.RestartStrip();
    */
    
    g2f o = (g2f) 0;

    float4 p1 = UnityObjectToClipPos(IN[0].position); // mul(unity_ObjectToWorld, IN[0].position);
    float4 p2 = UnityObjectToClipPos(IN[1].position); // mul(unity_ObjectToWorld, IN[1].position);
    float4 p3 = UnityObjectToClipPos(IN[2].position); // mul(unity_ObjectToWorld, IN[2].position);

    float3 distance = UCLAGL_CalculateDistToCenter(p1, p2, p3);

    if (0 <= _CurrentFrame && _CurrentFrame <= 1)
    {
        [unroll]
        for (int i = 0; i < 3; i++)
        {
            // float angle = _CurrentFrame * 90.0f;
            // float3 normal = normalize(IN[i].normal);

            o.position = UnityObjectToClipPos(IN[i].position);
            o.distance = calcDistance(distance, i);

            stream.Append(o);
        }
    }
    
    stream.RestartStrip();

    // Phase B

    // Phase C
}
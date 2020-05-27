/*-------------------------------------------------------------------------------------------
 * Copyright (c) Fuyuno Mikazuki / Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "PC_core.cginc"

// 16x16=256 to 256 colors
float4 idToColor(const uint id)
{
    const uint rMask = 0xF800;
    const uint gMask = 0x07E0;
    const uint bMask = 0x001F;

    const uint rValue = (id & rMask) >> 11;
    const uint gValue = (id & gMask) >> 5;
    const uint bValue = (id & bMask);

    const uint /* ubyte */ r = rValue << 3;
    const uint /* ubyte */ g = gValue << 2;
    const uint /* ubyte */ b = bValue << 3;

    return float4(r / 0xFF, g / 0xFF, b / 0xFF, 1.0f);
}

#if defined(PC_PASS_CUBE_SHADOWCASTER)

float4 fs(const g2f data) : SV_TARGET
{
    return 0; // TO-DO
}

#elif defined(PC_PASS_SHADOWCASTER)

float4 fs(const g2f data) : SV_TARGET
{
    SHADOW_CASTER_FRAGMENT(data)
}

#else

float4 fs(const g2f data) : SV_TARGET
{
    float alpha = UCLAGL_GetWireframeAlpha(data.distance, 1, 1, 1);
    float4 color = _Color;
    color.a *= alpha;

    if (color.a < 0.5f) {
        color = idToColor(data.id);
        color.a = 0.5f;
    } else {
        color.a = 1.0f;
    }

    return color;
}

#endif
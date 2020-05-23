/*-------------------------------------------------------------------------------------------
 * Copyright (c) Fuyuno Mikazuki / Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "PC_core.cginc"

fixed4 fs(g2f data) : SV_Target
{
    float alpha = UCLAGL_GetWireframeAlpha(data.distance, 1, 1, 1);
    float4 color = _LineColor * _Color;
    color.a *= alpha;

    if (color.a < 0.5f) {
        color.a = 0.1f;
    } else {
        color.a = 1.0f;
    }

    return color;
}
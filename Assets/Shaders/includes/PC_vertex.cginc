/*-------------------------------------------------------------------------------------------
 * Copyright (c) Fuyuno Mikazuki / Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "PC_core.cginc"

v2h vs(const appdata_full data)
{
    v2h o = (v2h) 0;
    o.position = data.vertex;
    o.normal = data.normal;

    return o;
}

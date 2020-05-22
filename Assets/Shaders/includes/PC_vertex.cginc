/*-------------------------------------------------------------------------------------------
 * Copyright (c) Fuyuno Mikazuki / Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

v2h vs(appdata_full data)
{
    v2h o = (v2h) 0;
    o.position = data.vertex;
    o.normal = data.normal;

    return o;
}

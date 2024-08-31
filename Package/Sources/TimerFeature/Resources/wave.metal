//
//  wave.metal
//
//
//  Created by Shunya Yamada on 2024/07/13.
//

#include <metal_stdlib>
using namespace metal;

/// wave effect shader
/// - seealso: https://github.com/twostraws/Inferno/blob/main/Sources/Inferno/Shaders/Transformation/Water.metal
[[ stitchable ]] float2 wave(float2 position, float2 size, float time, float speed, float strength, float frequency) {
    // Calculate our coordinate in UV space, 0 to 1.
    half2 uv = half2(position / size);

    // Bring both speed and strength into the kinds of
    // ranges we need for this effect.
    half adjustedSpeed = time * speed * 0.05h;
    half adjustedStrength = strength / 100.0h;

    // Offset the coordinate by a small amount in each
    // direction, based on wave frequency and wave strength.
    uv.x += sin((uv.x + adjustedSpeed) * frequency) * adjustedStrength;
    uv.y += cos((uv.y + adjustedSpeed) * frequency) * adjustedStrength;

    // Bring the position back up to user-space coordinates.
    return float2(uv) * size;
}

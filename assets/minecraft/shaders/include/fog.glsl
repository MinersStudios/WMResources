#version 150

vec4 linear_fog(
        vec4 inColor,
        float vertexDistance,
        float fogStart,
        float fogEnd,
        vec4 fogColor
) {
    if (vertexDistance <= fogStart) return inColor;

    float fogValue =
            vertexDistance < fogEnd
            ? smoothstep(fogStart, fogEnd, vertexDistance)
            : 1.0;

    return vec4(
        mix(
            inColor.rgb,
            fogColor.rgb,
            fogValue * fogColor.a
        ),
        inColor.a
    );
}

float linear_fog_fade(
        float vertexDistance,
        float fogStart,
        float fogEnd
) {
    return vertexDistance <= fogStart ? 1.0
            : vertexDistance >= fogEnd ? 0.0
            : smoothstep(fogEnd, fogStart, vertexDistance);
}

float fog_distance(
        mat4 modelViewMat,
        vec3 pos,
        int shape
) {
    if (shape==0) return length((modelViewMat * vec4(pos, 1.0)).xyz);

    float distXZ = length((modelViewMat * vec4(pos.x, 0.0, pos.z, 1.0)).xyz);
    float distY = length((modelViewMat * vec4(0.0, pos.y, 0.0, 1.0)).xyz);

    return max(distXZ, distY);
}

float cylindrical_distance(
        mat4 modelViewMat,
        vec3 pos
) {
    float distXZ = length((modelViewMat * vec4(pos.x, 0.0, pos.z, 1.0)).xyz);
    float distY = length((modelViewMat * vec4(0.0, pos.y, 0.0, 1.0)).xyz);

    return max(distXZ, distY);
}

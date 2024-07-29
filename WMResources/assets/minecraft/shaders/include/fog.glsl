#version 150

vec4 linear_fog(
        vec4 inColor,
        float vertexDistance,
        float fogStart,
        float fogEnd,
        vec4 fogColor
) {
        return vertexDistance <= fogStart
                ? inColor
                : vec4(
                        mix(
                                inColor.rgb,
                                fogColor.rgb,
                                (
                                        vertexDistance < fogEnd
                                        ? smoothstep(fogStart, fogEnd, vertexDistance)
                                        : 1
                                ) * fogColor.a
                        ),
                        inColor.a
                );
}

float linear_fog_fade(
        float vertexDistance,
        float fogStart,
        float fogEnd
) {
        return vertexDistance <= fogStart ? 1
                : vertexDistance >= fogEnd ? 0
                : smoothstep(fogEnd, fogStart, vertexDistance);
}

float fog_distance(
        vec3 pos,
        int shape
) {
        return shape == 0
                ? length(pos)
                : max(
                        length(pos.xz),
                        abs(pos.y)
                );
}

float cylindrical_distance(
        mat4 modelViewMat,
        vec3 pos
) {
        return max(
                        length((modelViewMat * vec4(pos.x, 0, pos.z, 1)).xyz),
                        length((modelViewMat * vec4(0, pos.y, 0, 1)).xyz)
                );
}

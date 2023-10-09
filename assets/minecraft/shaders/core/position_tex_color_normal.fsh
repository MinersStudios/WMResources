#version 150

#moj_import <fog.glsl>

#define FOG_START 200
#define FOG_END 300

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;

in vec2 texCoord0;
in float vertexDistance;
in vec4 vertexColor;
in vec4 normal;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;

    if (color.a < .1) discard;

    fragColor = color
                * vec4(
                        1, 1, 1,
                        1 - (
                                vertexDistance > FOG_START
                                ? vertexDistance < FOG_END
                                ? smoothstep(FOG_START, FOG_END, vertexDistance)
                                : 1
                                : 0
                        )
                )
                * vec4(1, 1, 1, .75);
}
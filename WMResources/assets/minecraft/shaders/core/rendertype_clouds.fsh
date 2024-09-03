#version 150

#moj_import <fog.glsl>

#define START 5.0
#define END   30.0

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;

in vec2 texCoord0;
in float vertexDistance;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;

    if (color.a < 0.1) {
        discard;
    }

    fragColor = color
                * vec4(1.0, 1.0, 1.0, 1.0 - linear_fog_grow(vertexDistance, START, END))
                * vec4(1.0, 1.0, 1.0, 0.75);
}

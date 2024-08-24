#version 150

#moj_import <fog.glsl>
#moj_import <item.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;

in vec2 texCoord0;
in vec2 texCoord1;

flat in int isInGui;
flat in float posZ;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;

    if (color.a < 0.1) {
        discard;
    }

	float alpha = textureLod(Sampler0, texCoord0, 0.0).a;

    if (isInGui == 1) {
        if (is_hand(alpha, posZ)) {
            discard;
        } else if (is_gui(alpha, posZ)) {
            discard;
        }
    } else if (alpha == GUI_ALPHA) {
        discard;
    }

    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}

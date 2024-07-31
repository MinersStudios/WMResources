#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform vec4 FogColor;

uniform float FogStart;
uniform float FogEnd;

in float vertexDistance;
in float overlayValue;

in vec4 baseColor;
in vec4 overlayColor;

in vec2 baseCoord;
in vec2 overlayCoord;

out vec4 fragColor;

void main() {
    vec4 base = texture(Sampler0, baseCoord);
    vec4 overlay = texture(Sampler0, overlayCoord);
    vec4 blendedColor =
            mix(
                    base * baseColor,
                    overlay * overlayColor,
                    overlay.w * overlayValue
            ) * ColorModulator;

    if (blendedColor.w < 0.1) {
        discard;
    }

    fragColor = linear_fog(blendedColor, vertexDistance, FogStart, FogEnd, FogColor);
}

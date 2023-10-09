#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in float overlayValue;
in vec4 diffuseColor;
in vec4 normal;
in vec2 texCoord0;
in vec2 overlayCoord;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, overlayCoord);
    vec4 baseTexture = texture(Sampler0, texCoord0);
    vec4 blendedColor = mix(baseTexture * vertexColor, color * diffuseColor, color.w * overlayValue) * ColorModulator;

    if (blendedColor.w < .1) discard;

    fragColor = linear_fog(blendedColor, vertexDistance, FogStart, FogEnd, FogColor);
}
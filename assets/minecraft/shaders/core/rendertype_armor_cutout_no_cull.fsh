#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in float ov;
in vec4 vertexColor;
in vec4 diffuseColor;
in vec4 normal;
in vec2 texCoord0;
in vec2 overlayCoord;

out vec4 fragColor;

void main() {
    vec4 o = texture(Sampler0, overlayCoord);
    vec4 v = mix(texture(Sampler0, texCoord0) * vertexColor, o * diffuseColor, o.w * ov) * ColorModulator;
    if (v.w < 0.1) discard;
    fragColor = linear_fog(v, vertexDistance, FogStart, FogEnd, FogColor);
}
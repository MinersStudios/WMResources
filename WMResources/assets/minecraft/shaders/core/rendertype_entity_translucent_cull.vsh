#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

in vec3 Position;
in vec4 Color;
in vec3 Normal;

in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;

out float vertexDistance;
out vec4 vertexColor;

out vec2 texCoord0;
out vec2 texCoord1;

flat out int isInGui;
flat out float posZ;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(Position, FogShape);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color) * texelFetch(Sampler2, UV2 / 16, 0);

    texCoord0 = UV0;
    texCoord1 = UV1;

    isInGui = int(ProjMat[3][3] != 0.0);
    posZ = Position.z;
}

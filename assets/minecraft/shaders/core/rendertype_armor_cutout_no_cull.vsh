#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

#define N (1.0  /  2.0)

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out float ov;
out vec4 vertexColor;
out vec4 diffuseColor;
out vec4 normal;
out vec2 texCoord0;
out vec2 overlayCoord;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = cylindrical_distance(ModelViewMat, Position);

    vec4 v = Color;
    vec2 r = UV0;
    vec2 o = UV0;

    ov = 0.0;

    if (Color.x < 1.0 && textureSize(Sampler0, 0).x > 64){
        ov = 1.0;
        r.x *= 0.5;
        v = vec4(1.0);

        if (Color.xyz == vec3(239.0, 193.0, 66.0) / 255.0) r.y = r.y * N + 1.0 * N;
        else if (Color.xyz == vec3(0.0, 0.0, 0.0) / 255.0) r.y = r.y * N + 2.0 * N;
        else v = Color, r.y = r.y * N;

        o = r + vec2(0.5, 0.0);
    }

    vec4 l = texelFetch(Sampler2, UV2 / 16, 0);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, v) * l;
    diffuseColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, vec4(1.0)) * l;
    texCoord0 = r;
    overlayCoord = o;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
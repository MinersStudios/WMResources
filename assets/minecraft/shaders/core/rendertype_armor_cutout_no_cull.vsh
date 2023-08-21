#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

#define N (1.0 / 2.0)
#define HAZMAT_COLOR vec3(239.0, 193.0, 66.0) / 255.0
#define ABSOLUTE_BLACK_COLOR vec3(0.0)

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

out float vertexDistance;
out float overlayValue;
out vec4 vertexColor;
out vec4 diffuseColor;
out vec4 normal;
out vec2 texCoord0;
out vec2 overlayCoord;

vec4 calculateLight(
        vec3 lightDir,
        vec3 normal,
        vec4 color,
        sampler2D lightMap
) {
    vec4 light = texelFetch(lightMap, UV2 / 16, 0);
    return minecraft_mix_light(Light0_Direction, Light1_Direction, normal, color) * light;
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = cylindrical_distance(ModelViewMat, Position);

    vec4 finalColor = Color;
    vec2 texCoordR = UV0;
    vec2 overlayCoordO = UV0;
    vec4 diffuseColor0 = vec4(-1.0);

    overlayValue = 0.0;

    if (Color.x < 1.0 && textureSize(Sampler0, 0).x > 64) {
        overlayValue = 1.0;
        texCoordR.x *= 0.5;
        finalColor = vec4(1.0);

        if (Color.xyz == HAZMAT_COLOR) {
            texCoordR.y = texCoordR.y * N + 1.0 * N;
        } else if (Color.xyz == ABSOLUTE_BLACK_COLOR) {
            finalColor = Color;
            texCoordR.y = texCoordR.y * N;
            diffuseColor0 = Color;
        } else {
            finalColor = Color;
            texCoordR.y = texCoordR.y * N;
        }

        overlayCoordO = texCoordR + vec2(0.5, 0.0);
    }

    vertexColor = calculateLight(Light0_Direction, Normal, finalColor, Sampler2);
    diffuseColor =
                diffuseColor0 == -1.0
                ? calculateLight(Light0_Direction, Normal, vec4(1.0), Sampler2)
                : diffuseColor0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
    texCoord0 = texCoordR;
    overlayCoord = overlayCoordO;
}

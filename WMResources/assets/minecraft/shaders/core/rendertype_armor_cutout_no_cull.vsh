#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>
#moj_import <armor.glsl>

#define N (1.0 / ARMOR_TYPE_COUNT)

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
    return minecraft_mix_light(Light0_Direction, Light1_Direction, normal, color)
           * texelFetch(lightMap, UV2 / 16, 0);
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = cylindrical_distance(ModelViewMat, Position);

    vec4 finalVertex = Color;
    vec4 finalDiffuse = vec4(1.0);
    vec2 texCoordR = UV0;
    vec2 overlayCoordO = UV0;

    if (Color.x < 1.0) {
        overlayValue = 1.0;
        texCoordR.x *= 0.5;
        texCoordR.y = texCoordR.y * N;

        for (int i = 0; i < ARMOR_TYPE_COUNT; ++i) {
            Armor armor = ARMOR_TYPES[i];

            if (Color.xyz == armor.color) {
                texCoordR.y += i * N;

                if (!armor.tintVertex) {
                    finalVertex = vec4(1.0);
                }

                if (armor.tintDiffuse) {
                    finalDiffuse = Color;
                }

                break;
            }
        }

        overlayCoordO = texCoordR + vec2(0.5, 0.0);
    } else {
        overlayValue = 0.0;
    }

    vertexColor = calculateLight(Light0_Direction, Normal, finalVertex, Sampler2);
    diffuseColor = calculateLight(Light0_Direction, Normal, finalDiffuse, Sampler2);
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
    texCoord0 = texCoordR;
    overlayCoord = overlayCoordO;
}

#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

struct Armor {
    vec3 color;
    bool tintVertex;
    bool tintDiffuse;
};

#define BLANK        Armor(vec3(0),                  true,  true)
#define HAZMAT_COLOR Armor(vec3(239, 193, 66) / 255, false, false)

#define ARMOR_TYPES Armor[] (BLANK, HAZMAT_COLOR)
#define TYPE_COUNT  ARMOR_TYPES.length()
#define N           (1. / TYPE_COUNT)

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
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1);
    vertexDistance = cylindrical_distance(ModelViewMat, Position);

    vec4 finalVertex = Color;
    vec4 finalDiffuse = vec4(1);
    vec2 texCoordR = UV0;
    vec2 overlayCoordO = UV0;

    if (Color.x < 1) {
        overlayValue = 1;
        texCoordR.x *= .5;
        texCoordR.y = texCoordR.y * N;

        for (int i = 0; i < TYPE_COUNT; i++) {
            Armor armor = ARMOR_TYPES[i];

            if (Color.xyz == armor.color) {
                texCoordR.y += i * N;

                if (!armor.tintVertex) {
                    finalVertex = vec4(1);
                }

                if (armor.tintDiffuse) {
                    finalDiffuse = Color;
                }

                break;
            }
        }

        overlayCoordO = texCoordR + vec2(.5, 0);
    } else {
        overlayValue = 0;
    }

    vertexColor = calculateLight(Light0_Direction, Normal, finalVertex, Sampler2);
    diffuseColor = calculateLight(Light0_Direction, Normal, finalDiffuse, Sampler2);
    normal = ProjMat * ModelViewMat * vec4(Normal, 0);
    texCoord0 = texCoordR;
    overlayCoord = overlayCoordO;
}

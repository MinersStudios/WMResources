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

out vec4 baseColor;
out vec4 overlayColor;

out vec2 baseCoord;
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

    vec4 baseColor0 = Color;
    vec4 overlayColor0 = vec4(1.0);

    vec2 baseCoord0 = UV0;
    vec2 overlayCoordO = UV0;

    if (Color.r < 1.0) {
        overlayValue = 1.0;
        baseCoord0.x *= 0.5;
        baseCoord0.y = baseCoord0.y * N;

        for (int i = 0; i < ARMOR_TYPE_COUNT; ++i) {
            Armor armor = ARMOR_TYPES[i];

            if (Color.rgb == armor.color) {
                baseCoord0.y += i * N;

                if (!armor.tintBase) {
                    baseColor0 = vec4(1.0);
                }

                if (armor.tintOverlay) {
                    overlayColor0 = Color;
                }

                break;
            }
        }

        overlayCoordO = baseCoord0 + vec2(0.5, 0.0);
    } else {
        overlayValue = 0.0;
    }

    vertexDistance = cylindrical_distance(ModelViewMat, Position);
    baseColor = calculateLight(Light0_Direction, Normal, baseColor0, Sampler2);
    overlayColor = calculateLight(Light0_Direction, Normal, overlayColor0, Sampler2);
    baseCoord = baseCoord0;
    overlayCoord = overlayCoordO;
}

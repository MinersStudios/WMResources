#version 150

#moj_import <symbols.glsl>

#define BG_COLOR      vec3(16 / 255.0)

#define ORIGIN        ivec2(24)
#define SCALE         2

#define WIDTH         (SCALE * 5)
#define HEIGHT        (SCALE * 6)

#define SPACING       (SCALE * 1)
#define SPACED_WIDTH  (WIDTH + SPACING)

#define STRING        uint[] (_W, _H, _O, _M, _I, _N, _E, _SPACE, _1, _DOT, _0, _DOT, _0)
#define STRING_LENGTH STRING.length()

uniform vec4 ColorModulator;

in vec4 vertexColor;

out vec4 fragColor;

bool isInBounds(ivec2 coord) {
    return coord.y >= 0
        && coord.x >= 0
        && coord.y < HEIGHT
        && coord.x < (SPACED_WIDTH) * STRING_LENGTH - SPACING;
}

bool checkBit(
        uint value,
        int position
) {
    return ((value >> position) & 1u) == 1u;
}

void main() {
    vec4 color = vertexColor;

    if (color.a == 0.0) {
        discard;
    }

    color *= ColorModulator;

    if (length(color.rgb - BG_COLOR) < 0.001) {
        ivec2 offset = ivec2(gl_FragCoord.xy) - ORIGIN;

        if (isInBounds(offset)) {
            int index = offset.x / SPACED_WIDTH;
            offset.x -= index * SPACED_WIDTH;

            if (offset.x < WIDTH) {
                color = checkBit(STRING[index], 4 - offset.x / SCALE + offset.y / SCALE * 5)
                        ? vec4(1.0, 1.0, 1.0, color.a)
                        : color;
            }
        }
    }

    fragColor = color;
}

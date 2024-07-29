#version 150

#define _SPACE  0u
#define _A      488621617u
#define _B      1025459774u
#define _C      488129070u
#define _D      1025033790u
#define _E      1057964575u
#define _F      1057964560u
#define _G      488132142u
#define _H      589284913u
#define _I      474091662u
#define _J      237046348u
#define _K      589982257u
#define _L      554189343u
#define _M      599442993u
#define _N      597347889u
#define _O      488162862u
#define _P      1025458704u
#define _Q      488166989u
#define _R      1025459761u
#define _S      520553534u
#define _T      1044516996u
#define _U      588826158u
#define _V      588818756u
#define _W      588830378u
#define _X      581052977u
#define _Y      581046404u
#define _Z      1042424351u
#define _0      490399278u
#define _1      147460255u
#define _2      487657759u
#define _3      487654958u
#define _4      73747426u
#define _5      1057949230u
#define _6      487540270u
#define _7      1041305732u
#define _8      488064558u
#define _9      488080942u
#define _PLUS   139432064u
#define _MINUS  1015808u
#define _LPNS   142876932u
#define _RPNS   136382532u
#define _LSLASH 545394753u
#define _RSLASH 35787024u
#define _DOT    4u
#define _COMMA  68u
#define _USCORE 31u
#define _HASH   368389098u

#define ORIGIN       ivec2(24)
#define SCALE        2
#define WIDTH        (SCALE * 5)
#define HEIGHT       (SCALE * 6)
#define SPACING      (SCALE * 1)
#define SPACED_WIDTH (WIDTH + SPACING)

#define STRING        uint[] (_W, _H, _O, _M, _I, _N, _E, _SPACE, _1, _DOT, _0, _DOT, _0)
#define STRING_LENGTH 13

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

    if (color.a == 0.0) discard;

    color *= ColorModulator;

    if (length(color.rgb - vec3(16 / 255.)) < .001) {
        ivec2 offset = ivec2(gl_FragCoord.xy) - ORIGIN;

        if (isInBounds(offset)) {
            int index = offset.x / SPACED_WIDTH;
            offset.x -= index * SPACED_WIDTH;

            if (offset.x < WIDTH) {
                color = checkBit(STRING[index], 4 - offset.x / SCALE + offset.y / SCALE * 5)
                        ? vec4(1., 1., 1., color.a)
                        : color;
            }
        }
    }

    fragColor = color;
}

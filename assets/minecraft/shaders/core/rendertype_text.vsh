#version 150
#moj_import <fog.glsl>
in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
uniform sampler2D Sampler0, Sampler2;
uniform mat4 ModelViewMat, ProjMat;
uniform float GameTime;
out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out float barProgress;
out vec3 barColor;
out float effect;
out vec2 pos;

void main() {
    pos = Position.xy;
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.);
    vertexDistance = cylindrical_distance(ModelViewMat, Position);
    texCoord0 = UV0;
    barProgress = -1.;
    barColor = vec3(1.);
    effect = 0.;
    if (Color.y == 254. / 255.) {
        vertexColor = vec4(1.);
        barProgress = Color.z;
        float c = floor(Color.x * 255.);
        if (c == 255.) barColor = vec3(226., 166., 70.) / 255.;
        else if (c == 254.) barColor = vec3(238., 106., 99.) / 255.;
        else if (c == 253.) barColor = vec3(182., 127., 225.) / 255.;
        else if (c == 252.) barColor = vec3(104., 213., 88.) / 255.;
    } else if (Color.xyz == vec3(1., 84. / 255., 1. / 3.))
        vertexColor = vec4(vec3(1., 1. / 3., 1. / 3.), abs(mod(GameTime * 16000., 20.) - 10.) / 10.);
    else if (Color.xyz == vec3(254. / 255., 1., 1.))
        vertexColor = vec4(1.);
    else if (Color.xyz == vec3(0., 0., 170.) / 255.)
        vertexColor = vec4(int(floor(max(mod(GameTime * 12000., 50.) - 46., 0.))) == int(mod(floor(texture(Sampler0, UV0).z * 255.), 4.)));
    else if (Color.xyz == vec3(1., 253. / 255., 1.)) {
        vertexColor = vec4(1.);
        effect = 1.;
    } else if (Color.xz == vec2(254., 4.) / 255.) {
        if (Color.y <= 240. / 255.) {
            vertexColor = vec4(1.);
            effect = 2. + (240. / 255. - Color.y);
            vec4 color = texture(Sampler0, UV0);
            gl_Position = vec4(color.x * 2. - 1., color.y * 2. - 1., gl_Position.z, 1.);
            texCoord0 = color.xy;
            ivec2 size = textureSize(Sampler0, 0);
            pos = UV0 - vec2(color.x, 1. - color.y) * (vec2(160., 64.) / size);
        } else vertexColor = vec4(1.);
    } else if (Color.xz == vec2(63. / 255., 1. / 255.)) vertexColor = vec4(0.);
    else vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
}

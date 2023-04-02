#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
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
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = cylindrical_distance(ModelViewMat, Position);
    texCoord0 = UV0;
    barProgress = -1.0;
    barColor = vec3(1.0);
    effect = 0.0;

    if (Color.y == 254.0 / 255.0) {
        vertexColor = vec4(1.0);
        barProgress = Color.z;
        float c = floor(Color.x * 255.0);

        if (c == 255.0) barColor = vec3(226.0, 166.0, 70.0) / 255.0;
        else if (c == 254.0) barColor = vec3(238.0, 106.0, 99.0) / 255.0;
        else if (c == 253.0) barColor = vec3(182.0, 127.0, 225.0) / 255.0;
        else if (c == 252.0) barColor = vec3(104.0, 213.0, 88.0) / 255.0;
    } else if (Color.xyz == vec3(1.0, 84.0 / 255.0, 1.0 / 3.0))
        vertexColor = vec4(vec3(1.0, 1.0 / 3.0, 1.0 / 3.0), abs(mod(GameTime * 16000.0, 20.0) - 10.0) / 10.0);
    else if (Color.xyz == vec3(254.0 / 255.0, 1.0, 1.0))
        vertexColor = vec4(1.0);
    else if (Color.xyz == vec3(0.0, 0.0, 170.0) / 255.0)
        vertexColor = vec4(int(floor(max(mod(GameTime * 12000.0, 50.0) - 46.0, 0.0))) == int(mod(floor(texture(Sampler0, UV0).z * 255.0), 4.0)));
    else if (Color.xyz == vec3(1.0, 253.0 / 255.0, 1.0)) {
        vertexColor = vec4(1.0);
        effect = 1.0;
    } else if (Color.xz == vec2(254.0, 4.0) / 255.0) {
        if (Color.y <= 240.0 / 255.0) {
            vertexColor = vec4(1.0);
            effect = 2.0 + (240.0 / 255.0 - Color.y);
            vec4 color = texture(Sampler0, UV0);
            gl_Position = vec4(color.x * 2.0 - 1.0, color.y * 2.0 - 1.0, gl_Position.z, 1.0);
            texCoord0 = color.xy;
            ivec2 size = textureSize(Sampler0, 0);
            pos = UV0 - vec2(color.x, 1.0 - color.y) * (vec2(160.0, 64.0) / size);
        } else vertexColor = vec4(1.0);
    } else if (Color.xz == vec2(63.0 / 255.0, 1.0 / 255.0)) vertexColor = vec4(0.0);
    else vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
}

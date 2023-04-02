#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;
uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;
uniform vec2 ScreenSize;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in float barProgress;
in vec3 barColor;
in float effect;
in vec2 pos;
out vec4 fragColor;

vec2 rotate(vec2 v, float a) {
    float s = sin(a);
    float c = cos(a);
    mat2 m = mat2(c,  - s, s, c);
    return m * v;
}

float smin(
        float a,
        float b,
        float k
) {
    float h = clamp(0.5 + 0.5 * (a - b) / k, 0.0, 1.0);
    return mix(a, b, h) - k * h * (1.0 - h);
}

float crawl(float t) {
    return 0.23 * smoothstep(-1.0, 1.0, 4.2 * sin(6.2831 * (240.0 * GameTime + t))) + 3.0 * smin(0, 0.1 + 0.15 * sin(6.2831 * (100.0 * GameTime + t)), 0.02);
}

vec4 scarab(
        vec2 uv,
        float amt,
        float offset,
        float scale,
        ivec2 size
) {
    float n = 5.0;
    float an = 6.2831 / n;
    uv = rotate(uv, 6.2831 * GameTime * 150.0 + offset);
    float fa = (atan(uv.y, uv.x) + an * 0.5) / an;
    float ia = floor(fa);
    float sym = an * ia;
    float index = 4.0 * (ia + floor(n / 2.0));

    if (index > amt) return vec4(0.0);

    scale *= min(1.0, amt - index + 1.0 / 12.0);
    vec2 p = rotate(uv, sym);
    p.x -= 0.6;
    p.x += scale * sin(6.2831 * (750.0 * GameTime + ia / n)) * 0.025;
    float mt = ia / n + offset * 0.5;
    float c = crawl(mt);
    p.x += c;
    p = rotate(p, 300.0 * (crawl(mt + 0.001) - c));
    float s = scale * 0.25 / 2.0;

    if (abs(p.x) < s&&abs(p.y) < s) {
        p *= 0.998;
        vec2 tex = (p + s) / (2.0 * s);
        float frame = mod(floor(fract(GameTime * 2400.0 + ia / n) * 4.0) + ia, 4.0);
        return texture(Sampler0, pos + vec2(8.0, frame * 16.0) / size + tex * (16.0 / size));
    }
    return vec4(0.0);
}

vec4 scarabs(
        vec2 uv,
        float amt,
        ivec2 size
) {
    vec4 col = scarab(uv.yx * vec2(-1.0, -1.0) + vec2(0.0, 0.33), amt - 3.0, 0.9, 1.0, size);
    vec4 layer = scarab(uv + vec2(0.33, 0.0), amt - 1.0, 0.0, 0.98, size);
    layer.xyz *= 0.8;
    col = mix(layer, col, col.a);
    layer = scarab(uv * vec2(0.9, -0.9) + vec2(1.0, 0.0), amt - 2.0, -1.5, 0.66, size);
    layer.xyz *= 0.75;
    col = mix(layer, col, col.a);
    layer = scarab(uv.yx * vec2(-0.9, 0.9) - vec2(0.0, 1.0), amt, 0.0, 0.66, size);
    layer.xyz *= 0.7;
    col = mix(layer, col, col.a);
    return col;
}

void main() {
    vec4 col = texture(Sampler0, texCoord0);

    if (col == vec4(0.0, 1.0, 1.0, 1.0)) discard;

    if (barProgress >= 0.)if (col.b < barProgress) {
        float t = col.r * 0.8 + 0.2;
        vec3 bias;
        if (barColor.g == max(max(barColor.r, barColor.g), barColor.b))
            bias = vec3(t, t, mix(t * t * t, t, barColor.b));
        else
            bias = vec3(t, mix(t * t * t, t, barColor.g), t);
        col.rgb = min(bias * barColor * 1.2, vec3(1.0));
    } else col.b = col.r;

    if (effect == 1.0) {
        vec2 m = mod(floor(pos) / 2.0, 32.0);
        float p = floor(fract(floor(m.x + m.y - floor(GameTime * 24000.0) - col.x * 4.0) / 32.0) * 6.0);
        vec3 c = vec3(1.0);

        if (p == 0.0) c = vec3(236.0,  79.0, 79.0);
        else if (p == 1.0) c = vec3(255.0, 169.0, 56.0);
        else if (p == 2.0) c = vec3(255.0, 226.0, 50.0);
        else if (p == 3.0) c = vec3(101.0, 236.0, 79.0);
        else if (p == 4.0) c = vec3(79.0, 202.0, 236.0);
        else if (p == 5.0) c = vec3(193.0, 113.0, 239.0);

        col.xyz = min(col.xyz + 0.15, 1.0) * c / 255.0;
    } else if (floor(effect) == 2.0) {
        float amt = floor(fract(effect) * 255.0) / 12.0;
        col = vec4(vec3(0.0), 1.0);
        ivec2 size = textureSize(Sampler0, 0);
        vec2 uv = texCoord0;
        uv.y = 1.0 - uv.y;
        uv.y -= 0.5;
        uv.x -= 0.5;
        float aspect = ScreenSize.x / ScreenSize.y;
        uv.x *= aspect;
        col = scarabs(uv, amt, size);
        vec4 shadow = scarabs(uv - vec2(0.011), amt, size);
        shadow.rgb = vec3(0.0);
        shadow.a *= 0.25;
        col.rgb = mix(shadow.rgb, col.rgb, col.a);
        col.a = min(1.0, shadow.a + col.a);
    }

    vec4 v = col * vertexColor * ColorModulator;
    if (v.w < 0.01) discard;
    fragColor = linear_fog(v, vertexDistance, FogStart, FogEnd, FogColor);
}

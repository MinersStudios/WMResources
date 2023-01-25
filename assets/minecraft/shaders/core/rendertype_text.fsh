#version 150
#moj_import <fog.glsl>
uniform sampler2D Sampler0;
uniform vec4 ColorModulator;
uniform float FogStart, FogEnd;
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
    float h = clamp(0.5 + 0.5 * (a - b) / k, 0., 1.);
    return mix(a, b, h) - k * h * (1. - h);
}

float crawl(float t) {
    return 0.23 * smoothstep( - 1., 1., 4.2 * sin(6.2831 * (240. * GameTime + t))) + 3. * smin(0, 0.1 + 0.15 * sin(6.2831 * (100. * GameTime + t)), 0.02);
}

vec4 scarab(
        vec2 uv,
        float amt,
        float offset,
        float scale,
        ivec2 size
) {
    float n = 5.;
    float an = 6.2831 / n;
    uv = rotate(uv, 6.2831 * GameTime * 150. + offset);
    float fa = (atan(uv.y, uv.x) + an * 0.5) / an;
    float ia = floor(fa);
    float sym = an * ia;
    float index = 4. * (ia + floor(n / 2.));
    if (index > amt) return vec4(0.);
    scale *= min(1., amt - index + 1. / 12.);
    vec2 p = rotate(uv, sym);
    p.x -= 0.6;
    p.x += scale * sin(6.2831 * (750. * GameTime + ia / n)) * 0.025;
    float mt = ia / n + offset * 0.5;
    float c = crawl(mt);
    p.x += c;
    p = rotate(p, 300. * (crawl(mt + 0.001) - c));
    float s = scale * 0.25 / 2.;
    if (abs(p.x) < s&&abs(p.y) < s) {
        p *= 0.998;
        vec2 tex = (p + s) / (2. * s);
        float frame = mod(floor(fract(GameTime * 2400. + ia / n) * 4.) + ia, 4.);
        return texture(Sampler0, pos + vec2(8., frame * 16.) / size + tex * (16. / size));
    }
    return vec4(0.);
}

vec4 scarabs(
        vec2 uv,
        float amt,
        ivec2 size
) {
    vec4 col = scarab(uv.yx * vec2( - 1.,  - 1.) + vec2(0., 0.33), amt - 3., 0.9, 1., size);
    vec4 layer = scarab(uv + vec2(0.33, 0.), amt - 1., 0., 0.98, size);
    layer.xyz *= 0.8;
    col = mix(layer, col, col.a);
    layer = scarab(uv * vec2(0.9,  - 0.9) + vec2(1., 0.), amt - 2.,  - 1.5, 0.66, size);
    layer.xyz *= 0.75;
    col = mix(layer, col, col.a);
    layer = scarab(uv.yx * vec2( - 0.9, 0.9) - vec2(0., 1.), amt, 0., 0.66, size);
    layer.xyz *= 0.7;
    col = mix(layer, col, col.a);
    return col;
}

void main() {
    vec4 col = texture(Sampler0, texCoord0);
    if (col == vec4(0., 1., 1., 1.)) discard;
    if (barProgress >= 0.)if (col.b < barProgress) {
        float t = col.r * 0.8 + 0.2;
        vec3 bias;
        if (barColor.g == max(max(barColor.r, barColor.g), barColor.b))
            bias = vec3(t, t, mix(t * t * t, t, barColor.b));
        else
            bias = vec3(t, mix(t * t * t, t, barColor.g), t);
        col.rgb = min(bias * barColor * 1.2, vec3(1.));
    }
    else col.b = col.r;
    if (effect == 1.) {
        vec2 m = mod(floor(pos) / 2., 32.);
        float p = floor(fract(floor(m.x + m.y - floor(GameTime * 24000.) - col.x * 4.) / 32.) * 6.);
        vec3 c = vec3(1.);
        if (p == 0.) c = vec3(236.,  79., 79.);
        else if (p == 1.) c = vec3(255., 169., 56.);
        else if (p == 2.) c = vec3(255., 226., 50.);
        else if (p == 3.) c = vec3(101., 236., 79.);
        else if (p == 4.) c = vec3(79., 202., 236.);
        else if (p == 5.) c = vec3(193., 113., 239.);
        col.xyz = min(col.xyz + 0.15, 1.) * c / 255.;
    } else if (floor(effect) == 2.) {
        float amt = floor(fract(effect) * 255.) / 12.;
        col = vec4(vec3(0.), 1.);
        ivec2 size = textureSize(Sampler0, 0);
        vec2 uv = texCoord0;
        uv.y = 1. - uv.y;
        uv.y -= 0.5;
        uv.x -= 0.5;
        float aspect = ScreenSize.x / ScreenSize.y;
        uv.x *= aspect;
        col = scarabs(uv, amt, size);
        vec4 shadow = scarabs(uv - vec2(0.011), amt, size);
        shadow.rgb = vec3(0.);
        shadow.a *= 0.25;
        col.rgb = mix(shadow.rgb, col.rgb, col.a);
        col.a = min(1., shadow.a + col.a);
    }
    vec4 v = col * vertexColor * ColorModulator;
    if (v.w < 0.01) discard;
    fragColor = linear_fog(v, vertexDistance, FogStart, FogEnd, FogColor);
}

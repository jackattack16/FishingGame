uniform float u_time;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec2 uv = texture_coords;
    uv.x += sin(cos(uv.y) * 40.0 + u_time * 0.5) * 0.0075;
    return Texel(tex, uv) * color;
}
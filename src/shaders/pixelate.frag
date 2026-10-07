vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    float Pixels = 2048.0;
    float dx = 15.0 * (1.0 / Pixels);
    float dy = 10.0 * (1.0 / Pixels);
    vec2 coord = vec2(dx * floor(texture_coords.x / dx), dy * floor(texture_coords.y / dy));
    
    return vec4(Texel(tex, coord));
}
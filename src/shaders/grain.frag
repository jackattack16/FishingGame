uniform float u_time;

float random(vec2 position) {
	return fract(sin(dot(position, vec2(12.9898, 78.233))) * 43758.5453123);
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
	vec4 pixel_color = Texel(tex, texture_coords);
	vec2 pixel = floor(screen_coords);
	float frame = floor(u_time * 12.0 * texture_coords.x);
	vec2 offset = vec2(frame * 17.0, frame * 47.0 * texture_coords.y);

	float fine = random(pixel + offset) - 0.5;
	float clump = random(floor(pixel / 2.0) + offset) - 0.5;
	float grain = (fine * 2 + clump * 0.25) * 0.075;
	pixel_color.rgb = clamp(pixel_color.rgb + vec3(grain), 0.0, 1.0);
    pixel_color.a = 0.25;

	return pixel_color * color;
}

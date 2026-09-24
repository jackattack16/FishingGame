uniform vec2 u_resolution;
uniform float u_time;
float random(vec2 st) {
	return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
	vec2 i = floor(st);
	vec2 f = fract(st);

	float a = random(i);
	float b = random(i + vec2(1.0, 0.0));
	float c = random(i + vec2(0.0, 1.0));
	float d = random(i + vec2(1.0, 1.0));

	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float evolvingNoise(vec2 pos, float time) {
	float slice = floor(time);
	float blend = smoothstep(0.0, 1.0, fract(time));

	float a = noise(pos + vec2(slice * 17.0, slice * 47.0));
	float b = noise(pos + vec2((slice + 1.0) * 17.0, (slice + 1.0) * 47.0));

	return mix(a, b, blend);
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
	vec2 st = screen_coords / u_resolution;
	float n = evolvingNoise(st * 5.0, u_time * 0.075);
	vec3 water = vec3(max(n / 10.0, 0.024), max(n / 2.0, 0.145), max(n, 0.259));
	vec3 lit = mix(water, vec3(1.0), st.x * 0.05);
	vec3 dark = mix(water, vec3(0.0), st.y * 2);
	vec3 result = mix(lit, dark, 0.5);
	return vec4(result, 0.25);
}
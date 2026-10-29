shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float width : hint_range(0.0, 4.0, 1.0) = 1.0;
uniform float solid_threshold : hint_range(0.0, 1.0) = 0.9;

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	vec2 size = TEXTURE_PIXEL_SIZE * width;

	float n = step(solid_threshold, texture(TEXTURE, UV + vec2(0.0, -size.y)).a);
	n += step(solid_threshold, texture(TEXTURE, UV + vec2(0.0, size.y)).a);
	n += step(solid_threshold, texture(TEXTURE, UV + vec2(-size.x, 0.0)).a);
	n += step(solid_threshold, texture(TEXTURE, UV + vec2(size.x, 0.0)).a);
	n = min(n, 1.0);

	float is_solid = step(solid_threshold, col.a);
	float outline = n * (1.0 - is_solid);

	COLOR = mix(col, outline_color, outline);
}
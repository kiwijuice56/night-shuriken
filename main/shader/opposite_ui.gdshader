shader_type canvas_item;

void fragment() {
	float ir = (1.0 - textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).r);
	COLOR = vec4(ir, ir, ir, texture(TEXTURE, UV).a);
}
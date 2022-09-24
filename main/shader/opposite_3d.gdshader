shader_type spatial;
render_mode unshaded;

void fragment() {
	float ir = 1.0 - textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).r;
    ALBEDO = vec3(ir, ir, ir);
}
shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE,UV);
	COLOR = mix(COLOR,vec4(0.7,0.7,0.7,1.0),COLOR.a*1.5);
}
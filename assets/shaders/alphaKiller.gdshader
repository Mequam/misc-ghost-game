shader_type canvas_item;

void fragment() {
	vec4 originalColor = texture(TEXTURE,UV);
	COLOR.rgb = originalColor.rgb;
	COLOR = mix(originalColor,COLOR,originalColor.a * 2.5);
}
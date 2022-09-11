shader_type canvas_item;

void fragment(){
	vec3 screenColor = texture(TEXTURE, UV).rgb;
	float brightness = (screenColor.r + screenColor.g + screenColor.b) / 3.0;
	screenColor = vec3(brightness, brightness, brightness);
	COLOR.rgb = screenColor;
}
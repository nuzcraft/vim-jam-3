shader_type canvas_item;

uniform float greyness : hint_range(0.0, 1.0, 0.1) = 0;

void fragment(){
	vec3 screenColor = texture(TEXTURE, UV).rgb;
	float brightness = (screenColor.r + screenColor.g + screenColor.b) / 3.0;
	float r = screenColor.r - ((screenColor.r - brightness) * greyness);
	screenColor = screenColor - ((screenColor - vec3(brightness)) * greyness);
//	screenColor = vec3(r, brightness, brightness);
	COLOR.rgb = screenColor;
}
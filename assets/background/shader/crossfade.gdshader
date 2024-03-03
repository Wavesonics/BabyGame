shader_type canvas_item;

//uniform sampler2D top_gradient;
uniform sampler2DArray crossfade_images;
uniform float time_of_day: hint_range(0.0, 1.0);
uniform int num_images;
void fragment() {
	float spans_tod = floor(time_of_day * float(num_images));
    //vec4 top = texture(top_gradient, vec2(time_of_day, 0.5));
    vec4 first = texture(crossfade_images, vec3(UV.xy, mod(spans_tod, float(num_images))));
	vec4 second = texture(crossfade_images, vec3(UV.xy, mod(spans_tod+1.0, float(num_images))));

	float span_factor = mod(time_of_day * float(num_images), 1.0);
	float span_mix = smoothstep(0.75, 1.0, span_factor);
	
	// debug
	//float band1 = 1.0 - step(0.3, UV.x);
	//float band2 = step(0.6, UV.x);
	//float band3 = (1.0 - band1) * (1.0 - band2);
    //COLOR = first * band1 + second * band3 +  mix(first, second, span_mix) * band2;
	
	COLOR = mix(first, second, span_mix);
}

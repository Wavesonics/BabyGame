shader_type canvas_item;

//uniform sampler2D top_gradient;
uniform sampler2DArray crossfade_images;
uniform float time_of_day: hint_range(0.0, 1.0);
uniform float time_offset: hint_range(0.0, 1.0);
uniform int num_images;

// Define your periods' start and end times (these should be sorted)
const float periods[] = {0.0, 0.45, 0.55, 0.9, 1.0001};
void fragment() {
	float tod = mod(time_of_day + time_offset, 1.0001);
    // Determine the current period
    int currentPeriod = 0;
    for (int i = 0; i < periods.length() - 1; i++) {
        if (tod >= periods[i] && tod < periods[i + 1]) {
            currentPeriod = i;
            break;
        }
    }
    
    // Calculate local time factor for the current transition
    float localStart = periods[currentPeriod];
    float localEnd = periods[currentPeriod + 1];
    float localTimeFactor = (tod - localStart) / (localEnd - localStart);

	// Determine which images to blend based on the current period
    vec4 first = texture(crossfade_images, vec3(UV.xy, float(currentPeriod % num_images)));
    vec4 second = texture(crossfade_images, vec3(UV.xy, float((currentPeriod + 1) % num_images)));
    
	// Apply smoothstep for a smoother transition
    //float span_mix = smoothstep(0.75, 1.0, localTimeFactor); // Adjust the range if needed
    float span_mix = smoothstep(localEnd - 0.1, localEnd, tod); // Adjust the range if needed
	COLOR = mix(first, second, span_mix);
}

shader_type canvas_item;

uniform sampler2D crossfade_images;
uniform sampler2D stars: filter_nearest, repeat_enable;
uniform float time_of_day: hint_range(0.0, 1.0);
uniform float time_offset: hint_range(0.0, 1.0);
uniform int num_images;
uniform float twinkle_speed: hint_range(0.0, 1.0);
uniform float star_brightness: hint_range(0.0, 25.0);

// Define your periods' start and end times (these should be sorted)
const float periods[] = {0.0, 0.45, 0.55, 0.9, 1.0001};
const float starBrightness[] = {0.0, 0.0, 1.0, 1.0, 0.0};
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

	// Determine which images to blend based on the current period
    vec4 first = texture(crossfade_images, vec2(UV.x, (float(currentPeriod % num_images) + UV.y) / float(num_images)));
    vec4 second = texture(crossfade_images, vec2(UV.x, (float((currentPeriod + 1) % num_images) + UV.y) / float(num_images)));
    
	// Apply smoothstep for a smoother transition
    //float span_mix = smoothstep(0.75, 1.0, localTimeFactor); // Adjust the range if needed
    float span_mix = smoothstep(localEnd - 0.1, localEnd, tod); // Adjust the range if needed
	
	// stars
	vec2 rSpeed = mod(TIME * twinkle_speed, 1.0) * vec2(0, 1);
	vec2 gSpeed = mod(TIME * twinkle_speed*1.5, 1.0) * vec2(1, 1);
	float r = texture(stars, UV + rSpeed).r;
	float g = texture(stars, UV + gSpeed).g;
	float b = texture(stars, UV).b;
	
	float brightnessStart = starBrightness[currentPeriod];
	float brightnessEnd = starBrightness[currentPeriod + 1];
	float multiplier = mix(brightnessStart, brightnessEnd, span_mix);
	
	float starBrighness = r * g * b * star_brightness * multiplier;
	vec4 starColor = vec4(starBrighness, starBrighness, starBrighness, 1);
	COLOR = mix(first, second, span_mix) + starColor;
}

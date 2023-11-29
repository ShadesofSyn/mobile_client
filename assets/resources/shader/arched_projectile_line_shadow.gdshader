shader_type canvas_item;


render_mode blend_add; //Comment this if you want another render mode.
uniform vec2 center = vec2(0.5);
uniform float size: hint_range(0.0,5.0) = 1.0; //change size to well, change the size of your gradient
uniform vec2 squishness = vec2(1.0); // how squashed your gradient is

//choose colors in the inspector
uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;
uniform vec4 color3 : source_color;
//uniform vec4 color4 : source_color;
//uniform vec4 color5 : source_color;
//uniform vec4 color6 : source_color;

//choose how far the colors are from each other in the inspector
uniform float step1 : hint_range(0.0,1.0) = 0.159;
uniform float step2 : hint_range(0.0,1.0) = 0.182;
uniform float step3 : hint_range(0.0,1.0) = 0.233;
//uniform float step4 : hint_range(0.0,1.0) = 0.264;
//uniform float step5 : hint_range(0.0,1.0) = 0.265;
//uniform float step6 : hint_range(0.0,1.0) = 0.266;

void fragment() {
	float dist = distance(center*squishness,UV*squishness);
	vec4 color = mix(color1, color2, smoothstep(step1*size, step2*size, dist));
	color = mix(color, color3, smoothstep(step2*size, step3*size, dist));
//	color = mix(color, color4, smoothstep(step3*size, step4*size, dist));
//	color = mix(color, color5, smoothstep(step4*size, step5*size, dist));
//	color = mix(color, color6, smoothstep(step5*size, step6*size, dist));
	COLOR = color;
}


// outline 
//uniform vec4 main_color : source_color = vec4(1.0);
//uniform float outter_radius : hint_range(0.0, 1.0) = 1.0;
//uniform float inner_radius : hint_range(0.0, 1.0) = 1.0;
//uniform float blur_radius : hint_range(0.0, 1.0) = 1.0;
//
//uniform sampler2D noise;
//uniform float sample_radius: hint_range(0.0, 1.0) = 0.5;
//uniform vec4 line_color: source_color = vec4(1.0);
//uniform float center_radius: hint_range(0.0, 1.0) = 0.5;
//const float pi = 3.14159265359;
//
//void fragment() {
//    vec2 dist = UV - vec2(0.5);
//    float dist_length=length(dist);
//    float angle = atan(dist.y / dist.x);
//    vec2 sample = vec2(sample_radius * cos(angle), sample_radius * sin(angle));
//    float noise_value = texture(noise, sample).r;
//
//
//      COLOR += main_color;
//      COLOR.a=(blur_radius - dist_length)/(blur_radius - outter_radius);
//}
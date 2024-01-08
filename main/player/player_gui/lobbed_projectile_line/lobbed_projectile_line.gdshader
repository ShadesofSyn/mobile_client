shader_type canvas_item;
uniform vec4 outline_color:source_color = vec4(1.0,1.0,0.0,1.0);
uniform float inner_circle=0.45;
uniform float outer_circle=0.5;


const vec4 alpha_color= vec4(0,0,0,0);

uniform float smoothness=0.01;


void fragment(){

	vec2 origin = UV-vec2(0.5,0.5);
	
	float dist =length(origin); //sqrt(dot(origin,origin));
	
	vec4 _color= mix (texture(TEXTURE,UV),outline_color,smoothstep(inner_circle-smoothness,inner_circle+smoothness,dist));
	 COLOR= mix (_color,alpha_color,smoothstep(outer_circle-smoothness,outer_circle+smoothness,dist));
}
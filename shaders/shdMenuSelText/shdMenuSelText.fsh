//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vPosition; // <- added

uniform vec2 origin_pos;
uniform float radius;

void main()
{
	vec4 my_color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	vec4 original_color = my_color;
	
	
	vec2 dist_vec = vec2(origin_pos.x-v_vPosition.x, origin_pos.y-v_vPosition.y);
	float dist = sqrt(dist_vec.x*dist_vec.x* + dist_vec.y*dist_vec.y);
	if (original_color.a > 0.5){
		// cor original for branca
		my_color.a = abs(dist-radius)/radius - 0.5;
	} else {
		// cor original for transparente
		my_color.a = 0.0;
	}
	
    gl_FragColor = my_color;
}

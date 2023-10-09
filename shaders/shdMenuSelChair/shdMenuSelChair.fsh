//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float c_time;
uniform float add_bright;

void main()
{
	vec4 my_color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	vec4 original_color = my_color;
	
	//float sin_mult = 0.002;
	//float bright_spd = 0.2;
	//my_color.r = original_color.r + 0.6 + sin(c_time*sin_mult)*bright_spd;
	//my_color.g = original_color.g + 0.6 + sin(c_time*sin_mult)*bright_spd;
	//my_color.b = original_color.b + 0.6 + sin(c_time*sin_mult)*bright_spd;
	
	my_color.rgb += add_bright*0.15;
	
    gl_FragColor = my_color;
}

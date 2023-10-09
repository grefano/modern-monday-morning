//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vPosition; // <- added

uniform vec2 dim; // dimensões da elipse
uniform vec2 origin; // ponto central da elipse
uniform float a_multi; // multiplica o alpha pra n ficar opaco no meio


void main()
{
	vec2 fodas = vec2(((v_vPosition.x - origin.x) / ( dim.x / 2.0 )), (( v_vPosition.y - origin.y) / (dim.y / 2.0)));
	float coef = fodas.x * fodas.x + fodas.y * fodas.y - 1.0;

	
	vec4 my_color =  v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	if (coef > 0.0){
		coef = 0.0;
	}
	coef = pow(abs(coef), 4.0); 
	
	my_color.a = coef * a_multi;
    gl_FragColor = my_color;
}

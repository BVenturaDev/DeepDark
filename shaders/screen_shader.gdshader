shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_tex;

void fragment()
{
	ALBEDO = texture(screen_tex, vec2(UV.y, 1.0 - UV.x)).rgb;
	EMISSION = texture(screen_tex, vec2(UV.x, 1.0 - UV.y)).rgb * 4.0;
}
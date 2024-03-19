shader_type spatial;
render_mode unshaded;

uniform sampler2D image : source_color;

void vertex() {
  UV = vec2(UV.x * 0.5, UV.y);
  if (VIEW_INDEX == VIEW_RIGHT) {
    UV.x += 0.5;
  }
}

void fragment() {
  ALBEDO = texture(image, UV).rgb;
}

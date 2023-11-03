shader_type spatial;
render_mode unshaded;

uniform sampler2D movie : source_color;

void fragment() {
    if (VIEW_INDEX == VIEW_MONO_LEFT) {
        // Left Eye: Stretch and fill left half
        vec2 uv = SCREEN_UV * vec2(0.5, 1.0);
        uv.x = uv.x * 2.0; // Stretch the left half

        ALBEDO = texture(movie, uv).rgb;
    } else {
        // Right Eye: Stretch and fill right half
        vec2 uv = SCREEN_UV * vec2(0.5, 1.0);
        uv.x = uv.x * 2.0 - 1.0; // Stretch the right half and move to the right side

        ALBEDO = texture(movie, uv).rgb;
    }
}

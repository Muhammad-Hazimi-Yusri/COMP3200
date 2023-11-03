shader_type canvas_item;

void fragment() {
    // Get the color of the current pixel
    vec4 color = texture(TEXTURE, SCREEN_UV);

    // Calculate the grayscale value by taking the average of the color channels
    float grayscale = (color.r + color.g + color.b) / 3.0;

    // Set the output color to grayscale
    COLOR = vec4(grayscale, grayscale, grayscale, color.a);
}

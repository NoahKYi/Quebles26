shader_type canvas_item;

uniform float blur_size : hint_range(0.0, 20.0) = 6.0;

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy;
    vec4 color = vec4(0.0);
    int samples = 9; // more samples = smoother blur
    float offset = blur_size / SCREEN_PIXEL_SIZE.x;

    for (int x=-1; x<=1; x++) {
        for (int y=-1; y<=1; y++) {
			color += texture(TEXTURE, uv + vec2(float(x), float(y)) * offset);
        }
    }

    color /= float(samples * samples);
    COLOR = color;
}

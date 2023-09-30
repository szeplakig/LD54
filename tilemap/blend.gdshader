shader_type canvas_item;

// Uniforms to control blur amount and direction
uniform float blur_amount : hint_range(0.0, 10.0) = 2.0;
uniform vec2 blur_direction = vec2(1.0, 1.0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 offset[9] = vec2[](
        vec2(-1, -1), vec2(0, -1), vec2(1, -1),
        vec2(-1, 0),  vec2(0, 0),  vec2(1, 0),
        vec2(-1, 1),  vec2(0, 1),  vec2(1, 1)
    );
    
    float weight[9] = float[](
        1.0/16.0, 2.0/16.0, 1.0/16.0,
        2.0/16.0, 4.0/16.0, 2.0/16.0,
        1.0/16.0, 2.0/16.0, 1.0/16.0
    );

    vec4 sum = vec4(0.0);
    for (int i = 0; i < 9; i++) {
        vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy + offset[i] * blur_amount * blur_direction / SCREEN_PIXEL_SIZE;
        sum += texture(SCREEN_TEXTURE, uv) * weight[i];
    }

    COLOR = sum;
}

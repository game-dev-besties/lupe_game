shader_type canvas_item;

uniform float fill_pct : hint_range(0.0, 1.0) = 0.0;   // 0 = empty, 1 = full
uniform vec4  fill_color : source_color = vec4(0.22, 0.65, 1.0, 1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // Discard pixels outside the bubble’s alpha mask
    if (tex.a < 0.05) { discard; }

    float water_line = 1.0 - fill_pct;   // UV origin is top-left
    bool under_water = UV.y > water_line;

    COLOR = under_water
        ? vec4(fill_color.rgb, tex.a * fill_color.a)  // solid colour inside
        : tex;                                        // plain bubble above
}


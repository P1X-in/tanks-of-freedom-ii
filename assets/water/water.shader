shader_type spatial;

uniform vec2 amplitude = vec2(0.2, 0.1);
uniform vec2 frequency = vec2(3.0, 2.5);
uniform vec2 time_factor = vec2(2.0, 3.0);

uniform sampler2D texturemap : hint_albedo;
uniform vec2 texture_scale = vec2(70, 70);

uniform sampler2D uv_offset_texture : hint_black;
uniform vec2 uv_offset_scale = vec2 (0.2, 0.2);
uniform float uv_offset_time_scale = 0.01;
uniform float uv_offset_amplitude = 0.05;

uniform sampler2D normalmap : hint_normal;

float height(vec2 pos, float time) {
    return (amplitude.x * sin(pos.x * frequency.x + time * time_factor.x)) + (amplitude.y * sin(pos.y * frequency.y + time * time_factor.y));
}

void vertex() {
    VERTEX.y += height(VERTEX.xz, TIME);
    
    TANGENT = normalize(vec3(0.0, height(VERTEX.xz + vec2(0.0, 0.2), TIME) - height(VERTEX.xz + vec2(0.0, -0.2), TIME), 0.4));
    BINORMAL = normalize(vec3(0.4, height(VERTEX.xz + vec2(0.2, 0.0), TIME) - height(VERTEX.xz + vec2(-0.2, 0.0), TIME), 0.0));
    NORMAL = cross(TANGENT, BINORMAL);
}

void fragment() {
    vec2 base_uv_offset = UV * uv_offset_scale;
    base_uv_offset += TIME * uv_offset_time_scale;
    
    vec2 texture_based_offset = texture(uv_offset_texture, base_uv_offset).rg;
    texture_based_offset = texture_based_offset * 2.0 - 1.0;
    
    vec2 texture_uv = UV * texture_scale;
    texture_uv += uv_offset_amplitude * texture_based_offset;
    
    ALBEDO = texture(texturemap, texture_uv).rgb;
    
    NORMALMAP = texture(normalmap, base_uv_offset).rgb;
    //METALLIC = 0.0;
    //ROUGHNESS = 1.0;
}
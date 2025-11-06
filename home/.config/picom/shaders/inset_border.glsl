#version 330

in vec2 texcoord;
uniform sampler2D tex;
uniform float corner_radius;
uniform float border_width;

float inset_border_width = 1;
vec4 border_color = vec4(1.0, 1.0, 1.0, 0.05);

vec4 default_post_processing(vec4 c);

vec4 add_border(
  vec4 win_color,
  vec2 tex_coord,
  vec2 tex_size,
  float radius,
  float thickness,
  vec4 color
) {
  vec2 corner_distance = min(abs(tex_coord), abs(tex_size - 1 - tex_coord));

  // Window sides
  if (any(greaterThan(corner_distance, vec2(radius)))) {
    if (any(lessThan(tex_coord, vec2(thickness)))
        || any(greaterThan(tex_coord, tex_size - vec2(thickness)))) {
      return mix(win_color, color, color.a);
    }

    return win_color;
  }

  // Distance from the closest arc center
  vec2 center_distance = min(
      abs(vec2(radius) - tex_coord),
      abs(vec2(tex_size - radius) - tex_coord)
    );

  // Do some simple anti-aliasing
  float inner_radius = radius - thickness + 0.3;
  float feather = 1 / inner_radius;
  float r = length(center_distance) / inner_radius;
  float blend = smoothstep(1 - 1 / radius, 1, r);

  return mix(win_color, color, color.a * blend);
}

vec4 window_shader() {
  vec2 tex_size = textureSize(tex, 0);
  vec4 c = texture2D(tex, texcoord / tex_size, 0);
  vec4 with_border = add_border(c, texcoord, tex_size, corner_radius, border_width + inset_border_width, border_color);
  return default_post_processing(with_border);
}

shader_type canvas_item;

uniform float width = 0.05;
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

const float HALF_WIDTH = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
  vec2 center = vec2(0.5, 0.5);
  float distance_to_center = distance(UV, center);

  float inner = 1.0 - step(HALF_WIDTH - width, distance_to_center); // smaller circle
  float outer = 1.0 - step(HALF_WIDTH, distance_to_center); // larger circle

  float a = mix(0.0, color.a, outer - inner);

  COLOR = vec4(color.rgb, a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

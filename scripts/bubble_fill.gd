class_name BubbleFill
extends Sprite2D

@export var fill_pct = 0.0
@export var min_fill_pct = 0.2
@export var max_fill_pct = 0.8

# Fill Colors
@export var start_fill_color: Color = Color(0.0, 0.5, 1.0, 1.0)
@export var end_fill_color: Color = Color(0.0, 1.0, 0.0, 1.0)

func _ready():
	# Ensure each bubble instance has its own material,
	# not the shared resource:
	material = material.duplicate()

func set_fill(v):
	var scaled_fill_pct = (v * (max_fill_pct - min_fill_pct)) + min_fill_pct
	fill_pct = clamp(scaled_fill_pct, 0.0, 1.0)
	(material as ShaderMaterial).set_shader_parameter("fill_pct", scaled_fill_pct)

	# Determine the correct fill color. It should be start_fill_color when fill_pct is 0 and end_fill_color when fill_pct is 1.
	var fill_color = start_fill_color.lerp(end_fill_color, fill_pct)
	(material as ShaderMaterial).set_shader_parameter("fill_color", fill_color)

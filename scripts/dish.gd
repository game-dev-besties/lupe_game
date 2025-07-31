class_name Dish
extends Node2D

var ellipse_width: float = 400.0
var ellipse_height: float = 200.0
var angular_velocity: float = 0.0
var current_angle: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D

func _process(delta):
	current_angle += angular_velocity * delta
	current_angle = fmod(current_angle, TAU)
	var radius_x = ellipse_width / 2.0
	var radius_y = ellipse_height / 2.0
	position.x = radius_x * cos(current_angle)
	position.y = radius_y * sin(current_angle)

	if position.y < 0:
		z_index = -1
	else:
		z_index = 1

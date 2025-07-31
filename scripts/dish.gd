class_name Dish
extends Area2D

var item_name: String
var effect: String
var ellipse_width: float = 400.0
var ellipse_height: float = 200.0
var angular_velocity: float = 0.0
var current_angle: float = 0.0

func init(data: Dictionary):
	var sprite: Sprite2D = get_node("Sprite2D")
	self.item_name = data.get("item_name", "Unknown Item")
	self.effect = data.get("effect", "none")
	
	sprite.texture = data.get("texture")
	var scale_factor = data.get("scale", 1.0)
	sprite.scale = Vector2.ONE * scale_factor

func _ready():
	connect("input_event", _on_input_event)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("You clicked on the ", item_name)
		match effect:
			"heal":
				print("Healing the player!")
			"damage_boost":
				print("Giving the player a damage boost!")
			_:
				print("This item has no special effect.")

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

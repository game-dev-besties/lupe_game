extends Node2D

# --- Scene & Path Properties ---
@export var dish_scene: PackedScene
@export var ellipse_width: float = 400.0
@export var ellipse_height: float = 200.0

# --- Physics Properties ---
@export var max_scale: float = 1.2
var angular_velocity: float = 0.0
const acceleration: float = 5.0
const max_angular_velocity: float = 7.0
const natural_friction: float = 1.0
const brake_force: float = 8.0

# --- Dish Data ---
var dishes_data = [
	{"texture": preload("res://assets/canvas.png"), "scale": .3},
	{"texture": preload("res://assets/canvas.png"), "scale": .3},
	{"texture": preload("res://assets/canvas.png"), "scale": .3},
	{"texture": preload("res://assets/canvas.png"), "scale": .3},
	{"texture": preload("res://assets/canvas.png"), "scale": .3},
	{"texture": preload("res://assets/canvas.png"), "scale": .3},
	{"texture": preload("res://assets/canvas.png"), "scale": .3},
	{"texture": preload("res://assets/canvas.png"), "scale": .3},
]

func _ready():
	spawn_dishes()

func _process(delta):
	handle_input(delta)
	apply_physics(delta)

	for dish in get_children():
		if dish is Dish:
			dish.angular_velocity = self.angular_velocity

func spawn_dishes():
	var total_dishes = dishes_data.size()
	for i in range(total_dishes):
		var dish_instance = dish_scene.instantiate()
		var dish_data = dishes_data[i]
		var sprite = dish_instance.get_node("Sprite2D")
		sprite.texture = dish_data.texture
		var clamped_scale = min(dish_data.get("scale", 1.0), max_scale)
		sprite.scale = Vector2.ONE * clamped_scale
		dish_instance.ellipse_width = self.ellipse_width
		dish_instance.ellipse_height = self.ellipse_height
		dish_instance.current_angle = i * (TAU / total_dishes) # Spread them out
		add_child(dish_instance)

# --- Input and Physics functions ---
func handle_input(delta):
	var input_force = 0.0
	if Input.is_action_pressed("ui_left"):
		input_force -= acceleration
	if Input.is_action_pressed("ui_right"):
		input_force += acceleration
	
	if input_force != 0:
		angular_velocity += input_force * delta
		angular_velocity = clamp(angular_velocity, -max_angular_velocity, max_angular_velocity)

func apply_physics(delta):
	var friction = natural_friction
	if Input.is_action_pressed("ui_accept"):
		friction = brake_force
	
	if angular_velocity != 0:
		angular_velocity = move_toward(angular_velocity, 0, friction * delta)

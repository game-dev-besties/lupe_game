extends Node2D

# --- Scene & Path Properties ---
@export var dish_scene: PackedScene
@export var npc_scene: PackedScene
@export var ellipse_width: float = 450.0
@export var ellipse_height: float = 225.0

# --- Physics Properties ---
@export var max_scale: float = 1.2
@export var serving_distance_threshold: float = 150.0
var angular_velocity: float = 0.0
const acceleration: float = 5.0
const max_angular_velocity: float = 7.0
const natural_friction: float = 1.0
const brake_force: float = 8.0
const npc_placement_radius = 200

# -- States ---
var is_rotating: bool = false

# --- Data ---
var dishes_data = [
	{"texture": preload("res://assets/canvas.png"), "scale": 0.3, "item_name": "rice", "quantity": 3},
	{"texture": preload("res://assets/rings.webp"), "scale": 0.3, "item_name": "planet", "quantity": 3},
	{"texture": preload("res://assets/canvas.png"), "scale": 0.3, "item_name": "rice", "quantity": 3},
	{"texture": preload("res://assets/rings.webp"), "scale": 0.3, "item_name": "planet", "quantity": 3},
	{"texture": preload("res://assets/canvas.png"), "scale": 0.3, "item_name": "rice", "quantity": 3},
]
var npc_desires = [
	{"name": "npc1", "desire": "planet", "timer": 1.5},
	{"name": "npc2", "desire": "Magic Sword", "timer": 1.5},
	{"name": "npc3", "desire": "nothing", "timer": 1.5},
	{"name": "npc4", "desire": "rice", "timer": 1.5},
	{"name": "npc4", "desire": "rice", "timer": 1.5},
]

func _ready():
	spawn_dishes()
	spawn_npcs()

func _process(delta):
	handle_input(delta)
	apply_physics(delta)
	# figure out if susan is moving
	var was_rotating = is_rotating
	is_rotating = (angular_velocity != 0.0)
	if was_rotating and not is_rotating:
		_on_susan_stopped()
	elif not was_rotating and is_rotating:
		_on_susan_started_moving()
		
	#validate dish is dish and update it
	for dish in get_children():
		if dish is Dish:
			dish.angular_velocity = self.angular_velocity

func spawn_dishes():
	var total_dishes = dishes_data.size()
	for i in range(total_dishes):
		var dish_instance = dish_scene.instantiate()
		var dish_data = dishes_data[i]
		dish_instance.init(dish_data)
		dish_instance.ellipse_width = self.ellipse_width
		dish_instance.ellipse_height = self.ellipse_height
		dish_instance.current_angle = i * (TAU / total_dishes)
		add_child(dish_instance)

func spawn_npcs():
	var spawn_points = $NpcSpawnPoints.get_children()
	var total_npcs = npc_desires.size()

	# Loop through the NPCs, but don't spawn more than marker amount
	for i in range(min(total_npcs, spawn_points.size())):
		var npc_instance = npc_scene.instantiate()
		var spawn_marker = spawn_points[i]
		npc_instance.init(npc_desires[i])
		npc_instance.placement_angle = spawn_marker.position.angle()
		npc_instance.position = spawn_marker.position
		add_child(npc_instance)

# --- Event Functions ---
func _on_susan_stopped():
	print("Susan stopped! Checking dishes...")
	
	var dishes = []
	var npcs = []
	for node in get_children():
		if node is Dish:
			dishes.append(node)
		elif node is NPC:
			npcs.append(node)
			
	# For each NPC, find the dish in front of them
	for npc in npcs:
		# calculate distance between dish and 
		var closest_dish: Dish = null
		var min_angle_diff = INF
		for dish in dishes:
			var diff = abs(angle_difference(npc.placement_angle, dish.current_angle))
			if diff < min_angle_diff:
				min_angle_diff = diff
				closest_dish = dish
		if closest_dish:
			var distance = npc.position.distance_to(closest_dish.position)
			var is_correct = false
			# Add a check to see if the dish has any quantity left
			if distance < serving_distance_threshold and closest_dish.quantity > 0:
				if closest_dish.item_name == npc.desired_item_name:
					is_correct = true
			npc.react(is_correct)
			# If the dish was correct, start the consumption timer
			if is_correct:
				print(npc.name + " is starting to eat " + closest_dish.item_name)
				closest_dish.start_consumption_effects(npc.consumption_timer)

func _on_susan_started_moving():
	# Reset all animations
	for node in get_children():
		if node is NPC:
			node.reset_emotion()
		elif node is Dish:
			node.stop_consumption_effects()

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

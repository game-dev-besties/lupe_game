extends Node2D

# --- Scene & Path Properties ---
@export var dish_scene = load("res://scenes/dish.tscn") as PackedScene
@export var npc_scene = load("res://scenes/NPC.tscn") as PackedScene
@export var ellipse_width: float = 400.0
@export var ellipse_height: float = 200.0

# --- Physics Properties ---
@export var max_scale: float = 1.2
@export var serving_distance_threshold_degrees: float = 2.0
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
	{"texture": preload("res://assets/food/rice.png"), "scale": 0.3, "item_name": "rice", "quantity": 3},
	{"texture": preload("res://assets/food/dumpling.png"), "scale": 0.3, "item_name": "dumpling", "quantity": 3},
	{"texture": preload("res://assets/food/eggroll.png"), "scale": 0.25, "item_name": "eggroll", "quantity": 3},
	{"texture": preload("res://assets/food/frieddumpling.png"), "scale": 0.3, "item_name": "frieddumpling", "quantity": 3},
	{"texture": preload("res://assets/food/duck.png"), "scale": 0.3, "item_name": "duck", "quantity": 3},
	{"texture": preload("res://assets/food/noodle.png"), "scale": 0.3, "item_name": "noodle", "quantity": 3},
]
var npc_desires = [
	{"name": "girl1", "desire": "rice", "timer": 5},
	{"name": "girl3", "desire": "rice", "timer": 1.5},
	{"name": "girl1", "desire": "rice", "timer": 5},
	{"name": "girl3", "desire": "rice", "timer": 1.5},
	{"name": "girl3", "desire": "rice", "timer": 1.5},
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
	# for each npc calculate what to do with dish
	for npc in npcs:
		# distance between dish and npc
		var closest_dish: Dish = null
		var min_angle_diff = INF
		for dish in dishes:
			var diff = abs(angle_difference(npc.placement_angle, dish.current_angle))
			if diff < min_angle_diff:
				min_angle_diff = diff
				closest_dish = dish
		# find desired dish nearby
		if closest_dish:
			var diff = abs(angle_difference(npc.placement_angle, closest_dish.current_angle))
			var can_eat = false
			# Check all conditions: close enough, correct item, dish has quantity, and npc is not full
			if diff < serving_distance_threshold_degrees and closest_dish.quantity > 0:
				if closest_dish.item_name == npc.desired_item_name and npc.satiation < npc.MAX_SATIATION:
					can_eat = true
			if can_eat:
				closest_dish.start_consumption(npc.consumption_timer, npc)

func _on_susan_started_moving():
	# Reset all animations and timers
	for node in get_children():
		if node is Dish:
			node.cancel_consumption()

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

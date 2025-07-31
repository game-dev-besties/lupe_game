class_name Dish
extends Area2D

@export var empty_plate_texture: Texture2D
@onready var consumption_particles: GPUParticles2D = $consumptionparticles
var active_wobble_tween: Tween
var active_consume_timer: Tween

# data variables
var item_name: String
var effect: String
var quantity: int


var ellipse_width: float = 400.0
var ellipse_height: float = 200.0
var angular_velocity: float = 0.0
var current_angle: float = 0.0

func init(data: Dictionary):
	var sprite: Sprite2D = get_node("Sprite2D")
	self.item_name = data.get("item_name", "Unknown Item")
	self.effect = data.get("effect", "none")
	self.quantity = data.get("quantity", 1)
	
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
		
func consume():
	stop_consumption_effects()
	if active_wobble_tween:
		active_wobble_tween.kill()
	rotation_degrees = 0 
	if quantity > 0:
		quantity -= 1
		print(item_name + " quantity is now: " + str(quantity))
	if quantity <= 0:
		_on_empty()

func stop_consumption_effects():
	if active_wobble_tween:
		active_wobble_tween.kill()
		active_wobble_tween = null
	if active_consume_timer:
		active_consume_timer.kill()
		active_consume_timer = null

	consumption_particles.emitting = false
	rotation_degrees = 0

func _on_empty():
	print(item_name + " is now empty!")
	$Sprite2D.texture = empty_plate_texture
	# Make the dish un-clickable and un-desirable
	item_name = "Empty Plate"
	$CollisionShape2D.disabled = true 
	
func start_consumption_effects(duration: float):
	consumption_particles.emitting = true
	active_wobble_tween = create_tween().set_loops()
	active_wobble_tween.tween_property(self, "rotation_degrees", 5, 0.1).set_trans(Tween.TRANS_SINE)
	active_wobble_tween.tween_property(self, "rotation_degrees", -5, 0.1).set_trans(Tween.TRANS_SINE)
	active_wobble_tween.tween_property(self, "rotation_degrees", 0, 0.1).set_trans(Tween.TRANS_SINE)
	var consume_timer = create_tween()
	consume_timer.tween_callback(self.consume).set_delay(duration)

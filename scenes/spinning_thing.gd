extends Sprite2D

# Spinning properties
var angular_velocity: float = 0.0
const max_angular_velocity: float = 25.0  # Maximum spin speed (radians per second)
const acceleration: float = 15.0          # How fast it accelerates
const natural_friction: float = 4.0       # Natural slowdown when no input
const brake_force: float = 8.0            # How strong the space brake is

func _ready():
	# Optional: Set the pivot point to center if needed
	# This ensures rotation happens around the center of the sprite
	pass

func _process(delta):
	handle_input(delta)
	apply_physics(delta)
	
	# Apply the rotation
	rotation += angular_velocity * delta

func handle_input(delta):
	var input_force = 0.0
	
	# Check for acceleration inputs
	if Input.is_action_pressed("ui_left"):
		input_force -= acceleration
	if Input.is_action_pressed("ui_right"):
		input_force += acceleration
	
	# Apply acceleration
	if input_force != 0:
		angular_velocity += input_force * delta
		# Clamp to maximum speed
		angular_velocity = clamp(angular_velocity, -max_angular_velocity, max_angular_velocity)

func apply_physics(delta):
	# Apply braking when space is pressed
	if Input.is_action_pressed("ui_accept"):  # Space bar
		var brake_direction = -sign(angular_velocity)
		var brake_amount = brake_force * brake_direction * delta
		
		# Don't overshoot and reverse direction
		if abs(brake_amount) > abs(angular_velocity):
			angular_velocity = 0.0
		else:
			angular_velocity += brake_amount
	else:
		# Apply natural friction when not braking
		if angular_velocity != 0:
			var friction_direction = -sign(angular_velocity)
			var friction_amount = natural_friction * friction_direction * delta
			
			# Don't overshoot and reverse direction
			if abs(friction_amount) > abs(angular_velocity):
				angular_velocity = 0.0
			else:
				angular_velocity += friction_amount

# Optional: Add these custom input actions to your Input Map
# Or modify the script to use different key bindings
func _input(event):
	# Alternative input handling using specific keys
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_A:
				# Handled in handle_input with ui_left
				pass
			KEY_D:
				# Handled in handle_input with ui_right  
				pass
			KEY_SPACE:
				# Handled in apply_physics with ui_accept
				pass

extends Sprite2D

# --- Ellipse Path Properties ---
# Set these in the Inspector to match the size of your gray oval sprite
@export var ellipse_width: float = 400.0
@export var ellipse_height: float = 200.0

# --- Spinning physics (Your existing code) ---
var angular_velocity: float = 0.0
const max_angular_velocity: float = 7.0
const acceleration: float = 5.0
const natural_friction: float = 1.0
const brake_force: float = 8.0

# --- Current position on the ellipse ---
var angle: float = 0.0

func _process(delta):
	# Calculate the angular velocity based on input
	handle_input(delta)
	apply_physics(delta)
	
	# Update the angle using the calculated velocity
	angle += angular_velocity * delta
	
	# Keep the angle within 0 to 2*PI range (optional, but good practice)
	angle = fmod(angle, TAU) # TAU is a constant for 2 * PI

	# Calculate position on the ellipse using parametric equations
	var radius_x = (ellipse_width) / 2.0
	var radius_y = (ellipse_height) / 2.0
	position.x = radius_x * cos(angle)
	position.y = radius_y * sin(angle)
	
	# --- Bonus: Make the sprite face its direction of travel ---
	#var tangent_angle = atan2(radius_y * cos(angle), -radius_x * sin(angle))
	#rotation = tangent_angle

	# --- Bonus: Make the sprite go "behind" the top of the oval ---
	# Assumes the OvalPath sprite has a z_index of 0
	if position.y < 0:
		z_index = -1 # Go behind the oval
	else:
		z_index = 1  # Go in front of the oval

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
	if Input.is_action_pressed("ui_accept"): # Space bar
		friction = brake_force
	
	if angular_velocity != 0:
		angular_velocity = move_toward(angular_velocity, 0, friction * delta)

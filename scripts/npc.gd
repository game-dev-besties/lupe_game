class_name NPC
extends Node2D

@onready var pop = $pop
@onready var hum = $hum
@export var game_object: Node2D

const MAX_SATIATION = 40
const GET_HUNGRY_PROBABILITY = 0.3
var TIME_BETWEEN_HUNGRY_CHECKS_SECONDS = 2.5
const TIME_BETWEEN_HEALTH_DAMAGE_SECONDS = 3.0
const TIME_BETWEEN_TEA_CHECKS_SECONDS = 3.0
const DRINK_TEA_PROBABILITY = 0.2

var satiation: float = MAX_SATIATION
var check_hungry_timer: float = TIME_BETWEEN_HUNGRY_CHECKS_SECONDS
var take_damage_timer: float = TIME_BETWEEN_HEALTH_DAMAGE_SECONDS
var desired_item_name: String
var consumption_timer: float
var tea_check_timer: float = TIME_BETWEEN_TEA_CHECKS_SECONDS
var current_state: String = "happy"
var happy_animation: String
var neutral_animation: String
var unhappy_animation: String
var placement_angle: float
var hunger_diminish_rates = {
	Teacup.Fullness.EMPTY: 30.0,
	Teacup.Fullness.HALF: 12.0,
	Teacup.Fullness.FULL: 4.0,
	"default": 6.0,
}
var hunger_diminish_rate: float = hunger_diminish_rates[Teacup.Fullness.EMPTY]
var turn_red_rate: float = 0.05
var max_redness: float = 0.5
var spawn_position: Vector2
var shake_tween: Tween
var my_teacup: Teacup
var modifiers = []
var modifier_anger_active: bool = false
var modifier_anger_timer: float = 0.0
var angry_state = "no"
var angry_dmg = false
var is_eating: bool = false


@export var serving_distance_threshold_radians: float = 30.0 * (PI / 180.0)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func init(data: Dictionary):
	self.name = data.get("name", "NPC")
	self.desired_item_name = ""
	self.current_state = "happy"
	self.consumption_timer = data.get("timer", 1.0)
	if data.has("hunger_timer"):
		TIME_BETWEEN_HUNGRY_CHECKS_SECONDS = data.get("hunger_timer", 3.0)
		check_hungry_timer = TIME_BETWEEN_HUNGRY_CHECKS_SECONDS
	happy_animation = self.name + "_happy"
	neutral_animation = self.name + "_neutral"
	unhappy_animation = self.name + "_unhappy"
	var humm: AudioStreamPlayer2D = get_node("hum")
	humm.stream = data.get("sound")
func _ready():
	modifiers = LevelManager.get_current_level_data().get("modifiers")
	if modifiers.has("tea"):
		hunger_diminish_rate = hunger_diminish_rates[Teacup.Fullness.EMPTY]
	else:
		hunger_diminish_rate = hunger_diminish_rates["default"]
	spawn_position = position
	update_emotion()

func _process(delta: float):
	var game_script = game_object as Game
	var spinningthing = game_object.get_node("spinningthing")
	# grandma logic
	if modifier_anger_active:
		shake()
		modifier_anger_timer -= delta
		if modifier_anger_timer <= 0:
			modifier_anger_active = false
			angry_state = "no"
			position = spawn_position
			sprite.modulate.s = 0
			if shake_tween:
				shake_tween.kill()
			update_emotion()
			angry_dmg = false
	if modifiers.has("clockwise") and self.name == "aunt2" and spinningthing.angular_velocity < -0.2 and not modifier_anger_active:
		modifier_anger_active = true
		modifier_anger_timer = 5.0 
		sprite.play(self.name + "_angry")
		angry_state = "angry"
		sprite.modulate.s = max_redness
	# If the NPC has a teacup, check its state
	if my_teacup and modifiers.has("tea"):
		# Update teacup timer
		if tea_check_timer > 0:
			tea_check_timer -= delta
		else:
			print("Can Drink Tea")
			if my_teacup.fullness != Teacup.Fullness.EMPTY and randf() < DRINK_TEA_PROBABILITY:
				print("Drinking Tea!")
				my_teacup.drink()
			tea_check_timer = TIME_BETWEEN_TEA_CHECKS_SECONDS

	# If the current state is "happy", we might randomly decide to change to "neutral"
	if current_state == "happy":
		if check_hungry_timer > 0:
			check_hungry_timer -= delta
		else:
			if randf() < GET_HUNGRY_PROBABILITY:
				current_state = "neutral"
				
				var all_requests = {}
					
				for node in get_parent().get_children():
					if node is NPC:
						if node.current_state != "happy" and node.desired_item_name != "":
							var current_count = all_requests.get(node.desired_item_name, 0)
							all_requests[node.desired_item_name] = current_count + 1
				
				var available_dishes = []
				for node in get_parent().get_children():
					if node is Dish:
						var number_of_requests = all_requests.get(node.item_name, 0)
						var remaining_quantity = node.quantity - number_of_requests
						# Add dishes to available list based on remaining quantity
						for i in range(remaining_quantity):
							available_dishes.append(node.item_name)

				if available_dishes.size() > 0:
					desired_item_name = available_dishes[randi() % available_dishes.size()]
					# If the susan isn't rotating, we can look for a dish
					spinningthing = game_object.get_node("spinningthing")
					if not spinningthing.is_rotating:
						look_for_dish()
				else:
					current_state = "happy"
				update_food_item_display()
			check_hungry_timer = TIME_BETWEEN_HUNGRY_CHECKS_SECONDS
	else:
		# Diminish satiation over time (only if not currently eating)
		if satiation > 0 and not is_eating:
			satiation -= hunger_diminish_rate * delta
			if satiation <= MAX_SATIATION * 2 / 3:
				current_state = "unhappy"
			if satiation <= MAX_SATIATION / 3:
				if sprite.modulate.s <= max_redness:
					# equation to determine how fast they turn need to turn red in order to reach max_redness
					sprite.modulate.s += ((3 * max_redness * hunger_diminish_rate ) / MAX_SATIATION) * delta 
			if satiation <= 0:
				sprite.modulate.s = max_redness
				current_state = "starving"
				satiation = 0
				#print(name + " is now starving!")
	if angry_state == "angry" and not angry_dmg:
			game_script.take_damage()
			game_script.take_damage()
			game_script.take_damage()
			angry_dmg = true

	# Handle the timer for taking damage
	if current_state == "starving":
		shake()
		if take_damage_timer > 0:
			take_damage_timer -= delta
		else:
			game_script.take_damage()
			take_damage_timer = TIME_BETWEEN_HEALTH_DAMAGE_SECONDS
			# Here you could implement logic to reduce health or trigger an event
			print(name + " is starving and you are taking damage!")
	else:
		take_damage_timer = TIME_BETWEEN_HEALTH_DAMAGE_SECONDS  # Reset the timer if not unhappy
	
	# Update the sprite animation based on the current state
	update_emotion()

	# Update thought bubble satiation visual fill up thing
	var tinted_thought_bubble = $ThoughtBubble/TintedThoughtBubble
	(tinted_thought_bubble as BubbleFill).set_fill((MAX_SATIATION - satiation) / MAX_SATIATION)

func start_eating():
	is_eating = true
	pop.play()
	if shake_tween:
		shake_tween.kill()
	var tween = create_tween()
	tween.tween_property(self, "position", spawn_position - Vector2(0, 20), 0.2)
	tween.tween_property(self, "position", spawn_position, 0.2)
	
func shake():
	if shake_tween:
		shake_tween.kill()
	shake_tween = create_tween().set_loops()
	var shake_max = 10
	var shake_x = randf_range(-shake_max, shake_max)
	var shake_y = randf_range(-shake_max, shake_max)
	shake_tween.tween_property(self, "position", spawn_position + Vector2(shake_x, shake_y), 0.1)
	shake_tween.tween_property(self, "position", spawn_position, 0.1)

func eat():
	is_eating = false
	current_state = "happy"
	satiation = MAX_SATIATION
	position = spawn_position
	sprite.modulate.s = 0
	check_hungry_timer = TIME_BETWEEN_HUNGRY_CHECKS_SECONDS
	desired_item_name = ""
	update_emotion()
	update_food_item_display()

func cancel_eating():
	is_eating = false

func update_emotion():
	if angry_state == "angry":
		return
	if current_state == "happy":
		if shake_tween:
			shake_tween.kill()
		sprite.play(happy_animation)
	elif current_state == "neutral":
		if shake_tween:
			shake_tween.kill()
		sprite.play(neutral_animation)
	elif current_state == "unhappy" or current_state == "starving":
		sprite.play(unhappy_animation)

func update_food_item_display():
	# This node has a child called "ThoughtBubble" and that has a Sprite2D child called "FoodImage"
	# The images we want are in the "res://assets/food/" folder
	var food_image_node: Sprite2D = $ThoughtBubble/FoodImage
	if desired_item_name != "":
		# Display the ThoughBubble and set the food image
		hum.play()
		$ThoughtBubble.visible = true
		food_image_node.texture = load("res://assets/food/" + desired_item_name + ".png")
		food_image_node.visible = true
	else:
		# Hide the ThoughtBubble if there's no desired item
		
		$ThoughtBubble.visible = false
		food_image_node.visible = false

func on_teacup_state_changed(new_state: Teacup.Fullness):
	#print(name + "'s teacup is now: " + Teacup.Fullness.keys()[new_state])
	if modifiers.has("tea"):
		hunger_diminish_rate = hunger_diminish_rates[new_state]

func look_for_dish():
	var spinningthing = game_object.get_node("spinningthing")
	var children = spinningthing.get_children()
	var dishes = []
	for node in children:
		if node is Dish:
			dishes.append(node)

	var closest_dish: Dish = null
	var min_angle_diff = INF
	for dish in dishes:
		var diff = abs(angle_difference(placement_angle, dish.current_angle))
		if diff < min_angle_diff:
			min_angle_diff = diff
			closest_dish = dish
	if closest_dish:
		var diff = abs(angle_difference(placement_angle, closest_dish.current_angle))
		var can_eat = false
		# Check all conditions: close enough, correct item, dish has quantity, and npc is not full
		if diff < serving_distance_threshold_radians and closest_dish.quantity > 0:
			if closest_dish.item_name == desired_item_name and current_state != "happy":
				can_eat = true
		#print(name + " is looking for a dish. Closest dish: " + closest_dish.item_name + ", angle difference: " + str(diff) + ", can eat: " + str(can_eat))
		if can_eat and closest_dish.start_consumption(consumption_timer, self):
			print(name + " is starting to eat " + closest_dish.item_name)
			start_eating()

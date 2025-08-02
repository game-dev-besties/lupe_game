class_name NPC
extends Node2D

#@export var neutral_texture: Texture2D
#@export var happy_texture: Texture2D
#@export var unhappy_texture: Texture2D

@export var game_object: Node2D

const MAX_SATIATION = 40
const GET_HUNGRY_PROBABILITY = 0.2
const TIME_BETWEEN_HUNGRY_CHECKS_SECONDS = 3.0
const TIME_BETWEEN_HEALTH_DAMAGE_SECONDS = 5.0
var satiation: float = MAX_SATIATION
var check_hungry_timer: float = TIME_BETWEEN_HUNGRY_CHECKS_SECONDS
var take_damage_timer: float = TIME_BETWEEN_HEALTH_DAMAGE_SECONDS
var desired_item_name: String
var placement_angle: float 
var consumption_timer: float
var current_state: String = "happy"
var happy_animation: String
var neutral_animation: String
var unhappy_animation: String
var hunger_diminish_rate: float = 2
var turn_red_rate: float = 0.05
var max_redness: float = 0.5
var spawn_position: Vector2
var shake_tween: Tween

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func init(data: Dictionary):
	self.name = data.get("name", "NPC")
	self.desired_item_name = data.get("desire", "")
	self.consumption_timer = data.get("timer", 1.0)
	happy_animation = self.name + "_happy"
	neutral_animation = self.name + "_neutral"
	unhappy_animation = self.name + "_unhappy"

func _ready():
	spawn_position = position
	update_emotion()

func _process(delta: float):
	var game_script = game_object as Game
	# If the current state is "happy", we might randomly decide to change to "neutral"
	if current_state == "happy":
		if check_hungry_timer > 0:
			check_hungry_timer -= delta
		else:
			if randf() < GET_HUNGRY_PROBABILITY:
				current_state = "neutral"
				
				var all_requests = {}
				for item in game_script.POSSIBLE_ITEMS:
					all_requests[item] = 0
					
				for node in get_parent().get_children():
					if node is NPC:
						if node.current_state != "happy" and node.desired_item_name in all_requests:
							all_requests[node.desired_item_name] += 1
				
				var dishes_on_the_table = []
				for node in get_parent().get_children():
					if node is Dish:
						var number_of_requests = 0
						if node.item_name in all_requests:
							number_of_requests = all_requests[node.item_name]
						if node.quantity - number_of_requests > 0:
							dishes_on_the_table.append(node.item_name)
					#if node is NPC:
						#if node.current_state != "happy":
							#dishes_on_the_table.append(node.desired_item_name)
				
				if dishes_on_the_table.size() > 0:
					desired_item_name = dishes_on_the_table[randi() % dishes_on_the_table.size()]
				else:
					current_state = "happy"
					
				update_food_item_display()
			check_hungry_timer = TIME_BETWEEN_HUNGRY_CHECKS_SECONDS
	else:
		# Diminish satiation over time
		if satiation > 0:
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
				print(name + " is now starving!")
	
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

func start_eating():
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
	current_state = "happy"
	satiation = MAX_SATIATION
	position = spawn_position
	sprite.modulate.s = 0
	check_hungry_timer = TIME_BETWEEN_HUNGRY_CHECKS_SECONDS
	desired_item_name = ""
	update_emotion()
	update_food_item_display()

func update_emotion():
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
		$ThoughtBubble.visible = true
		food_image_node.texture = load("res://assets/food/" + desired_item_name + ".png")
		food_image_node.visible = true
	else:
		# Hide the ThoughtBubble if there's no desired item
		$ThoughtBubble.visible = false
		food_image_node.visible = false
		

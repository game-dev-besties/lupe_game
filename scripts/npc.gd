class_name NPC
extends Node2D

#@export var neutral_texture: Texture2D
#@export var happy_texture: Texture2D
#@export var unhappy_texture: Texture2D

@export var game_object: Node2D

const MAX_SATIATION = 30
const GET_HUNGRY_PROBABILITY = 0.5
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

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func init(data: Dictionary):
	self.name = data.get("name", "NPC")
	self.desired_item_name = data.get("desire", "")
	self.consumption_timer = data.get("timer", 1.0)
	happy_animation = self.name + "_happy"
	neutral_animation = self.name + "_neutral"
	unhappy_animation = self.name + "_unhappy"

func _ready():
	update_emotion()

func _process(delta: float):
	var game_script = game_object as Game
	# If the current state is "happy", we might randomly decide to change to "neutral"
	if current_state == "happy":
		if check_hungry_timer > 0:
			check_hungry_timer -= delta
		else:
			print("Checking if we should become hungry: " + name)
			if randf() < GET_HUNGRY_PROBABILITY:
				print("" + name + " is ordering something!")
				current_state = "neutral"
				desired_item_name = game_script.POSSIBLE_ITEMS[randi() % game_script.POSSIBLE_ITEMS.size()]
				update_food_item_display()
			check_hungry_timer = TIME_BETWEEN_HUNGRY_CHECKS_SECONDS
	elif current_state == "neutral" or current_state == "unhappy":
		# Diminish satiation over time
		if satiation > 0:
			satiation -= hunger_diminish_rate * delta
			if satiation <= 0:
				satiation = 0
				current_state = "unhappy"
				print(name + " is now unhappy due to hunger!")
	
	# Handle the timer for taking damage
	if current_state == "unhappy":
		if take_damage_timer > 0:
			take_damage_timer -= delta
		else:
			game_script.take_damage()
			take_damage_timer = TIME_BETWEEN_HEALTH_DAMAGE_SECONDS
			# Here you could implement logic to reduce health or trigger an event
			print(name + " is unhappy and you are taking damage!")
	else:
		take_damage_timer = TIME_BETWEEN_HEALTH_DAMAGE_SECONDS  # Reset the timer if not unhappy
	
	# Update the sprite animation based on the current state
	update_emotion()

func eat():
	current_state = "happy"
	satiation = MAX_SATIATION
	check_hungry_timer = TIME_BETWEEN_HUNGRY_CHECKS_SECONDS
	desired_item_name = ""
	update_emotion()
	update_food_item_display()

# func react(is_correct_dish: bool):
# 	if is_correct_dish:
# 		sprite.play(happy_animation)
# 		print(name + " is happy!")
# 	else:
# 		sprite.play(unhappy_animation)
# 		print(name + " is unhappy!")

func update_emotion():
	if current_state == "happy":
		sprite.play(happy_animation)
	elif current_state == "neutral":
		sprite.play(neutral_animation)
	elif current_state == "unhappy":
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

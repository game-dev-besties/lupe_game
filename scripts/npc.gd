class_name NPC
extends Node2D

@export var neutral_texture: Texture2D
@export var happy_texture: Texture2D
@export var unhappy_texture: Texture2D

var desired_item_name: String
var placement_angle: float 

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	# Start with a neutral expression
	reset_emotion()

func react(is_correct_dish: bool):
	if is_correct_dish:
		sprite.texture = happy_texture
		print(name + " is happy!")
	else:
		sprite.texture = unhappy_texture
		print(name + " is unhappy!")

func reset_emotion():
	sprite.texture = neutral_texture

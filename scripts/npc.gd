class_name NPC
extends Node2D

@export var neutral_texture: Texture2D
@export var happy_texture: Texture2D
@export var unhappy_texture: Texture2D

const MAX_SATIATION = 10
var satiation: int = 0
var desired_item_name: String
var placement_angle: float 
var consumption_timer: float

@onready var sprite: Sprite2D = $Sprite2D

func init(data: Dictionary):
	self.name = data.get("name", "NPC")
	self.desired_item_name = data.get("desire", "")
	self.consumption_timer = data.get("timer", 1.0)
	self.satiation = data.get("satiation", 0)

func _ready():
	update_emotion()

func eat(satiation_value: int):
	if satiation < MAX_SATIATION:
		satiation = min(satiation + satiation_value, MAX_SATIATION)
		print(name + "'s satiation is now: " + str(satiation))
		update_emotion()

func react(is_correct_dish: bool):
	if is_correct_dish:
		sprite.texture = happy_texture
		print(name + " is happy!")
	else:
		sprite.texture = unhappy_texture
		print(name + " is unhappy!")

func update_emotion():
	if satiation >= MAX_SATIATION:
		sprite.texture = happy_texture 
	elif satiation > 0:
		sprite.texture = neutral_texture 
	else:
		sprite.texture = unhappy_texture 

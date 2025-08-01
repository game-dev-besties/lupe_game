class_name NPC
extends Node2D

#@export var neutral_texture: Texture2D
#@export var happy_texture: Texture2D
#@export var unhappy_texture: Texture2D

const MAX_SATIATION = 10
var satiation: int = 0
var desired_item_name: String
var placement_angle: float 
var consumption_timer: float
var happy_animation: String
var neutral_animation: String
var unhappy_animation: String

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func init(data: Dictionary):
	self.name = data.get("name", "NPC")
	self.desired_item_name = data.get("desire", "")
	self.consumption_timer = data.get("timer", 1.0)
	self.satiation = data.get("satiation", 0)
	happy_animation = self.name + "_happy"
	neutral_animation = self.name + "_neutral"
	unhappy_animation = self.name + "_unhappy"

func _ready():
	update_emotion()

func eat(satiation_value: int):
	if satiation < MAX_SATIATION:
		satiation = min(satiation + satiation_value, MAX_SATIATION)
		print(name + "'s satiation is now: " + str(satiation))
		update_emotion()

func start_eating():
	#$AnimationPlayer.play("start_eating")
	var tween = create_tween()
	var current_pos = position
	tween.tween_property(self, "position", position - Vector2(0, 20), 0.2)
	tween.tween_property(self, "position", current_pos, 0.2)

func react(is_correct_dish: bool):
	if is_correct_dish:
		sprite.play(happy_animation)
		print(name + " is happy!")
	else:
		sprite.play(unhappy_animation)
		print(name + " is unhappy!")

func update_emotion():
	if satiation >= MAX_SATIATION:
		sprite.play(happy_animation)
	elif satiation > 0:
		sprite.play(neutral_animation)
	else:
		sprite.play(unhappy_animation)

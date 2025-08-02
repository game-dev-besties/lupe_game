class_name Game
extends Node2D

@export var health_bar: ProgressBar

const POSSIBLE_ITEMS = [
	"rice", "dumpling", "eggroll", "frieddumpling", "duck", "noodle"
]

var health: int = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition/AnimationPlayer.play("fade_in")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	health_bar.value = health

func take_damage():
	if health > 0:
		health -= 10
		if health == 0:
			# TODO: Handle game over logic
			pass

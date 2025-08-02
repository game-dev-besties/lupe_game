class_name Game
extends Node2D

const POSSIBLE_ITEMS = [
	"rice", "dumpling", "eggroll", "frieddumpling", "duck", "noodle"
]

var health: int = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func take_damage():
	if health > 0:
		health -= 1
		if health == 0:
			# TODO: Handle game over logic
			pass

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
	health_bar.value = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func take_damage():
	if health > 0:
		health -= 10
		health_bar.value = health
		if health == 0:
			$Transition/AnimationPlayer.play("fade_out")
			await get_tree().create_timer(0.7).timeout
			get_tree().change_scene_to_packed(load("res://scenes/game_loss.tscn"))

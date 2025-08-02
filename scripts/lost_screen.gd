extends Node2D

@onready var game = load("res://scenes/game.tscn") as PackedScene

func _ready():
	$Transition/AnimationPlayer.play("fade_in")

func _try_again() -> void:
	$Transition/AnimationPlayer.play("fade_out")
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_packed(game)

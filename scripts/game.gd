class_name Game
extends Node2D

@export var health_bar: ProgressBar

var health: int = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Transition/AnimationPlayer.play("fade_in")
	health_bar.value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func take_damage():
	if health > 0:
		health -= 5
		health_bar.value = health
		if health <= 0:
			Transition.transition()
			await Transition.on_transition_finished
			get_tree().change_scene_to_packed(load("res://scenes/game_loss.tscn"))

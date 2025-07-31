extends Node2D
@onready var game = load("res://scenes/game.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Cutscene1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_skip_pressed():
	get_tree().change_scene_to_packed(game)

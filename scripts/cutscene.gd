extends Node2D
@onready var game = load("res://scenes/game.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition/AnimationPlayer.play("fade_in")
	$AnimationPlayer.play("Cutscene1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("ui_select"):
		end_cutscene()
	
func end_cutscene():
	$Transition/AnimationPlayer.play("fade_out")
	$AnimationPlayer.play("stop")
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_packed(game)

func _on_skip_pressed():
	end_cutscene()

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "Cutscene1"):
		end_cutscene()

extends Node2D
@onready var game = load("res://scenes/game.tscn") as PackedScene
@onready var text: RichTextLabel = $UI/Panel/VBoxContainer/RichTextLabel
@onready var animation: AnimationPlayer = $AnimationPlayer

var chapter: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition/AnimationPlayer.play("fade_in")
	animation.play("Cutscene1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if animation.is_playing():
			animation.pause()
			text.visible_ratio = 1
		else:
			chapter += 1
			if (chapter > 3):
				end_cutscene()
			else:
				animation.play("Cutscene" + str(chapter))
	elif Input.is_action_just_pressed("ui_cancel"):
		end_cutscene()
	
func end_cutscene():
	$Transition/AnimationPlayer.play("fade_out")
	animation.play("stop")
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_packed(game)

func _on_skip_pressed():
	end_cutscene()

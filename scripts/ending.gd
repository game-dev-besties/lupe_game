extends Node2D
@onready var menu = load("res://scenes/main_menu.tscn") as PackedScene

func _ready():
	$Exit.visible = false
	$ThanksForPlaying.visible = false
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$Exit.visible = true
		$ThanksForPlaying.visible = true

func _on_menu_button_mouse_entered() -> void:
	$Exit.scale += Vector2(0.05, 0.05)

func _on_menu_button_mouse_exited() -> void:
	$Exit.scale -= Vector2(0.05, 0.05)


func _on_menu_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_packed(menu)

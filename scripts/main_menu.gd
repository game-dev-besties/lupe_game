extends Node2D
var original_position: Vector2
var soriginal_position: Vector2
@onready var button = $button

func _ready() -> void:
	original_position = $CreditsText.position
	soriginal_position = $StartGameText.position

func _on_start_game_button_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($StartGameText, "position", soriginal_position - Vector2(20, 0), 0.1)

func _on_start_game_button_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($StartGameText, "position", soriginal_position, 0.1)

func _on_start_game_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		button.play()
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/cutscene.tscn")

func _on_credits_button_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($CreditsText, "position", original_position - Vector2(20, 0), 0.1)
func _on_credits_button_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($CreditsText, "position", original_position, 0.1)
	
func _on_credits_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		button.play()
		print("credits pressed")
		get_tree().change_scene_to_file("res://scenes/credits.tscn")

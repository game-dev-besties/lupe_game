extends Node2D


func _on_start_game_button_mouse_entered() -> void:
	$StartGameText.scale += Vector2(0.1, 0.1)

func _on_start_game_button_mouse_exited() -> void:
	$StartGameText.scale -= Vector2(0.1, 0.1)

func _on_start_game_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/cutscene.tscn")

func _on_credits_button_mouse_entered() -> void:
	$CreditsText.scale += Vector2(0.1, 0.1)

func _on_credits_button_mouse_exited() -> void:
	$CreditsText.scale -= Vector2(0.1, 0.1)
	
func _on_credits_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print("credits pressed")

extends Node2D
var original_position: Vector2

func _ready() -> void:
	original_position = $"Back Text".position

func _on_back_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print("back pressed")
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_back_button_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($"Back Text", "position", original_position - Vector2(20, 0), 0.1)
func _on_back_button_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($"Back Text", "position", original_position, 0.1)

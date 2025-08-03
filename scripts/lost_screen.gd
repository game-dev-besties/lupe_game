extends Node2D

@onready var game = load("res://scenes/game.tscn") as PackedScene
@onready var menu = load("res://scenes/main_menu.tscn") as PackedScene
@onready var flute = $flute

const ending_chapters = [1, 5, 8, 12, 14]

func _ready():
	flute.play()
	$Transition/AnimationPlayer.play("fade_in")

func menu_button() -> void:
	$Transition/AnimationPlayer.play("fade_out")
	await get_tree().create_timer(0.7).timeout
	get_tree().change_scene_to_packed(game)

func _on_try_again_button_mouse_entered() -> void:
	$UI/TryAgain.scale += Vector2(0.05, 0.05)

func _on_try_again_button_mouse_exited() -> void:
	$UI/TryAgain.scale -= Vector2(0.05, 0.05)

func _on_try_again_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_packed(game)


func _on_menu_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Transition.transition()
		await Transition.on_transition_finished
		var current_chapter = LevelManager.get_current_chapter()
		var position = ending_chapters.find(current_chapter)
		LevelManager.set_current_chapter(ending_chapters[position - 1])
		get_tree().change_scene_to_packed(menu)


func _on_menu_button_mouse_entered() -> void:
	$UI/Exit.scale += Vector2(0.05, 0.05)


func _on_menu_button_mouse_exited() -> void:
	$UI/Exit.scale -= Vector2(0.05, 0.05)

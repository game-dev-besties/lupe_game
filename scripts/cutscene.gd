extends Node2D
@onready var game = load("res://scenes/game.tscn") as PackedScene
@onready var text: RichTextLabel = $UI/Panel/VBoxContainer/RichTextLabel
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var talking_effect = $talking

var chapter: int
const end_chapter_nums = [1, 5, 8, 12, 15]
const max_chapters = 14

# Called when the node enters the scene tree for the first time.
func _ready():
	chapter = LevelManager.get_current_chapter()
	$UI/Panel.visible = false
	if (chapter <= max_chapters):
		animation.play("Cutscene" + str(chapter))
		talking_effect.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if animation.is_playing():
			animation.pause()
			text.visible_ratio = 1
			if (end_chapter_nums.has(chapter)):
				$UI/Panel.visible = true
				$Characters/Susan.position = Vector2(402, 393)
			elif (end_chapter_nums.has(chapter+1)):
				$tutorialbox.position = Vector2(588, 317)
				$UI/Panel.position = Vector2(346, 700)
				$Characters/Susan.position = Vector2(402, 900)
		else:
			chapter += 1
			if (end_chapter_nums.has(chapter)):
				end_cutscene()
			else:
				animation.play("Cutscene" + str(chapter))
				if !((end_chapter_nums).has(chapter+1)):
					talking_effect.play()
	
	elif Input.is_action_just_pressed("ui_cancel"):
		end_cutscene()
	
func end_cutscene():
	animation.pause()
	animation.play("stop")
	LevelManager.set_current_chapter(chapter)
	LevelManager.advance_to_next_level(true)

func _on_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		end_cutscene()


func _on_button_mouse_entered() -> void:
	$SkipButton.scale += Vector2(0.1, 0.1) 


func _on_button_mouse_exited() -> void:
	$SkipButton.scale -= Vector2(0.1, 0.1)

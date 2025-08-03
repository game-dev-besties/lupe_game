extends Node

const GAME_SCENE_PATH = "res://scenes/game.tscn"
var current_level_index: int = 0
var current_chapter: int = 1

var levels = [
	# --- LEVEL 1 ---
	{
		"dishes": [
			{"texture": preload("res://assets/food/friedrice.png"), "scale": 0.3, "item_name": "friedrice", "quantity": 2},
			{"texture": preload("res://assets/food/duck.png"), "scale": 0.3, "item_name": "duck", "quantity": 2},
			{"texture": preload("res://assets/food/bokchoy.png"), "scale": 0.3, "item_name": "bokchoy", "quantity": 2}
		],
		"npcs": [
			{"name": "brother1", "desire": "rice", "timer": 1, "sound": preload("res://assets/sfx/malegrunt.mp3")},
			{"name": "mother1", "desire": "rice", "timer": 1.5, "sound": preload("res://assets/sfx/girlhum.mp3")},
			{"name": "father1", "desire": "rice", "timer": 1, "sound": preload("res://assets/sfx/malegrunt.mp3")},
		],
		"modifiers" : [],
		"cutscene_path": "res://scenes/cutscene.tscn",
		"hunger_timer": 2.0,
	},
	# --- LEVEL 2 ---
	{
		"dishes": [
			{"texture": preload("res://assets/food/rice.png"), "scale": 0.3, "item_name": "rice", "quantity": 3},
			{"texture": preload("res://assets/food/dumpling.png"), "scale": 0.3, "item_name": "dumpling", "quantity": 3},
			{"texture": preload("res://assets/food/eggroll.png"), "scale": 0.25, "item_name": "eggroll", "quantity": 3},
			{"texture": preload("res://assets/food/frieddumpling.png"), "scale": 0.3, "item_name": "frieddumpling", "quantity": 3},
			{"texture": preload("res://assets/food/duck.png"), "scale": 0.3, "item_name": "duck", "quantity": 3},
			{"texture": preload("res://assets/food/noodle.png"), "scale": 0.3, "item_name": "noodle", "quantity": 3},
		],
		"npcs": [
			{"name": "brother1", "desire": "rice", "timer": 1, "sound": preload("res://assets/sfx/malegrunt.mp3")},
			{"name": "mother1", "desire": "rice", "timer": 1.5, "sound": preload("res://assets/sfx/girlhum.mp3")},
			{"name": "father1", "desire": "rice", "timer": 1, "sound": preload("res://assets/sfx/malegrunt.mp3")},
			{"name": "aunt1", "desire": "rice", "timer": 1.5, "sound": preload("res://assets/sfx/girlhum.mp3")},
			{"name": "uncle1", "desire": "rice", "timer": 1.5, "sound": preload("res://assets/sfx/malegrunt.mp3")},
		],
		"hunger_timer": 1.0,
		"cutscene_path": "res://scenes/cutscene.tscn",
		"modifiers" : ["tea"],
	},
	# --- LEVEL 3 ---
	{
		"dishes": [
			{"texture": preload("res://assets/food/rice.png"), "scale": 0.3, "item_name": "rice", "quantity": 3},
			{"texture": preload("res://assets/food/dumpling.png"), "scale": 0.3, "item_name": "dumpling", "quantity": 3},
			{"texture": preload("res://assets/food/eggroll.png"), "scale": 0.25, "item_name": "eggroll", "quantity": 3},
			{"texture": preload("res://assets/food/frieddumpling.png"), "scale": 0.3, "item_name": "frieddumpling", "quantity": 3},
			{"texture": preload("res://assets/food/duck.png"), "scale": 0.3, "item_name": "duck", "quantity": 3},
			{"texture": preload("res://assets/food/noodle.png"), "scale": 0.3, "item_name": "noodle", "quantity": 3},
		],
		"npcs": [
			{"name": "brother2", "desire": "rice", "timer": 1, "sound": preload("res://assets/sfx/malegrunt.mp3")},
			{"name": "aunt2", "desire": "rice", "timer": 1.5, "sound": preload("res://assets/sfx/girlhum.mp3")},
			{"name": "father2", "desire": "rice", "timer": 1, "sound": preload("res://assets/sfx/malegrunt.mp3")},
			{"name": "mother2", "desire": "rice", "timer": 1.5, "sound": preload("res://assets/sfx/girlhum.mp3")},
			{"name": "uncle2", "desire": "rice", "timer": 1.5, "sound": preload("res://assets/sfx/malegrunt.mp3")},
			{"name": "bwife1", "desire": "rice", "timer": 1.5, "sound": preload("res://assets/sfx/girlhum.mp3")},
		],
		"hunger_timer": 1.0,
		"cutscene_path": "res://scenes/cutscene.tscn",
		"modifiers" : ["clockwise", "tea"],
	},
	# --- LEVEL 4 ---
	{
		"dishes": [
			{"texture": preload("res://assets/food/rice.png"), "scale": 0.3, "item_name": "rice", "quantity": 3},
			{"texture": preload("res://assets/food/dumpling.png"), "scale": 0.3, "item_name": "dumpling", "quantity": 3},
			{"texture": preload("res://assets/food/eggroll.png"), "scale": 0.25, "item_name": "eggroll", "quantity": 3},
			{"texture": preload("res://assets/food/frieddumpling.png"), "scale": 0.3, "item_name": "frieddumpling", "quantity": 3},
			{"texture": preload("res://assets/food/duck.png"), "scale": 0.3, "item_name": "duck", "quantity": 3},
			{"texture": preload("res://assets/food/noodle.png"), "scale": 0.3, "item_name": "noodle", "quantity": 3},
		],
		"npcs": [
			{"name": "brother3", "desire": "rice", "timer": 1, "sound": preload("res://assets/sfx/malegrunt.mp3")},
			{"name": "aunt2", "desire": "rice", "timer": 1.5, "sound": preload("res://assets/sfx/girlhum.mp3")},
			{"name": "bwife2", "desire": "rice", "timer": 1.5, "sound": preload("res://assets/sfx/girlhum.mp3")},
			{"name": "mother3", "desire": "rice", "timer": 1, "sound": preload("res://assets/sfx/girlhum.mp3")},
			{"name": "father3", "desire": "rice", "timer": 1.5, "sound": preload("res://assets/sfx/malegrunt.mp3")},
			{"name": "husband", "desire": "rice", "timer": 1.5, "sound": preload("res://assets/sfx/malegrunt.mp3")},
		],
		"hunger_timer": 1.0,
		"cutscene_path": "res://scenes/cutscene.tscn",
		"modifiers" : ["tea", "clockwise"],
	},
	# --- todo: add more levels here ---
]

func get_current_level_data() -> Dictionary:
	if current_level_index < levels.size():
		return levels[current_level_index]
	return {}

func get_current_chapter():
	return current_chapter

func set_current_chapter(chapter):
	current_chapter = chapter

func advance_to_next_level(is_game = false):
	# Get the cutscene path from the level we JUST completed
	var level_data = get_current_level_data()
	print(current_level_index)
	var cutscene_path = level_data.get("cutscene_path")
	Transition.transition()
	await Transition.on_transition_finished
	if is_game:
		load_game_scene()
	else:
		if (cutscene_path):
			get_tree().change_scene_to_file("res://scenes/cutscene.tscn")
		current_level_index += 1

func load_game_scene():
	get_tree().change_scene_to_file(GAME_SCENE_PATH)

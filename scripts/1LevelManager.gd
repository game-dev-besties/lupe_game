extends Node

const GAME_SCENE_PATH = "res://scenes/game.tscn"
var current_level_index: int = 0

var levels = [
	# --- LEVEL 1 ---
	{
		"dishes": [
			{"texture": preload("res://assets/food/rice.png"), "scale": 0.3, "item_name": "rice", "quantity": 2},
			{"texture": preload("res://assets/food/dumpling.png"), "scale": 0.3, "item_name": "dumpling", "quantity": 2},
		],
		"npcs": [
			{"name": "girl1", "desire": "rice", "timer": 1},
			{"name": "girl3", "desire": "rice", "timer": 1.5},
			{"name": "girl1", "desire": "rice", "timer": 1},
			{"name": "girl3", "desire": "rice", "timer": 1.5},
			{"name": "girl3", "desire": "rice", "timer": 1.5},
			{"name": "girl3", "desire": "rice", "timer": 1.5},
			{"name": "girl3", "desire": "rice", "timer": 1.5},
		],
		"hunger_timer": 10.0,
		"cutscene_path": "res://scenes/cutscene.tscn",
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
			{"name": "girl1", "desire": "rice", "timer": 5},
			{"name": "girl3", "desire": "rice", "timer": 1.5},
			{"name": "girl1", "desire": "rice", "timer": 5},
			{"name": "girl3", "desire": "rice", "timer": 1.5},
			{"name": "girl3", "desire": "rice", "timer": 1.5},
		],
		"hunger_timer": 30.0,
		"cutscene_path": "res://scenes/cutscene.tscn",
	},
	# --- todo: add more levels here ---
]

func get_current_level_data() -> Dictionary:
	if current_level_index < levels.size():
		return levels[current_level_index]
	return {}

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
			get_tree().change_scene_to_file(cutscene_path)
		current_level_index += 1

func load_game_scene():
	get_tree().change_scene_to_file(GAME_SCENE_PATH)

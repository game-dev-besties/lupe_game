extends Node

var current_level_index: int = 0

var levels = [
	# --- LEVEL 1 ---
	{
		"dishes": [
			{"texture": preload("res://assets/food/rice.png"), "scale": 0.3, "item_name": "rice", "quantity": 2},
			{"texture": preload("res://assets/food/dumpling.png"), "scale": 0.3, "item_name": "dumpling", "quantity": 2},
		],
		"npcs": [
			{"name": "girl1", "desire": "rice", "timer": 5},
			{"name": "girl3", "desire": "rice", "timer": 1.5},
			{"name": "girl1", "desire": "rice", "timer": 5},
			{"name": "girl3", "desire": "rice", "timer": 1.5},
			{"name": "girl3", "desire": "rice", "timer": 1.5},
		],
		"hunger_timer": 5.0
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
		"hunger_timer": 30.0
	},
	# --- todo: add more levels here ---
]


func get_current_level_data() -> Dictionary:
	if current_level_index < levels.size():
		return levels[current_level_index]
	return {}

func advance_to_next_level():
	current_level_index += 1
	get_tree().reload_current_scene()

class_name Teacup
extends Area2D

@export var empty_texture: Texture2D
@export var half_full_texture: Texture2D
@export var full_texture: Texture2D
@onready var sprite: Sprite2D = $Sprite2D

enum Fullness {EMPTY, HALF, FULL}
var fullness: Fullness = Fullness.EMPTY
var owner_npc: NPC

func _ready():
	update_texture()

func fill():
	if fullness < Fullness.FULL:
		fullness += 2
		update_texture()
		if owner_npc:
			owner_npc.on_teacup_state_changed(fullness)

func update_texture():
	match fullness:
		Fullness.EMPTY:
			sprite.texture = empty_texture
		Fullness.HALF:
			sprite.texture = half_full_texture
		Fullness.FULL:
			sprite.texture = full_texture
		

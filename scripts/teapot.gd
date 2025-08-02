class_name Teapot
extends Area2D

var is_dragging: bool = false
var home_position: Vector2

func _ready():
	home_position = global_position
	connect("input_event", _on_input_event)

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = event.pressed
		if not event.pressed:
			_on_drag_released()

func _on_drag_released():
	for area in get_overlapping_areas():
		if area is Teacup:
			area.fill()
			break
	var tween = create_tween()
	tween.tween_property(self, "global_position", home_position, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)

class_name NotificationCard
extends Panel

@export var lifetime := 4.0          # secs on-screen
var _tween : Tween
var tray_width: float

func _ready() -> void:
    position.x = tray_width
    _tween = create_tween()
    _tween.tween_property(
        self, "position:x",
        0,
        0.25,
    ).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    await get_tree().create_timer(lifetime).timeout
    disappear()

func disappear() -> void:
    if _tween.is_running(): _tween.kill()
    _tween = create_tween()
    _tween.tween_property(self, "position:x", tray_width, 0.25)\
          .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
    _tween.tween_callback(Callable(self, "queue_free"))

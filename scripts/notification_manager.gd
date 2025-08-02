extends Node


func _ready() -> void:
	pass

func push(title:String, body:String="") -> void:
	print("Called push function")
	var tray = get_tree().get_root().get_node("Game/NotificationsLayer/Tray")
	if not tray:
		print("Notification tray not found.")
		push_error("Notification tray not found.")
		return
	var card := preload("res://scenes/notification_card.tscn").instantiate()
	card.get_node("Title").text = title
	card.get_node("Body").text  = body
	card.tray_width = (tray as Control).size.x
	tray.add_child(card)
	print("Pushed notification")

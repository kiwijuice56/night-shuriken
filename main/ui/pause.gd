extends Control
class_name Pause

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# OS.window_fullscreen = true

func _input(event) -> void:
	if event.is_action_pressed("menu", false):
		visible = not visible
		get_tree().paused = not get_tree().paused
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

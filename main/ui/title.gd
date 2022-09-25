extends Control
class_name Title

func _ready() -> void:
	GlobalData.player.connect("restart", self, "_on_restart")
	set_process_input(false)
	yield($AnimationPlayer, "animation_finished")
	$TitleLoop.playing = true
	set_process_input(true)

func _on_restart() -> void:
	$AnimationPlayer.current_animation = "restart"
	yield($AnimationPlayer, "animation_finished")
	get_tree().get_root().get_node("Main").start_game()

func _input(event) -> void:
	if event.is_action_pressed("shoot", false):
		$AnimationPlayer.current_animation = "start"
		$TitleLoop.playing = false
		start_game()
		set_process_input(false)

func start_game() -> void:
	$AudioStreamPlayer.playing = true
	get_tree().get_root().get_node("Main").load_level(0)
	yield($AnimationPlayer, "animation_finished")
	get_tree().get_root().get_node("Main").tutorial()
	$AnimationPlayer.current_animation = "tutorial"
	yield($AnimationPlayer, "animation_finished")
	get_tree().get_root().get_node("Main").start_game()

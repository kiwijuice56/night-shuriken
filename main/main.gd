extends Node
class_name Main

export(Array, PackedScene) var levels: Array

var loaded_level
var last_idx := 0

func _ready() -> void:
	GlobalData.player.connect("restart", self, "_on_restart")

func _on_restart() -> void:
	$Tween.interpolate_property(loaded_level.get_node("Music"), "volume_db", null, -80, 0.4)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	load_level(-1)

func load_level(idx: int) -> void:
	if is_instance_valid(loaded_level):
		loaded_level.queue_free()
	if idx == -1 and last_idx != -1:
		idx = last_idx
	last_idx = idx
	loaded_level = levels[idx].instance()
	add_child(loaded_level)
	GlobalData.projectile = loaded_level.init_stars

func tutorial() -> void:
	GlobalData.player_disabled = false
	GlobalData.tutorial = true

func start_game() -> void:
	GlobalData.tutorial = false
	GlobalData.player.dead = false
	GlobalData.player_disabled = false
	loaded_level.play_level()
	yield(loaded_level, "level_finished")
	$Tween.interpolate_property(loaded_level.get_node("Music"), "volume_db", null, -80, 0.4)
	$Tween.start()
	if last_idx == len(levels) - 1:
		get_node("UILayer/TitleScreen").finish()
		GlobalData.player_disabled = true
		yield($Tween, "tween_completed")
		loaded_level.queue_free()
		return
	get_node("UILayer/TitleScreen").next_level()
	GlobalData.player_disabled = true
	$Timer.start(0.5)
	yield($Timer, "timeout")
	GlobalData.player.reset()
	load_level(last_idx + 1)
	$Timer.start(2.5)
	yield($Timer, "timeout")
	GlobalData.player_disabled = false
	$Timer.start(8)
	yield($Timer, "timeout")
	start_game()

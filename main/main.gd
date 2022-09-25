extends Node
class_name Main

export(Array, PackedScene) var levels: Array

var loaded_level
var last_idx := -1

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

func tutorial() -> void:
	GlobalData.player_disabled = false
	GlobalData.tutorial = true

func start_game() -> void:
	GlobalData.tutorial = false
	GlobalData.projectile = 8
	GlobalData.player.dead = false
	loaded_level.play_level()

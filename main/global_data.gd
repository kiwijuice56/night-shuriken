extends Node

signal projectile_changed
signal player_disabled_changed

onready var player = get_tree().get_root().get_node("Main/Player")
var projectile := 8 setget set_projectile
var player_disabled := true setget set_player_disabled
var tutorial := true
var mouse_sensitivity := 3.0

func set_player_disabled(new) -> void:
	player_disabled = new
	emit_signal("player_disabled_changed", player_disabled)

func set_projectile(new) -> void:
	projectile = new
	emit_signal("projectile_changed", projectile)

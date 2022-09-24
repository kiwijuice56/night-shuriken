extends Node

signal projectile_changed

var projectile := 8 setget set_projectile

func set_projectile(new) -> void:
	projectile = new
	emit_signal("projectile_changed", projectile)

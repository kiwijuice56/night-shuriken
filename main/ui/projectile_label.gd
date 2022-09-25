extends Label
class_name ProjectileLabel

func _ready() -> void:
	GlobalData.connect("projectile_changed", self, "_on_projectile_changed")
	_on_projectile_changed(GlobalData.projectile)
	$Timer.connect("timeout", self, "_on_timeout")

func _on_projectile_changed(new) -> void:
	text = str(new)
	$Tween.interpolate_property(self, "modulate:a", null, 1.0, 0.05)
	$Tween.start()
	$Timer.start(2.0)

func _on_timeout() -> void:
	$Tween.interpolate_property(self, "modulate:a", null, 0.0, 0.15)
	$Tween.start()

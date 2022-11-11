extends ColorRect
class_name ChromaticCover

var highest: int = 0

func _ready() -> void:
	GlobalData.connect("projectile_changed", self, "_on_projectile_changed")

func _on_projectile_changed(new_count: int) -> void:
	if new_count > highest:
		highest = new_count
		material.set_shader_param("r_displacement", Vector2(0, 0))
		material.set_shader_param("b_displacement", Vector2(0, 0))
	else:
		var x = (1.0 - new_count / float(highest)) * 4
		material.set_shader_param("r_displacement", Vector2(x, 0))
		material.set_shader_param("b_displacement", Vector2(-x, 0))

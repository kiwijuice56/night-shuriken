extends HSlider

func _ready() -> void:
	connect("value_changed", self, "_on_value_changed")

func _on_value_changed(new) -> void:
	GlobalData.mouse_sensitivity = new

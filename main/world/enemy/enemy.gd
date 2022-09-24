extends Spatial
class_name Enemy

func _ready() -> void:
	connect("area_entered", self, "bullet_entered")

func bullet_entered(area: Area) -> void:
	call_deferred("queue_free")

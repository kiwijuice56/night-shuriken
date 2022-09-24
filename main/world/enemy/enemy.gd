extends Spatial
class_name Enemy

func _ready() -> void:
	connect("area_entered", self, "bullet_entered")

func bullet_entered(area: Area) -> void:
	GlobalData.projectile += 1
	$AnimationPlayer.current_animation = "death"
	yield($AnimationPlayer, "animation_finished")
	call_deferred("queue_free")

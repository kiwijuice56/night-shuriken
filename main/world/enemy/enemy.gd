extends Spatial
class_name Enemy

export(Array, Resource) var model_stages: Array
export var offset_y := 0.2

var stage := 0
var kill_mode := false
var dead := false

func _ready() -> void:
	connect("area_entered", self, "bullet_entered")
	

func bullet_entered(area: Area) -> void:
	if kill_mode or dead:
		return
	dead = true
	GlobalData.player.add_trauma(0.08)
	GlobalData.player.flash(0.2)
	$Death.play_sound()
	$AnimationPlayer.current_animation = "death"
	yield($AnimationPlayer, "animation_finished")
	call_deferred("queue_free")

func _on_main_pulse() -> void:
	stage += 1
	if stage == 3:
		kill()
		return
	$MeshInstance.mesh = model_stages[stage]

func kill() -> void:
	kill_mode = true
	var target = GlobalData.player.global_transform.origin
	target.y -= 0.5
	$Tween.interpolate_property(self, "global_transform:origin", null, target, 0.4)
	$Tween.start()

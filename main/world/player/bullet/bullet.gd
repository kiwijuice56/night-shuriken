extends KinematicBody
class_name Bullet

export var speed := 0.2
var velocity := Vector3()

func _ready() -> void:
	$Shoot.play_sound()
	$Hitbox.connect("body_entered", self, "_on_hit_map")

func _physics_process(delta) -> void:
	if not move_and_collide(velocity * speed) == null:
		speed = 0
		$Hit.play_sound()
		$Hitbox.queue_free()
		$AnimationPlayer.current_animation = "[stop]"
		set_physics_process(false)

func _on_hit_map(body: Node) -> void:
	pass

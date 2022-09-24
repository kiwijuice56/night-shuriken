extends Camera
class_name Player
# Modified from https://github.com/Whimfoome/godot-FirstPersonStarter/blob/main/Player/Head.gd

export var mouse_sensitivity := 2.0
export var y_limit := 90.0
export var bullet_scene: PackedScene
var mouse_axis := Vector2()
var rot := Vector3()

func _ready() -> void:
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg2rad(y_limit)

func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		camera_rotation()
	if event.is_action_pressed("shoot", false):
		shoot()

func camera_rotation() -> void:
	# Horizontal mouse look
	rot.y -= mouse_axis.x * mouse_sensitivity
	# Vertical mouse look
	rot.x = clamp(rot.x - mouse_axis.y * mouse_sensitivity, -y_limit, y_limit)
	
	rotation.y = rot.y
	rotation.x = rot.x

func shoot() -> void:
	$AnimationPlayer.current_animation = "shoot"
	var new_bullet: Bullet = bullet_scene.instance()
	get_tree().get_root().get_child(0).add_child(new_bullet)
	new_bullet.velocity = -global_transform.basis.z
	new_bullet.rotation_degrees = rotation_degrees
	new_bullet.rotate_x(randf() * 8 - 4)
	new_bullet.rotate_y(randf() * 8 - 4)
	new_bullet.rotate_z(randf() * 8 - 4)
	new_bullet.global_transform.origin = global_transform.origin

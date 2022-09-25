extends Camera
class_name Player
# Modified from https://github.com/Whimfoome/godot-FirstPersonStarter/blob/main/Player/Head.gd

export var initial_offset := Vector2(0, 0)
export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
onready var noise = OpenSimplexNoise.new()
var noise_y = 0

var update_position := Vector2()
var dir_x := 0.0
var new_dir_x := 0.0

export var mouse_sensitivity := 2.0
export var y_limit := 90.0
export var bullet_scene: PackedScene
var mouse_axis := Vector2()
var rot := Vector3(0, PI, 0)

var bullets := []
var dead := false

signal restart

func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg2rad(y_limit)
	
	GlobalData.connect("player_disabled_changed", self, "_on_disabled_changed")
	_on_disabled_changed(true)
	
	$Hitbox.connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area: Area) -> void:
	if dead:
		return
	dead = true
	$AudioStreamPlayer.playing = true
	for bullet in bullets:
		if is_instance_valid(bullet):
			bullet.queue_free()
	call_deferred("emit_signal", "restart")

func _on_disabled_changed(disabled: bool) -> void:
	set_process(not disabled)
	set_process_input(not disabled)

func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		camera_rotation()
	if event.is_action_pressed("shoot", false):
		shoot()

func _process(delta) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func add_trauma(amount) -> void:
	trauma = min(trauma + amount, 1.0)

func shake() -> void:
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation_degrees.z = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	h_offset = initial_offset.x + max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	v_offset = initial_offset.y + max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

func flash(time: float) -> void:
	var timer := Timer.new()
	add_child(timer)
	timer.start(time)
	$Flash.visible = true
	yield(timer, "timeout")
	$Flash.visible = false
	timer.queue_free()

func camera_rotation() -> void:
	# Horizontal mouse look
	rot.y -= mouse_axis.x * mouse_sensitivity
	# Vertical mouse look
	rot.x = clamp(rot.x - mouse_axis.y * mouse_sensitivity, -y_limit, y_limit)
	
	rotation.y = rot.y
	rotation.x = rot.x

func shoot() -> void:
	if GlobalData.projectile == 0:
		return
	if not GlobalData.tutorial:
		GlobalData.projectile -= 1
	$AnimationPlayer.current_animation = "shoot"
	var new_bullet: Bullet = bullet_scene.instance()
	bullets.append(new_bullet)
	get_tree().get_root().get_child(0).add_child(new_bullet)
	new_bullet.velocity = -global_transform.basis.z
	new_bullet.rotation_degrees = rotation_degrees
	new_bullet.rotate_x(randf() * 8 - 4)
	new_bullet.rotate_y(randf() * 8 - 4)
	new_bullet.rotate_z(randf() * 8 - 4)
	new_bullet.global_transform.origin = global_transform.origin

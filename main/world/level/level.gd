extends Spatial
class_name Level

export var init_stars := 45
export var pulse_time := 3.0
export(Array, PackedScene) var enemies: Array
var speed_scale := 1.0 setget set_speed_scale
var next_speed := 1.0

func set_speed_scale(new_scale) -> void:
	speed_scale = new_scale
	for light in $Lights.get_children():
		if light.has_node("AnimationPlayer"):
			light.get_node("AnimationPlayer").playback_speed = speed_scale
	$MainPulse.wait_time = pulse_time / speed_scale
	$Music.pitch_scale = speed_scale

onready var pulse_timer := $MainPulse

signal main_pulse_timeout
signal level_finished

func _ready() -> void:
	self.speed_scale = speed_scale
	$MainPulse.connect("timeout", self, "_on_main_pulse")
	$MainPulse.wait_time = pulse_time

func _on_main_pulse() -> void:
	if next_speed != 1.0:
		self.speed_scale = next_speed
	next_speed = 1.0
	emit_signal("main_pulse_timeout")
	$MainPulse.start()

func spawn_enemy(pos: int) -> void:
	var new_enemy: Enemy = enemies[randi() % len(enemies)].instance()
	connect("main_pulse_timeout", new_enemy, "_on_main_pulse")
	$SpawnedEnemies.add_child(new_enemy)
	new_enemy.global_transform.origin = $EnemySpawns.get_child(pos).global_transform.origin
	new_enemy.global_transform.origin.y += new_enemy.offset_y
	new_enemy.look_at(GlobalData.player.global_transform.origin, Vector3.UP)
	new_enemy.rotation_degrees.y -= 180
	new_enemy.rotation_degrees.x = 0
	new_enemy.rotation_degrees.z = 0

func play_level() -> void:
	for light in $Lights.get_children():
		light.get_child(0).current_animation = "flicker"
		$Music.playing = true
	for enemy in $SpawnedEnemies.get_children():
		enemy.queue_free()
	$MainPulse.start()

func queue_speed(new_speed) -> void:
	self.next_speed = new_speed

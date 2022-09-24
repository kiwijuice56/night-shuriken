extends Spatial
class_name Level

export var pulse_time := 3.0
export(Array, PackedScene) var enemies: Array
var speed_scale := 1.0 setget set_speed_scale
var next_speed := 1.0

func set_speed_scale(new_scale) -> void:
	speed_scale = new_scale
	for light in $Lights.get_children():
		light.get_node("AnimationPlayer").playback_speed = speed_scale
	$MainPulse.wait_time = pulse_time / speed_scale
	$Music.pitch_scale = speed_scale

onready var pulse_timer := $MainPulse

signal main_pulse_timeout

func _ready() -> void:
	self.speed_scale = speed_scale
	$MainPulse.connect("timeout", self, "_on_main_pulse")
	$MainPulse.wait_time = pulse_time
	$MainPulse.start()
	play_level()

func _on_main_pulse() -> void:
	if next_speed != 1.0:
		self.speed_scale = next_speed
	next_speed = 1.0
	emit_signal("main_pulse_timeout")
	$MainPulse.start()
	print(speed_scale, $MainPulse.wait_time)
	

func spawn_enemy(pos: int) -> void:
	var new_enemy: Enemy = enemies[randi() % len(enemies)].instance()
	$SpawnedEnemies.add_child(new_enemy)
	new_enemy.global_transform.origin = $EnemySpawns.get_child(pos).global_transform.origin

func play_level() -> void:
	pass

func queue_speed(new_speed) -> void:
	self.next_speed = new_speed

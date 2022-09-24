extends Spatial
class_name Level

export var pulse_time := 2.0
var speed_scale := 0.7 setget set_speed_scale

func set_speed_scale(new_scale) -> void:
	speed_scale = new_scale
	for light in $Lights.get_children():
		pass
		#light.get_node("AnimationPlayer").playback_speed = speed_scale
	$MainPulse.wait_time = pulse_time * speed_scale

onready var pulse_timer := $MainPulse

signal main_pulse_timeout

func _ready() -> void:
	self.speed_scale = speed_scale
	$MainPulse.connect("timeout", self, "_on_main_pulse")

func _on_main_pulse() -> void:
	emit_signal("main_pulse_timeout")

func spawn_enemy(track: int) -> void:
	pass

func play_level() -> void:
	pass

extends Node2D

@onready
var whale := $Sprite2D as Sprite2D

@onready
var whale_initial_pos := whale.position.y

@onready
var water_particles := $Sprite2D/CPUParticles2D

@onready
var water_sound := $AudioStreamPlayer2D

func _process(delta):
	var trigger_ammount = Input.get_action_strength("controller_trigger_right")
	var max_strength := 800
	var min_strength := 700
	
	const whale_move_dist = 75
	
	whale.position.y = whale_initial_pos - (whale_move_dist * trigger_ammount)
	
	if not water_particles.emitting and trigger_ammount > 0.0:
		water_sound.play()
	elif water_particles.emitting and trigger_ammount <= 0.0:
		water_sound.stop()
	
	water_particles.emitting = trigger_ammount > 0.0
	water_particles.initial_velocity_max = max_strength * trigger_ammount
	water_particles.initial_velocity_min = min_strength * trigger_ammount

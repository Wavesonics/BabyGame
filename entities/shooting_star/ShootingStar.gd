extends Node2D

@onready
var star_particles := $CPUParticles2D

@onready
var light_animator := $AnimationPlayer

@onready
var woosh_sound := $AudioStreamPlayer2D

func _input(event):
	if event.is_action_released("controller_left_bumper"):
		star_particles.emitting = true
		light_animator.play("light")
		woosh_sound.play()

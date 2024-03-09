extends CharacterBody2D

@onready
var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready
var chirp: AudioStreamPlayer2D = $AudioStreamPlayer2D

const speed := 1000
const dead_zone := 0.1
var is_vibrating := false

func _process(delta):
	var x = Input.get_joy_axis(0, JoyAxis.JOY_AXIS_RIGHT_X)
	var y = Input.get_joy_axis(0, JoyAxis.JOY_AXIS_RIGHT_Y)
	var joyVec = Vector2(x, y)
	
	if joyVec.length() > dead_zone:
		if not chirp.playing:
			chirp.play()
		# Flip the sprite in movement direction
		if x >= 0:
			sprite.scale.x = 1
		else:
			sprite.scale.x = -1
		
		start_vibrate()
		velocity = joyVec * speed
	else:
		velocity = Vector2.ZERO
		chirp.stop()
		stop_vibrate()
	
	move_and_slide()

func start_vibrate():
	if not is_vibrating:
		Input.start_joy_vibration(0, 0.5, 0, 0)
		is_vibrating = true
	
func stop_vibrate():
	if is_vibrating:
		Input.stop_joy_vibration(0)
		is_vibrating = false

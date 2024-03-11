extends Node2D

@onready
var sound_effect := $SoundEffect as AudioStreamPlayer2D

@onready
var ground_hog := $Groundhog as Sprite2D

@onready
var initial_position := ground_hog.position

var _last_trigger_ammount := 0
func _process(delta):
	var trigger_ammount = Input.get_action_strength("controller_trigger_left")
	var move_height := 75
	
	ground_hog.position = initial_position - Vector2(0, (move_height * trigger_ammount))
	
	if _last_trigger_ammount < 1.0 and trigger_ammount >= 1.0 and not sound_effect.playing:
		sound_effect.play()
	
	_last_trigger_ammount = trigger_ammount

extends Sprite2D
class_name PopupEntity

@export
var action: String

@export
var audioEffect: AudioStream
	#set(value):
		#$SoundEffect.stream = value

@onready
var audio: AudioStreamPlayer2D = $SoundEffect

func _ready():
	hide()
	audio.stream = audioEffect
	visibility_changed.connect(_on_visibility_changes)

func _on_visibility_changes():
	if visible:
		audio.play()

func _input(event):
	if event.is_action_released(action):
		visible = !visible

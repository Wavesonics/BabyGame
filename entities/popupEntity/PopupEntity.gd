extends Sprite2D
class_name PopupEntity

@export
var action: String

@export
var audioEffect: AudioStream

@onready
var audio: AudioStreamPlayer2D = $SoundEffect
@onready
var animPlayer: AnimationPlayer = $AnimationPlayer

func _ready():
	hide()
	audio.stream = audioEffect
	visibility_changed.connect(_on_visibility_changes)

func _on_visibility_changes():
	if visible:
		audio.play()

func _input(event):
	if event.is_action_released(action):
		if visible:
			animPlayer.play("popdown")
		else:
			animPlayer.play("popup")

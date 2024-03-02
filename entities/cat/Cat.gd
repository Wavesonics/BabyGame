extends Sprite2D

@onready
var audio: AudioStreamPlayer2D = $Meow

func _ready():
	hide()
	visibility_changed.connect(_on_visibility_changes)

func _on_visibility_changes():
	if visible:
		audio.play()

func _input(event):
	if event.is_action_released("controller_y"):
		visible = !visible

extends Sprite2D

func _ready():
	visibility_changed.connect(_on_visibility_changes)

func _on_visibility_changes():
	if visible:
		$Ambience.play()
	else:
		$Ambience.stop()

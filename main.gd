extends Node2D

@export_group("Controller Directions")
@export
var arrowRight: Sprite2D

func _ready():
	arrowRight.hide()

func _input(event):
	if event.is_action_released("controller_right"):
		arrowRight.visible = !arrowRight.visible

func _process(delta):
	pass

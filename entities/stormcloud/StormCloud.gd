extends Node2D


func _ready():
	$PopupEntity.visibility_changed.connect(_on_visibility_changes)


func _on_visibility_changes():
	if $PopupEntity.visible:
		$AnimationPlayer.play("lightning")

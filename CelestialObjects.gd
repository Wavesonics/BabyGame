extends Node2D

@export var sun: Sprite2D
@export var moon: Sprite2D
@export var sky: Sprite2D
@export var canvas: CanvasModulate
@export var fireFlies: CPUParticles2D

@onready var sunLight: PointLight2D = sun.find_child("PointLight2D")
@onready var moonLight: PointLight2D = moon.find_child("PointLight2D")
@onready var startDarkColor: Color = canvas.color

# The radius of the circle along which the sprite will move.
var radius: float = 250.0

# The speed at which the sprite moves around the circle.
var speed: float = 2.0

# Current angle of the sprite around the circle in radians.
var curAngle: float = PI

var original_position: Vector2
var sky_mat: ShaderMaterial

func _ready():
	original_position = position
	sky_mat = (sky.material as ShaderMaterial)

func _process(delta: float) -> void:
	# Get joystick axis values (Assuming default joystick mappings).
	# Axis 0 is usually the horizontal axis on the left stick.
	var axis_value = Input.get_joy_axis(0, 0)
	
	# Dead zone for stick drift
	if abs(axis_value) > 0.1:
		# Update the angle based on the joystick's horizontal input.
		curAngle += speed * axis_value * delta
	# If no stick input, animate on our own
	else:
		curAngle += 0.0005
	
	curAngle = wrapf(curAngle, 0, 2*PI)
	
	# Calculate the new position using polar to cartesian conversion.
	var sunX = radius * cos(curAngle)*1.5
	var sunY = radius * sin(curAngle)
	
	# Calculate the new position using polar to cartesian conversion.
	var moonX = radius * cos(curAngle)*1.5 * -1
	var moonY = radius * sin(curAngle) * -1
	
	# Update the sprite's position.
	sun.global_position = Vector2(500, 400) + Vector2(sunX, sunY)
	moon.global_position = Vector2(500, 400) + Vector2(moonX, moonY)
	
	# Now update the day color
	# 0.75 is dawn
	# 1.0/0.0 is noon
	# 0.25 is dusk
	# 0.5 is midnight
	var percentDay = map_angle_to_unit_range(curAngle)
	sky_mat.set_shader_parameter("time_of_day", percentDay)

	var t = sin(curAngle) * -1
	sunLight.energy = clamp(t, 0, 1)
	moonLight.energy = clamp(t * -1, 0, 1)
	canvas.color = Color.WHITE.lerp(startDarkColor, moonLight.energy)
	
	# Day time
	if percentDay < 0.25 or percentDay > 0.75:
		if $NightAmbience.is_playing():
			$DayAmbience.play()
			$NightAmbience.stop()
			fireFlies.emitting = false
	# Night time
	else:
		if $DayAmbience.is_playing():
			$DayAmbience.stop()
			$NightAmbience.play()
		if not fireFlies.emitting and percentDay > 0.3 and percentDay <= 0.7:
			fireFlies.emitting = true
		elif fireFlies.emitting and percentDay > 0.7:
			fireFlies.emitting = false

func map_angle_to_unit_range(angle):
	# Offset the angle by 90 degrees (PI/2 radians)
	var offset_angle = angle + PI / 2

	# Ensure the angle is within the -PI to PI range after offset
	if offset_angle > PI:
		offset_angle -= TAU  # Adjust if the offset angle exceeds PI

	# Normalize the offset angle to be within the range of 0 to 2PI
	var normalized_angle = fmod(offset_angle + TAU, TAU)
	if normalized_angle < 0:
		normalized_angle += TAU

	# Map the normalized angle to a 0.0 to 1.0 range
	var mapped_value = normalized_angle / TAU
	return mapped_value

extends Node2D

@export var sun: Sprite2D
@export var moon: Sprite2D
@export var dayColor: ColorRect
@export var nightColor: ColorRect
@export var skyDay: Sprite2D
@export var skyNight: Sprite2D


# The radius of the circle along which the sprite will move.
var radius: float = 250.0

# The speed at which the sprite moves around the circle.
var speed: float = 2.0

# Current angle of the sprite around the circle in radians.
var angle: float = PI

var original_position: Vector2
var sky_mat: ShaderMaterial

func _ready():
	original_position = position
	sky_mat = (skyDay.material as ShaderMaterial)

func _process(delta: float) -> void:
	# Get joystick axis values (Assuming default joystick mappings).
	# Axis 0 is usually the horizontal axis on the left stick.
	var axis_value = Input.get_joy_axis(0, 0)
	
	# Dead zone for stick drift
	if abs(axis_value) > 0.1:
		# Update the angle based on the joystick's horizontal input.
		angle += speed * axis_value * delta
	# If no stick input, animate on our own
	else:
		angle += 0.0005
	
	angle = wrapf(angle, -PI, PI)
	
	# Calculate the new position using polar to cartesian conversion.
	var sunX = radius * cos(angle)*1.5
	var sunY = radius * sin(angle)
	
		# Calculate the new position using polar to cartesian conversion.
	var moonX = radius * cos(angle)*1.5 * -1
	var moonY = radius * sin(angle) * -1
	
	# Update the sprite's position.
	sun.global_position = Vector2(500, 400) + Vector2(sunX, sunY)
	moon.global_position = Vector2(500, 400) + Vector2(moonX, moonY)
	
	# Now update the day color
	# 1.0/0.0 is noon
	# 0.5 is midnight
	var percentDay = map_angle_to_unit_range(angle)
	sky_mat.set_shader_parameter("time_of_day", percentDay)
	
	## Day time
	#if percentDay < 0.25 or percentDay > 0.75:
		#dayColor.color.a = 0.01
		#skyDay.show()
	#else:
		#dayColor.color.a = 0.0
		#skyDay.hide()
	
	## Night time
	#if percentDay > 0.25 and percentDay < 0.75:
		#nightColor.color.a = 0.5
		#skyNight.show()
	#else:
		#nightColor.color.a = 0.0
		#skyNight.hide()

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

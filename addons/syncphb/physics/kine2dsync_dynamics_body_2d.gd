class_name DynamicsBody2D, "./kine2dsync_dynamics_body_2d.png"
extends SyncKinematicBody2D

## Body that allows you to get fast access to gravity and movement
##
## NOTE: Motion is supposed to be used for this body instead of directly make reference of velocity

signal collided_wall
signal collided_ceiling
signal collided_floor

export var motion: Vector2
export var gravity_direction: Vector2 = Vector2.DOWN setget _set_gravity_direction, _get_gravity_direction
export var gravity_acceleration: float
export var gravity_max_falling_speed: float
export var slide_enabled: bool

var motion_lock: bool # If true, only velocity will be in application

var _motion: Vector2 # Motion before calling move_with_motion()


func move_with_motion(delta: float) -> KinematicCollision2D:
	# Up direction
	var up: Vector2 = up_direction
	up_direction = up_direction.rotated(global_rotation)
	
	# Previous motion
	_motion = motion
	
	# Gravity
	motion += gravity_direction * gravity_acceleration * delta
	if gravity_max_falling_speed > 0 && motion.y > gravity_max_falling_speed:
		motion.y = gravity_max_falling_speed
	
	# Low-speed slope-down fixer (only works for motion_global == false)
	if is_on_floor() && !slide_enabled:
		motion.y = clamp(motion.y, 0, abs(motion.x) * 0.9)
	
	# Motion
	if motion_lock:
		motion_lock = false
	else:
		velocity = motion.rotated(global_rotation)
	var result: KinematicCollision2D = move_and_slither(delta)
	motion = velocity.rotated(-global_rotation)
	
	# Restore
	up_direction = up
	
	# Non-slide
	if !slide_enabled:
		motion.x = _motion.x
	
	# Signal
	if is_on_wall():
		emit_signal("collided_wall")
	if is_on_ceiling():
		emit_signal("collided_ceiling")
	if is_on_floor():
		emit_signal("collided_floor")
	
	# Returns
	return result


#= Acceleration
func accelerate(to: Vector2, accel: float) -> void:
	motion = motion.move_toward(to, accel * get_physics_process_delta_time())


func accelerate_x(to: float, accel: float) -> void:
	motion.x = move_toward(motion.x, to, accel * get_physics_process_delta_time())


func accelerate_y(to: float, accel: float) -> void:
	motion.y = move_toward(motion.y, to, accel * get_physics_process_delta_time())


#= Turning back
func turn_x() -> void:
	if motion.x != 0:
		motion.x = -motion.x
	else:
		motion.x = -_motion.x
	_motion.x = motion.x


func turn_y() -> void:
	if motion.y != 0:
		motion.y = -motion.y
	else:
		motion.y = -_motion.y
	_motion.y = motion.y


#= Jump
func jump(jumping_speed: float) -> void:
	motion.y = -abs(jumping_speed)


#= Setters & getters
func _set_gravity_direction(to: Vector2) -> void:
	gravity_direction = to.normalized()


func _get_gravity_direction() -> Vector2:
	return gravity_direction.normalized()

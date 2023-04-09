class_name AnimatableKinematic2D, "res://addons/animphb/physics/kine2d_animatable_kine2d.png"
extends KinematicBody2D

## KinematicBody2D that is able to interact with AnimatableBody2D
##
## NOTE: To make the reaction perfectly work, you need to call move_and_slither()
## instead of move_and_slide() or move_and_slide_with_snap()

export var collision_enabled: bool = true
export var up_direction: Vector2 = Vector2.UP setget set_up_direction, get_up_direction
export var stop_on_slope: bool = true
export var constant_speed: bool = true
export(float, 0, 96, 0.01) var slope_snap_length: float = 4
export var floor_max_angle: float = 45
export var elastic_slide: bool

var engine: = Engine

var velocity: Vector2

var _velocity: Vector2 setget set_previous_velocity, get_previous_velocity
var _snap: bool
var _disnap: bool


# Used for AnimatableKinematic2D ONLY to get interaction with AnimatableBody2D
func move_and_slither(delta: float) -> KinematicCollision2D:
	# If collision mode is disabled, uses regular calculation to increase performance
	if !collision_enabled:
		global_position += velocity * delta
		return null
	
	# Define a variable
	var max_slope: float = deg2rad(floor_max_angle)
	
	# Snap
	if _disnap:
		_snap = false
	else:
		var dot: float = velocity.dot(up_direction)
		var prj_square: float = (velocity.project(up_direction) * delta).length_squared()
		var snp_square: float = pow(slope_snap_length, 2)
		_snap = !elastic_slide && is_on_floor() && (dot <= 0 || dot > 0 && prj_square < snp_square)
		_disnap = false
	
	# Move and slide with snap
	velocity = move_and_slide_with_snap(velocity, -up_direction * (slope_snap_length if _snap else 0.0), up_direction, stop_on_slope, 4, max_slope)
	if constant_speed && is_on_floor() && stepify(velocity.dot(up_direction), 0.001) != 0:
		velocity = get_floor_velocity()
	
	# Slide on AnimatableBody2D
	var on_animatable: bool
	var physics_fps: float = engine.iterations_per_second
	var target_vel: Vector2
	for i in get_slide_count():
		var slide: KinematicCollision2D = get_slide_collision(i)
		if slide && slide.collider is AnimatableBody2D && slide.get_angle(up_direction) < max_slope:
			on_animatable = true
			var animbody: AnimatableBody2D = slide.collider as AnimatableBody2D
			target_vel += animbody.constant_linear_velocity - slide.normal.tangent() * deg2rad(animbody.constant_angular_velocity) * slide.position.distance_to(animbody.global_position) * physics_fps
	if on_animatable:
		velocity = velocity.move_toward(target_vel, target_vel.length())
	
	# Previous velocity
	_velocity = velocity
	
	return get_last_slide_collision()


# Forced disnap
func disnap() -> void:
	_disnap = true


# Setters & getters
func set_up_direction(to: Vector2) -> void:
	up_direction = to.normalized()


func get_up_direction() -> Vector2:
	return up_direction.normalized()


func set_previous_velocity(to: Vector2) -> void:
	_velocity = to


func get_previous_velocity() -> Vector2:
	return _velocity

class_name AnimatableBody2D, "res://addons/animphb/physics/kine2d_animatable_body_2d.png"
extends KinematicBody2D

## Class that allows you to make platform or moving blocks easily
##
## NOTE: This takes effect ONLY for AnimatableKinematic2D and AnimatableRigid2D

const SYNC_TO_PHYSICS: String = "motion/sync_to_physics"

export var constant_linear_velocity: Vector2
export var constant_angular_velocity: float
export var constant_rotation_velocity: float


func _physics_process(delta: float) -> void:
	# Fix the position to make collision work well
	if get(SYNC_TO_PHYSICS):
		global_transform = global_transform
	
	# Self rotation, which will AFFECT the calculation of constant_angular_velocity
	if constant_rotation_velocity != 0:
		rotate(deg2rad(constant_rotation_velocity))

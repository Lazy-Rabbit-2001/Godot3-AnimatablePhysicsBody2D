class_name AnimatableRigid2D, "res://addons/animphb/physics/rigid2d_animatable_rigid_2d.png"
extends RigidBody2D

## RigidBody2D that is able to interact with AnimatableBody2D
##
## NOTE: This will automatically turn on contact_monitor and give contacts_reported,
## so if you don't hope to do it, please resort to RigidBody2D instead!

var engine: = Engine

var _linear_velocity: Vector2


func _init() -> void:
	if !contact_monitor:
		contact_monitor = true
	if contact_monitor && contacts_reported == 0:
		contacts_reported = 4


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	# Contact detection
	if contact_monitor && linear_velocity.normalized().dot(state.total_gravity) >= 0:
		var physics_fps: float = engine.iterations_per_second
		var bodies: Array = get_colliding_bodies()
		for i in bodies.size():
			var j: Node2D = bodies[i]
			if state.get_contact_count() > 0 && j is AnimatableBody2D:
				# Angular velocity
				state.angular_velocity = move_toward(state.angular_velocity, j.constant_angular_velocity, j.constant_angular_velocity)
				# Linear velocity
				# NOTE: This would bring a problem that when the platform turns the direction in a sudden,
				# the body would be driven to fall in percentage of chances
				var target_lvel: Vector2 = j.constant_linear_velocity - j.constant_angular_velocity * state.get_contact_collider_position(i).direction_to(global_position).tangent() * physics_fps
				state.linear_velocity += target_lvel - _linear_velocity + j.global_travel
				if j.physics_material_override:
					physics_material_override = j.physics_material_override
	# Previous linear velocity
	_linear_velocity = state.linear_velocity

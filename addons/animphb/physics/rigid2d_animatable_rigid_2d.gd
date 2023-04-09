class_name AnimatableRigid2D, "res://addons/animphb/physics/rigid2d_animatable_rigid_2d.png"
extends RigidBody2D

## RigidBody2D that is able to interact with AnimatableBody2D
##
## NOTE: This will automatically turn on contact_monitor and give contacts_reported,
## so if you don't hope to do it, please resort to RigidBody2D instead!

var engine: = Engine


func _init() -> void:
	if !contact_monitor:
		contact_monitor = true
	if contact_monitor && contacts_reported == 0:
		contacts_reported = 4


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	print(linear_velocity.dot(state.total_gravity))
	if contact_monitor && linear_velocity.normalized().dot(state.total_gravity) >= 0:
		var physics_fps: float = engine.iterations_per_second
		var bodies: Array = get_colliding_bodies()
		for i in bodies.size():
			var j: Node2D = bodies[i]
			if state.get_contact_count() > 0 && j is AnimatableBody2D:
				state.angular_velocity = j.constant_angular_velocity
				state.linear_velocity = j.constant_linear_velocity - j.constant_angular_velocity * state.get_contact_collider_position(i).direction_to(global_position).tangent() * physics_fps

class_name AnimatableRigid2D, "res://addons/animphb/physics/rigid2d_animatable_rigid_2d.png"
extends RigidBody2D


func _init() -> void:
	if !contact_monitor:
		contact_monitor = true
	if contact_monitor && contacts_reported == 0:
		contacts_reported = 4


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if contact_monitor && linear_velocity.dot(state.total_gravity) >= 0:
		var bodies: Array = get_colliding_bodies()
		for i in bodies.size():
			var j: Node2D = bodies[i]
			if state.get_contact_count() > 0 && j is AnimatableBody2D:
				state.angular_velocity = j.constant_angular_velocity
				state.linear_velocity = j.constant_linear_velocity - j.constant_angular_velocity * state.get_contact_collider_position(i).direction_to(global_position).tangent() * Engine.iterations_per_second

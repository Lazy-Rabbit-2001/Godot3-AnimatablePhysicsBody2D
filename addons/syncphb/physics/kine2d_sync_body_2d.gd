class_name SyncBody2D, "res://addons/animphb/physics/kine2d_sync_body_2d.png"
extends KinematicBody2D

## Class that allows you to make platform or moving blocks easily
##
## NOTE: This takes effect ONLY for AnimatableKinematic2D and AnimatableRigid2D

const SETTING: String = "motion/sync_to_physics"

enum LeavingBehavior {
	ALWAYS,
	UPWARD_ONLY,
	NONE
}

export var constant_linear_velocity: Vector2
export var constant_angular_velocity: float
export var leaving_behavior: int = LeavingBehavior.ALWAYS

var _travel: Vector2
var _last_travel: Vector2


func _physics_process(delta: float) -> void:
	global_position = global_position
	
	if get(SETTING):
		set(SETTING, false)
		
		if constant_linear_velocity != Vector2.ZERO || constant_angular_velocity != 0:
			var collis: Array
			var scl: Vector2 = scale
			
			var t: float = Time.get_ticks_usec()
			var coll: KinematicCollision2D = move_and_collide(Vector2.UP.rotated(global_rotation), true, true, true)
			if coll:
				var collider: PhysicsBody2D = coll.collider as PhysicsBody2D
				if !collider in collis:
					collis.append(collider)
			print(Time.get_ticks_usec() - t)
			
			print(collis)
			for j in collis:
				if j is SyncKinematicBody2D && j.is_on_floor() && !j.is_on_wall() && !j.is_on_ceiling():
					var vel: Vector2 = constant_linear_velocity + global_position.direction_to(j.position).tangent() * deg2rad(constant_angular_velocity)
					var floor_velocity: Vector2 = j.get_floor_velocity()
					if leaving_behavior == LeavingBehavior.ALWAYS || (leaving_behavior == LeavingBehavior.UPWARD_ONLY && floor_velocity.dot(j.up_direction) > 0):
						j.velocity += vel - j._velocity
						if "motion_lock" in j:
							j.motion_lock = true
#						if j is DynamicsBody2D:
#							j.motion = j.velocity.rotated(-global_rotation)
		
		set(SETTING, true)

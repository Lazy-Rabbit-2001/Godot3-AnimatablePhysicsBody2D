# SyncPhysicsBody2D for Godot 3
 A plugin for **Godot 3** users who has eagerness for a better plugin with well-done physics bodies for 2D-game design.
 
 ## What is this used for?
 A good question. Initially, this plugin is developed to solve the problem that we are lacking something in this situation -- that you want to make a convey belt which can move, but if you resort to purely `StaticBody2D`, you will find the bodies standing on it lagging with position delta for 1 frame; if you choose purely `KinematicBody2D`, you are going to abandon `constant_linear_velocity` as well as `constant_angular_velocity`. 
 
 One of the purpose of the plugin is set for those who hope to have a view on the combination of both, from which comes `SyncBody2D`, a `KinematicBody2D` with `constant_linear_velocity` and `constant_angular_velocity`, to solve that problem.
 
 Also, let's go for `SyncKinematic2D`, a `Kinematic2D` that you are supposed to use if you are going to work with `SyncBody2D`. With params in `move_and_slide_with_snap()` becoming properties of it, your coding experience will become much more comfortable, efficient and sufficient.
 
 Last but not least, some of you might have strong thirsty for advanced kinematic body for platform movement, especially when you are making some game with multi-direction gravity, to which I extremely recommend `DynamicsBody2D`, a `SyncBody2D` with `gravity_direction`, `gravity_acceleration` and `gravity_max_falling_speed` to control its gravity. Sometimes, you may have promoting desire of "velocity in local transform", so why not try `motion`, a variable that controls its `velocity` without quite many `.rotated(global_rotation)`s?

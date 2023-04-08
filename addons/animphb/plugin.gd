tool
extends EditorPlugin


func _init() -> void:
	print("[AnimatablePhysicsBody2D] Enabled!")


func _exit_tree() -> void:
	print("[AnimatablePhysicsBody2D] If you want to disable the plugin, please remove \"res://addons/animphb\"!")

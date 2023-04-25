tool
extends EditorPlugin


func _enter_tree() -> void:
	if !Engine.editor_hint:
		return
	print("[AnimatablePhysicsBody2D] Enabled!")


func _exit_tree() -> void:
	if !Engine.editor_hint:
		return
	print("[AnimatablePhysicsBody2D] If you want to disable the plugin, please remove \"res://addons/animphb\"!")

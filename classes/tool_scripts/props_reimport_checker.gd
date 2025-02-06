@tool
extends Node

func _ready() -> void:
	if not Engine.is_editor_hint():
		return
	var filesystem : EditorFileSystem = EditorInterface.get_resource_filesystem()
	filesystem.resources_reimporting.connect(on_reimport)

func on_reimport(resources: PackedStringArray) -> void:
	var filesystem : EditorFileSystem = EditorInterface.get_resource_filesystem()
	var path : String = resources[0]
	if path.ends_with(".png"):
		filesystem.scan_sources()

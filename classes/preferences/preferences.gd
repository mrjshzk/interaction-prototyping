class_name ConfigPreferences
extends Resource

const dev_save_path := "res://classes/preferences/preferences.tres"
const save_path := "user://preferences.tres"

@export var fullscreen := false

var fullscreen_mapping := {
	false: DisplayServer.WINDOW_MODE_WINDOWED,
	true: DisplayServer.WINDOW_MODE_FULLSCREEN
}

@export var resolution := Vector2i(1920, 1080)

@export_enum("Low", "High", "Highest") var graphics_type : String = "Low"
var graphics_mapping := {
	"Low": {
		"shadow_quality": 3,
		"ssil_quality": 2,
		"ssao_quality": 2,
		"ssr_quality": 1,
		"volumetric_fog_quality": 64,
		"msaa_quality": 1,
	},
	"High": {
		"shadow_quality": 4,
		"ssil_quality": 3,
		"ssao_quality": 3,
		"ssr_quality": 2,
		"volumetric_fog_quality": 128,
		"msaa_quality": 2,
	},
	
	"Highest": {
		"shadow_quality": 5,
		"ssil_quality": 4,
		"ssao_quality": 4,
		"ssr_quality": 3,
		"volumetric_fog_quality": 256,
		"msaa_quality": 3,
	}
}

@export_range(0, 100, 1) var master_volume := 10
@export_range(0, 100, 1) var sfx_volume := 10
@export_range(0, 100, 1) var music_volume := 10

@export_range(0, 10, .01) var sensitivity := 1.0

func load_or_create() -> ConfigPreferences:
	if ResourceLoader.exists(dev_save_path):
		var loaded_preferences := load(dev_save_path)
		if loaded_preferences != null:
			return loaded_preferences
	return self

func save() -> void:
	ResourceSaver.save(self, dev_save_path)

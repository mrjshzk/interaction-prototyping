extends Node


var preferences := ConfigPreferences.new().load_or_create()

signal preferences_updated(new_preferences: ConfigPreferences)
signal preferences_force_update

func _ready() -> void:
	preferences_force_update.connect(preferences_updated.emit.bind(preferences))
	update_preferences()

func update_preferences() -> void:
	update_window()
	update_graphics()
	update_audio()
	preferences_updated.emit(preferences)

func update_window() -> void:
	if DisplayServer.has_feature(DisplayServer.FEATURE_WINDOW_EMBEDDING):
		return
	DisplayServer.window_set_mode(preferences.fullscreen_mapping[preferences.fullscreen])
	DisplayServer.window_set_size(preferences.resolution)
	

func update_graphics() -> void:
	RenderingServer.viewport_set_msaa_2d(get_viewport().get_viewport_rid(), preferences.graphics_mapping.get(preferences.graphics_type).get("msaa_quality"))
	RenderingServer.viewport_set_msaa_3d(get_viewport().get_viewport_rid(), preferences.graphics_mapping.get(preferences.graphics_type).get("msaa_quality"))
	
	RenderingServer.environment_set_ssil_quality(preferences.graphics_mapping.get(preferences.graphics_type).get("ssil_quality"), true, 0.5, 4, 50, 300)
	RenderingServer.environment_set_ssao_quality(preferences.graphics_mapping.get(preferences.graphics_type).get("ssao_quality"), true, 0.5, 2, 50, 300)
	RenderingServer.environment_set_ssr_roughness_quality(preferences.graphics_mapping.get(preferences.graphics_type).get("ssr_quality"))
	
	
	RenderingServer.positional_soft_shadow_filter_set_quality(preferences.graphics_mapping.get(preferences.graphics_type).get("shadow_quality"))
	RenderingServer.directional_soft_shadow_filter_set_quality(preferences.graphics_mapping.get(preferences.graphics_type).get("shadow_quality"))

func update_audio() -> void:
	var master_audio_in_db : float = linear_to_db(clampf((preferences.master_volume / 100.0), 0, 100))
	var sfx_audio_in_db : float = linear_to_db(clampf((preferences.sfx_volume / 100.0), 0, 100))
	var music_audio_in_db : float = linear_to_db(clampf((preferences.music_volume / 100.0), 0, 100))
	
	AudioServer.set_bus_volume_db(0, master_audio_in_db)
	AudioServer.set_bus_volume_db(1, sfx_audio_in_db)
	AudioServer.set_bus_volume_db(2, music_audio_in_db)


func _exit_tree() -> void:
	preferences.save()

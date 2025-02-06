@tool
extends EditorScenePostImport

const ALBEDO: String = "albedo.png"
const NORMAL_MAP: String = "normal_map.png"
const METTALIC: String = "mettalic.png"
const AO: String = "ao.png"
const ROUGHNESS: String = "roughness.png"
const EMISSION: String = "emission.png"

var root_target_folder : String = "res://props"

var steam_audio_default_mat : SteamAudioMaterial = preload("res://addons/godot-steam-audio/materials/default_material.tres")

func _post_import(scene: Node) -> Object:
	var children: Array[Node] = get_all_children(scene)
	var time_start : float = Time.get_unix_time_from_system()
	for node: Node in children:
		print(node.name)
		iterate(node)
	var time_end : float = Time.get_unix_time_from_system()
	var return_string: String = "[color=green]Time taken reimporting: %d (seconds)" % [time_end - time_start]
	print_rich(return_string)
	return scene

func get_all_children(node: Node) -> Array[Node]:
	var nodes: Array[Node] = []
	for N: Node in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	return nodes

func iterate(node: Node) -> void:
	if node != null:
		if node is MeshInstance3D:
			## setup filename
			var filename : String = node.name
			#filename = filename.trim_prefix("res://cleanup_import/GLB/")
			#filename = filename.trim_suffix(".glb")
			
			## setup folder
			var target_folder : String = root_target_folder + "/" + filename + "/"
			var dir : DirAccess = DirAccess.open(root_target_folder)
			dir.make_dir(filename)
			
			## setup mesh and material
			var mesh: Mesh = node.mesh
			
			
			# setup materials
			var textures_path: String = target_folder + "textures/"
			DirAccess.make_dir_absolute(textures_path)
			for index: int in range(mesh.get_surface_count()):
				# copy albedo texture
				var surface_material : StandardMaterial3D = node.get_active_material(index)
				var surface_material_albedo : CompressedTexture2D = surface_material.albedo_texture
				
				var current_surface_texture_path : String = "%ssurface_%d/" % [textures_path, index]
				DirAccess.make_dir_absolute(current_surface_texture_path)
				
				var mat: StandardMaterial3D = StandardMaterial3D.new()
				mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
				
				mat.vertex_color_is_srgb = surface_material.vertex_color_is_srgb
				mat.vertex_color_use_as_albedo = surface_material.vertex_color_use_as_albedo
				
				if surface_material.albedo_texture:
					DirAccess.copy_absolute(surface_material_albedo.resource_path, current_surface_texture_path + ALBEDO)
				
				if surface_material.normal_texture:
					mat.normal_enabled = true
					DirAccess.copy_absolute(surface_material.normal_texture.resource_path, current_surface_texture_path + NORMAL_MAP)
				
				if surface_material.metallic_texture:
					mat.metallic = surface_material.metallic
					mat.metallic_specular = surface_material.metallic_specular
					if surface_material.metallic_specular == 0.5:
						mat.metallic_specular = 0.15
					mat.metallic_texture_channel = surface_material.metallic_texture_channel
					DirAccess.copy_absolute(surface_material.metallic_texture.resource_path, current_surface_texture_path + METTALIC)
				
				if surface_material.ao_texture:
					mat.ao_enabled = true
					mat.ao_light_affect = 0.15
					mat.ao_texture_channel = surface_material.ao_texture_channel
					DirAccess.copy_absolute(surface_material.ao_texture.resource_path, current_surface_texture_path + AO)
				
				if surface_material.roughness_texture:
					mat.roughness = surface_material.roughness
					mat.roughness_texture_channel = surface_material.roughness_texture_channel
					DirAccess.copy_absolute(surface_material.roughness_texture.resource_path, current_surface_texture_path + ROUGHNESS)
				
				if surface_material.emission_texture:
					mat.emission_enabled = true
					mat.emission = surface_material.emission
					DirAccess.copy_absolute(surface_material.emission_texture.resource_path, current_surface_texture_path + EMISSION)
				
				var save_path: String = "%sm_%s_surface_%d.material" % [target_folder, filename, index]
				ResourceSaver.save(mat, save_path)
			
			for index: int in range(mesh.get_surface_count()):
				var load_path : String = "%sm_%s_surface_%d.material" % [target_folder, filename, index]
				mesh.surface_set_material(index, load(load_path))
			
			ResourceSaver.save(mesh, target_folder + "mesh_" + filename + ".mesh")
			
			
			
			var packed_string : Array[String]
			for index: int in range(mesh.get_surface_count()):
				var current_surface_texture_path : String = "%ssurface_%d/" % [textures_path, index]
				var current_folder : DirAccess = DirAccess.open(current_surface_texture_path)
				packed_string.append_array(current_folder.get_files())
				
			EditorInterface.get_resource_filesystem().reimport_files(PackedStringArray(packed_string))
			
			EditorInterface.get_resource_filesystem().scan()
			
			for index: int in range(mesh.get_surface_count()):
				var load_path : String = "%sm_%s_surface_%d.material" % [target_folder, filename, index]
				var material : StandardMaterial3D = load(load_path)
				
				var current_surface_texture_path : String = "%ssurface_%d/" % [textures_path, index]
				
				
				var albedo_tex: Texture = load(current_surface_texture_path + ALBEDO)
				var normal_tex: Texture = load(current_surface_texture_path + NORMAL_MAP)
				var mettalic_tex: Texture = load(current_surface_texture_path + METTALIC)
				var ao_tex: Texture = load(current_surface_texture_path + AO)
				var roughness_tex: Texture = load(current_surface_texture_path + ROUGHNESS)
				var emission_tex: Texture = load(current_surface_texture_path + EMISSION)
				
				material.albedo_texture = albedo_tex
				material.normal_texture = normal_tex
				material.metallic_texture = mettalic_tex
				material.ao_texture = ao_tex
				material.roughness_texture = roughness_tex
				material.emission_texture = emission_tex
				
				var save_path: String = "%sm_%s_surface_%d.material" % [target_folder, filename, index]
				ResourceSaver.save(load(save_path), save_path)
			
			var node_3d : Node3D = Node3D.new()
			node_3d.name = filename
			
			
			var mesh_instance: MeshInstance3D = MeshInstance3D.new()
			node_3d.add_child(mesh_instance)
			mesh_instance.owner = node_3d
			mesh_instance.name = filename
			mesh_instance.mesh = load(target_folder + "mesh_" + filename + ".mesh")
			
			(mesh_instance.mesh as ArrayMesh).shadow_mesh = null
			(mesh_instance.mesh as ArrayMesh).lightmap_unwrap(mesh_instance.global_transform, .05)
			
			ResourceSaver.save(mesh, target_folder + "mesh_" + filename + ".mesh")
			
			var steam_audio_geometry: SteamAudioGeometry = SteamAudioGeometry.new()
			mesh_instance.add_child(steam_audio_geometry)
			steam_audio_geometry.owner = node_3d
			steam_audio_geometry.name = "SteamAudioGeometry"
			steam_audio_geometry.material = steam_audio_default_mat
			
			mesh_instance.create_convex_collision()
			
			var packed_scene : PackedScene = PackedScene.new()
			packed_scene.pack(node_3d)
			ResourceSaver.save(packed_scene, target_folder + filename + ".tscn")

extends Node3D

func set_material(material):
	$"offset/mesh1".set_surface_override_material(0, material)
	$"offset/mesh2".set_surface_override_material(0, material)

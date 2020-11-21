extends Spatial

func set_material(material):
    $"offset/mesh1".set_surface_material(0, material)
    $"offset/mesh2".set_surface_material(0, material)

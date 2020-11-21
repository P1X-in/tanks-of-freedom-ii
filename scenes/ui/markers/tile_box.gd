extends Spatial

onready var mesh = $"mesh"


func set_mesh_material(material):
    self.mesh.set_surface_material(0, material)

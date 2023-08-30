extends "res://scenes/tiles/tile.gd"

func hide_mesh():
    super.hide_mesh()
    $"flyable_tile".hide()
    

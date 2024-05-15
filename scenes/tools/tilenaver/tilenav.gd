@tool
extends Node

class_name TileNav

@export var target_layer : int
@export var navigation_tile_id : int = 15
@export var navigation_atlas_chord : Vector2i = Vector2i(1,1)
@export var jump_height : int = 6
@export var x_offset : int = 1
@export var slope : int = 2

@export var tile_map_reference : TileMap :
	set (val):
		if val != null:
			var tmap : TileMap = val as TileMap
			var bounding_box = tmap.get_used_rect()
			tmap.add_layer(-1)
			tmap.set_layer_name(-1,"navigation tool output")
			
			for x in bounding_box.size.x:
				for y in bounding_box.size.y:
					tmap.set_cell(
						-1,
						Vector2i(x,y)+bounding_box.position,
						navigation_tile_id,
						navigation_atlas_chord
						)
			for point : Vector2i in tmap.get_used_cells_by_id(target_layer):
				for x in range(x_offset):
					for y in range(jump_height):
						tmap.set_cell(-1,point+Vector2i(x,-y)) #clear out the cells from the tile map
						tmap.set_cell(-1,point+Vector2i(-x,-y)) #clear out the cells from the tile map
	get:
		return tile_map_reference

static func create_navigation_mesh(tile_map : TileMap,layer : int)->void:
	for pos in tile_map.get_used_cells(layer):
		print(pos)



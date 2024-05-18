@tool
extends Node

class_name TileNav

@export var target_layer : int
@export var navigation_tile_id : int = 15
@export var navigation_atlas_chord : Vector2i = Vector2i(1,1)
@export var jump_height : int = 6
@export var x_offset : int = 1
@export var x_vertical_smear : int = 2
@export var ciel_height : int = 1
@export var x_cut : int = 2
@export var slope : int = 2


#sends a tile out in a direction from a given tile for count times
func ray_cast_tiles(tmap,
							tile_pos : Vector2i,
							ray_dir : Vector2i,
							count=10,
							tile_id=navigation_tile_id,
							tile_atlas_chord=navigation_atlas_chord
						)->void:
	for i in range(1,count+1):
		if tmap.get_cell_source_id(target_layer,tile_pos+ray_dir*i) != -1: break
		tmap.set_cell(-1,
								tile_pos+ray_dir*i,
								tile_id,
								tile_atlas_chord
								)


@export var tile_map_reference : TileMap :
	set (val):
		if val != null:
			var tmap : TileMap = val as TileMap
			tmap.add_layer(-1)
			tmap.set_layer_name(-1,"navigation tool output")
			
			for point : Vector2i in tmap.get_used_cells_by_id(target_layer):
				if tmap.get_cell_source_id(target_layer,point + Vector2i.UP) != -1: continue
				
				for y in range(x_vertical_smear):
					ray_cast_tiles(tmap,point + Vector2i.UP*(y+1),Vector2i(1,0),x_offset)
					ray_cast_tiles(tmap,point + Vector2i.UP*(y+1),Vector2i(-1,0),x_offset)

				ray_cast_tiles(tmap,point,Vector2(0,-1),jump_height)

			for point : Vector2i in tmap.get_used_cells_by_id(target_layer):
				tmap.set_cell(-1,point)
				ray_cast_tiles(tmap,point+Vector2i.DOWN,Vector2i.DOWN,ciel_height,-1,-1)
				
				for y in range(x_vertical_smear):
					ray_cast_tiles(tmap,point+Vector2i.RIGHT,Vector2i.RIGHT,x_cut,-1,-1)
					ray_cast_tiles(tmap,point+Vector2i.LEFT,Vector2i.LEFT,x_cut,-1,-1)
	get:
		return tile_map_reference

static func create_navigation_mesh(tile_map : TileMap,layer : int)->void:
	for pos in tile_map.get_used_cells(layer):
		print(pos)



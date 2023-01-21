extends Node
#this is a generic static library that contains all of the functions that interact
#with saving the game and loading new game scenes

class_name SaveUtils

#builds a new file directory if one does not already exist
static func generate_file_structure()->void:
	var dir  = DirAccess.open("user://")
	if not dir.dir_exists("./saves"):
		dir.make_dir("saves")

#gets a save path from a game name
static func get_save_path(game_name : String)->String:
	return "user://saves/" + game_name + ".res"

#makes a new game with the give game name
static func new_game(game_name : String)->void:
	var savegame : SaveResource = SaveResource.new()
	savegame.saved_scene = "res://scenes/levels/level1.tscn"
	savegame.spawn_light = "spawn_light_orchard"
	
	ResourceSaver.save(savegame,get_save_path(game_name))

#this script contains all of the functions used to save the game
static func save_game(game_name : String,
						save_level : Level,
						ghost_light : Entity):
	var savegame : SaveResource = get_save_data(game_name)
	if not savegame:
		savegame = SaveResource.new()
	#edit the data
	savegame.saved_scene = save_level.name
	savegame.spawn_light = ghost_light.name
	savegame.level_data[save_level.name] = save_level.level_data
	
	print("saving at " + get_save_path(game_name))
	#write the data to disc
	ResourceSaver.save(savegame,get_save_path(game_name))

static func get_save_data(game_name : String)->SaveResource:
	return (ResourceLoader.load(get_save_path(game_name)) as SaveResource)

static func put_save_data(save_data : SaveResource,game_name : String):
	return ResourceSaver.save(save_data,get_save_path(game_name))
static func get_level_path(scene_name : String)->String:
	return "res://scenes/levels/" + scene_name + ".tscn"

#loads a given scene for the given game
static func load_level(game_name : String,
						root : Node,
						scene_name : String,
						ghost,
						spawn_object_name : String)->void:
	

	
	if ghost.get_parent():
		ghost.get_parent().remove_child(ghost)

	var to_replace = root.get_child(0)
	root.remove_child(to_replace)
	to_replace.call_deferred("free")
	
	
	var next_lvl = load(get_level_path(scene_name))
	var lvl = next_lvl.instantiate()
	
	root.add_child(lvl)
	var save_data : SaveResource = get_save_data(game_name)
	if save_data:
		(lvl as Level).level_data = save_data.level_data[scene_name]
	
	lvl.add_child(ghost)
	
	var spawn_object = lvl.get_node(spawn_object_name)
	if spawn_object and spawn_object is Entity:
		ghost.global_position = (spawn_object as Entity).unposses_position()

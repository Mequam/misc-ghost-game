extends Resource 
#contains functions for interacting with a save

class_name GameSaveResource 

#this is the level that our resource loads
@export 
var load_lvl : String = "res://scenes/levels/orchard/entryLevel/EntryLevel.tscn"

#this is the lamp IN that level that we load at
@export 
var lvl_lamp : String = "firstLight"

#globally saved game variables
#we could be a bit more complex with this, but this works for now
@export 
var game_variables : Dictionary  = {}

#save number that we use
@export 
var game_name : String = "game 0"


#convinence function to get the packed scene of a game save
func get_packed_scene()->PackedScene:
	return load(load_lvl)

#returns a list of all game directories stored in our saves folder
static func list_game_saves():
	var tmp = DirAccess.get_directories_at("user://saves/") 
	var ret_val = []
	#game saves are stored at game_<name>, we only want the name!
	for word in tmp:
		ret_val.append(word.split("_")[1])
	return ret_val

func get_save_folder_path()->String:
	return GameSaveResource.get_save_folder_path_gn(game_name)
#gets the save folder for the given game number
static func get_save_folder_path_gn(gameName : String)->String:
	return "user://saves/game_" + str(gameName)
func get_save_path()->String:
	return GameSaveResource.get_save_path_gn(game_name)
#returns the path that we would save this game at given a game_name
static func get_save_path_gn(gameName : String)->String:
	return get_save_folder_path_gn(gameName) + "/save_" + str(gameName) + ".tres" 

func ensure_save_dir()->void:
	return GameSaveResource.ensure_save_dir_gn(game_name)

#creates the save directory structure if it does not exist
static func ensure_save_dir_gn(gameName : String)->void:
	if not DirAccess.dir_exists_absolute(GameSaveResource.get_save_folder_path_gn(gameName)):
		DirAccess.make_dir_recursive_absolute(GameSaveResource.get_save_folder_path_gn(gameName))


#saves this game resource
func save_game()->void:
	ensure_save_dir()
	ResourceSaver.save(self,self.get_save_path())

#loads a game save resource from the given name
static func load_game_gn(gameName : String)->GameSaveResource:
	GameSaveResource.ensure_save_dir_gn(gameName)
	return ResourceLoader.load(GameSaveResource.get_save_path_gn(gameName))

func load_game()->GameSaveResource:
	self.ensure_save_dir()
	return ResourceLoader.load(self.get_save_path())

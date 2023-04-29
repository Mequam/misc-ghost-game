extends Resource 
#contains functions for interacting with a save

class_name GameSaveResource 

#this is the level that our resource loads
@export 
var load_lvl : String 

#this is the lamp IN that level that we load at
@export 
var lvl_lamp : String

#globally saved game variables
#we could be a bit more complex with this, but this works for now
@export 
var game_variables : Dictionary 

#save number that we use
@export 
var game_name : String = "game 0"


#returns a list of all game directories stored in our saves folder
static func list_game_saves():
	return DirAccess.get_directories_at("user://saves/")

func get_save_folder_path()->String:
	return get_save_folder_path_gn(game_name)
#gets the save folder for the given game number
func get_save_folder_path_gn(gameName : String)->String:
	return "user://saves/game_" + str(gameName)
func get_save_path()->String:
	return get_save_path_gn(game_name)
#returns the path that we would save this game at given a game_name
func get_save_path_gn(gameName : String)->String:
	return get_save_folder_path_gn(gameName) + "/save_" + str(gameName) + ".res" 

func ensure_save_dir()->void:
	return ensure_save_dir_gn(game_name)

#creates the save directory structure if it does not exist
func ensure_save_dir_gn(gameName : String)->void:
	if not DirAccess.dir_exists_absolute(get_save_folder_path_gn(gameName)):
		DirAccess.make_dir_recursive_absolute(get_save_folder_path_gn(gameName))


#saves this game resource
func save_game()->void:
	ensure_save_dir()
	ResourceSaver.save(self,self.get_save_path())

func load_game()->GameSaveResource:
	self.ensure_save_dir()
	return ResourceLoader.load(self.get_save_path())

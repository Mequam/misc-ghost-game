extends Node
#this script is inteanded to be used as a singleton for loading 
#game levels and objects

#global game flags
var game_data : GameSaveResource

func remove_objects_from_tree(persist_obj):
	#remove all persistant objects from the game
	#note this keeps them loaded
	for obj in persist_obj:
		if obj.get_parent():
			obj.get_parent().remove_child(obj)

func get_level_container()->Node2D:
	return get_tree().get_root().get_node("Main").get_node("LevelContainer")

#returns a reference to the currently loaded level node
func get_level_node()->Level:
	var container = get_level_container()
	return container.get_child(container.get_child_count() - 1)

func clear_level()->void:
	var old_lvl = get_level_node()
	if old_lvl:
		old_lvl.queue_free()


func bootstrap_gn(game_name : String)->void:
	bootstrap(GameSaveResource.load_game_gn(game_name))

#sets up the allways loaded arcitecture into the game and prepares for future loads
func bootstrap(gsr)->void:
	game_data = gsr #store the game save resource
	get_tree().change_scene_to_file("res://scenes/levels/mainscene/mainscene.tscn") #change the the main "stage"

#sets the tree to be at the state of the current game save
func load_save()->void:
	#load the level into the game
	var scn = self.game_data.get_packed_scene()
	var lvl = load_level(scn,self,[])
	#instance leni

	#reset the player character
	var leni = load("res://scenes/entities/Leni/Leni.tscn").instantiate()
	
	#ensure that leni has context information so it can run
	var lamp = lvl.get_node(self.game_data.lvl_lamp) 

	leni.respawn_point = lamp 
	leni.ghost_after_effect = get_level_container().get_node("AfterImageMesh")

	lvl.add_child(leni) #add leni as a child of the level
	lamp.posses_by(leni) #ensure that we are possesing the lamp



func save_game()->void:
	self.game_data.save_game()
func save_game_from_lamp(lamp : RespawnLamp)->void:
	self.game_data.save_game_from_lamp(lamp)

#returns a list of saved games
func list_game_saves():
	pass 

#loads a level into the level container,
#should only be called if the level container is loaded

#returns a reference to the loaded level
func load_level(level,_caller,persist_obj=[]):
	#safely remove the level
	remove_objects_from_tree(persist_obj)
	clear_level()

	#load and add the objects to the new level
	var loaded_lvl = level.instantiate()
	for obj in persist_obj:
		loaded_lvl.add_child(obj)

	
	#add the level node
	var container = get_level_container()
	container.add_child(loaded_lvl)
	
	return loaded_lvl

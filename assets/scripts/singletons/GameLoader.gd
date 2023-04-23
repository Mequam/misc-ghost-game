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
	return get_level_container().get_child(0)

func clear_level()->void:
	var old_lvl = get_level_node()
	if old_lvl:
		old_lvl.queue_free()
func load_level(level,_caller,persist_obj=[])->void:
	remove_objects_from_tree(persist_obj)
	clear_level()
	var loaded_lvl = level.instantiate()
	
	for obj in persist_obj:
		loaded_lvl.add_child(obj)
	
	get_level_container().add_child(loaded_lvl)


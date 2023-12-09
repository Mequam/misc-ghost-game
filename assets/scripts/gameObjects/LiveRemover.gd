extends Node
#this node is a convinence node that marks its parent for removal 
#during live processing of the game

#basically, use this thing to implement percistant death

class_name LiveRemover

func recursive_getter(criteria : Callable)->Node:
	var node = get_parent()
	while not criteria.call(node):
		node = node.get_parent()
	return node
#returns a reference to the main scene
func get_main()->MainScene:
	return recursive_getter(func (x) : return x is MainScene)
func get_level()->Level:
	return recursive_getter(func (x) : return x is Level)


func get_runtime_path(level : Level)->String:
	return level.load_path + "/removals"
func _ready()->void:
	var level = get_level()
	var main = get_main()
	if main.runtime_variables.has(get_runtime_path(level)) \
			and get_parent().name in main.runtime_variables[get_runtime_path(level)]: 
		get_parent().queue_free()

#marks that we are to be removed on scene load in the runtime variables
func mark_removal()->void:
	var level = get_level()
	var main = get_main()
	
	#ensure that we can store data in the runtime variables
	if not main.runtime_variables.has(get_runtime_path(level)):
		main.runtime_variables[get_runtime_path(level)] = []

	#no reason to 
	if get_parent().name in main.runtime_variables[get_runtime_path(level)]: return

	main.runtime_variables[get_runtime_path(level)].append(get_parent().name)






extends Node

class_name LiveLevalPersistanceNode

var original_level : String
var live_remover : LiveRemover

#find a level decendent
func get_level()->Level:
	var ret_val = get_parent()
	while not ret_val is Level:
		ret_val = ret_val.get_parent()
	return ret_val

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lvl = get_level()
	
	self.live_remover = get_node("LiveRemover")
	self.live_remover.target = get_parent()


	self.original_level = lvl.load_path

	if get_parent() is Entity:
		get_parent().sig_after_load.connect(on_entity_finished_load)

	#var lvl_dict : Dictionary = lvl.get_main().runtime_variables["llp"]

	#if lvl.load_path in lvl_dict and get_path() in lvl_dict[lvl.load_path]:
	#		queue_free()
		
func remove_from_current()->void:
	var lvl = get_level()

	if lvl.load_path == original_level:
		print_debug("marking removal")
		live_remover.mark_removal()
	else:
		if lvl.load_path in lvl.get_main().runtime_variables["llp"]:
			lvl.get_main().runtime_variables["llp"][lvl.load_path].erase(get_parent())

func add_to_level(lvl : Level):
	if lvl.load_path == original_level:
		live_remover.unmark_removal()
	else:
		if not lvl.load_path in lvl.get_main().runtime_variables["llp"]:
			lvl.get_main().runtime_variables["llp"][lvl.load_path] = []

		lvl.get_main().runtime_variables["llp"][lvl.load_path].append([get_parent()])

#called if our parent is an entity and enteres loads into a level
func on_entity_finished_load(level : Level):
	add_to_level(level)

extends LiveRemover

class_name LiveLevalPersistanceNode

var original_level : String
var original_name : String

#find a level decendent
func get_level()->Level:
	var ret_val = get_parent()
	while not ret_val is Level:
		ret_val = ret_val.get_parent()
	return ret_val

func get_target_name()->String:
	return self.original_name
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lvl = get_level()
	
	self.original_level = lvl.load_path

	if get_parent() is Entity:
		get_parent().sig_after_load.connect(on_entity_finished_load)
		get_parent().sig_before_load.connect(on_entity_before_load)

	#call the previous ready function
	super._ready()

	#store the name of our parent for when we return to this level
	#and meet our clone, at which point the names will be different
	self.original_name = get_parent().name

func remove_from_current()->void:
	var lvl = get_level()

	if lvl.load_path == original_level:
		print_debug("marking removal")
		mark_removal()
	else:
		print_debug("preparing to attempt removal from tree")
		if lvl.load_path in lvl.get_main().runtime_variables["llp"]:
			print_debug("removing from the tree")
			lvl.get_main().runtime_variables["llp"][lvl.load_path].erase(get_parent())

func add_to_level(lvl : Level):
	if lvl.load_path == original_level:
		unmark_removal()
	else:
		if not lvl.load_path in lvl.get_main().runtime_variables["llp"]:
			lvl.get_main().runtime_variables["llp"][lvl.load_path] = []

		lvl.get_main().runtime_variables["llp"][lvl.load_path].append(get_parent())

#called if our parent is an entity and enteres loads into a level
func on_entity_finished_load(level : Level):
	add_to_level(level)

#called right before we are going to load a new level
func on_entity_before_load():
	self.remove_from_current()

extends Node

#this node searches through the scene tree in order to find the LeniGarnish and register the parent node as potentialy garnishable

class_name LeniGarnishRegister

#this will return a LeniGarnish or hang trying
func find_leni_garnish()->LeniGarnish:
	var ret_val = get_parent()
	while not (ret_val is LeniGarnish):
		ret_val = ret_val.get_parent()
	return ret_val

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var to_register = get_parent()
	find_leni_garnish().register_garnish(to_register)

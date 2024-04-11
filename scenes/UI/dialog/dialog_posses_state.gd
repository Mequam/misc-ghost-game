extends DialogStateMachine

# this class represents a dialog statemachine that changes its behavior depending
# on wether or not a parent entity is possesed


class_name DialogPossesStateMachine

#if true when our parent is possesed we trigger our next functionality
@export var trigger_on_posses : bool = false


func get_entity_parent()->Entity:
	var p = get_parent()
	while not (p is Entity):
		p = p.get_parent()
	return p

func _ready() -> void:
	var entity_parent = get_entity_parent()
	entity_parent.sig_possesed_by.connect(on_entity_parent_possesed_by)
	entity_parent.sig_unpossesed_by.connect(on_entity_parent_unpossed_by)

	super._ready()

func on_entity_parent_possesed_by(_posessee,_ghost)->void:
	self.selection = 1
	if self.trigger_on_posses:
		self.next()
func on_entity_parent_unpossed_by(_posessee,_ghost)->void:
	self.selection = 0



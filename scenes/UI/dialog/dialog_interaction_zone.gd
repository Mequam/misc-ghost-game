extends InteractionZone

class_name DialogInteractionZone

@export var dialog_component : DialogComponent

func _ready()->void:
	self.interacted_with.connect(on_interaction)
	super._ready()

func on_interaction(from)->void:
	#trigger the next dialog
	dialog_component.next()


extends Area2D

class_name DialogStateMachineZone

@export var dialog_state_machine : DialogStateMachine
@export var entry_selection = 0
@export var exit_selection = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(on_body_entered)
	self.body_entered.connect(on_body_exited)
func on_body_entered(body)->void:
	if entry_selection != -1:
		dialog_state_machine.selection = entry_selection

func on_body_exited(body)->void:
	if exit_selection != -1:
		dialog_state_machine.selection = exit_selection


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

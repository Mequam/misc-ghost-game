extends Control

@export var lblActionName : Label
@export var btnActionEvent : BtnHandDrawn
@export var btnReset : BtnHandDrawn

var action_renamer : InputNamer

#true if we are activly scanning for input to overide the action with
var change_input : bool = false

#the action that this control might go about changing
var action : StringName

func get_game_settings()->GlobalGameSettings:
	return GlobalGameSettings.load_settings()

#displays the given action name on the control,
#and returns true if the action has keys to map,
#and false if the action is unmapped
func set_action(action : StringName,action_remapper : InputNamer)->bool:
	self.action_renamer = action_remapper


	self.action = action

	var events : Array[InputEvent] = InputMap.action_get_events(action)

	lblActionName.text = action_renamer.action_name2string(action)

	if len(events) < 1:
		btnActionEvent.label.text = "unset"
		return false
	btnActionEvent.label.text = action_renamer.event2string(events[0])


	self.action_renamer = action_renamer

	return true  

#called when the button to re map controls
#is pressed
func on_set_click()->void:
	#make sure that the other nodes are not listening in for input
	get_tree().call_group("action_mappers","stop_listening")

	self.change_input = true

	btnActionEvent.label.text = "press any key..."

func on_reset_click()->void:
	#update the action display
	var settings : GlobalGameSettings = get_game_settings()
	settings.remove_remap(self.action)

	self.set_action(self.action,self.action_renamer)

func _ready()->void:
	self.add_to_group("action_mappers")
	btnActionEvent.pressed.connect(self.on_set_click)
	btnReset.pressed.connect(self.on_reset_click)

#used in a group call to stop all other input changers
#from changing the input when we are selected
func stop_listening()->void:
	self.change_input = false

	#re-set the action 
	#in case we need to re-update the display
	self.set_action(self.action,self.action_renamer)
func _input(event : InputEvent)->void:
	if change_input and not (event is InputEventMouse) and event is InputEventKey:
		change_input = false

	
		var settings : GlobalGameSettings = self.get_game_settings()
		settings.add_remap(self.action,event)
		settings.save_settings()

		#re-update the action
		self.set_action(self.action,self.action_renamer)





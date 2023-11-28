extends Control

@export var lblActionName : Label
@export var btnActionEvent : BtnHandDrawn

#displays the given action name on the control,
#and returns true if the action has keys to map,
#and false if the action is unmapped
func set_action(action : StringName)->bool:

	var events : Array[InputEvent] = InputMap.action_get_events(action)

	lblActionName.text = action

	if len(events) < 1:
		btnActionEvent.label.text = "unset"
		return false
	btnActionEvent.label.text = events[0].as_text()

	return true
#called when the button to re map controls
#is pressed
func on_click()->void:
	btnActionEvent.label.text = "press any key..."

func _ready()->void:
	btnActionEvent.pressed.connect(self.on_click)

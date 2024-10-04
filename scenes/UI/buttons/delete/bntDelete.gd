extends BtnHandDrawn

#this class represents a button that you can press to delete a save

class_name BtnDelete

var enabled : bool = false

#represents the save that we are going to delete
var save_to_delete : String = ""

signal on_save_delete

func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(self.on_delete_animation_finished)
	super._ready()

#delete the given save
func on_delete_animation_finished(anim)->void:
	if anim == "delete_warning":
		GameSaveResource.delete_game_gn(self.save_to_delete)
		#let everyone know that we purged the save
		on_save_delete.emit(self)

#turn the button on and off
#based on mouse movement
func on_mouse_entered()->void:
	enabled = true
	super.on_mouse_entered()

func on_mouse_exited()->void:
	enabled = false
	super.on_mouse_exited()

func _input(event: InputEvent) -> void:
	if enabled and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT: 
		if event.pressed:
			$AnimationPlayer.speed_scale = 4.5
			$AnimationPlayer.play("delete_warning")
		else:
			$AnimationPlayer.play("RESET")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

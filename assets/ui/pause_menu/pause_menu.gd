extends BackStackControl

class_name PauseMenu

#reference to the main scene of the game,
#used for unpausing
@export var main_scene : MainScene
@export var resume_button : TextureButton

@export var can_unpause : bool = false

var dead_zone : float = 0

func _ready()->void:
	super._ready()
	resume_button.pressed.connect(on_resume_pressed)

func on_resume_pressed()->void:
	main_scene.unpause()

func _process(delta : float)->void:
	if can_unpause and Input.is_action_pressed("PAUSE"):
		self.purge_stack() #go back to the first scene
		main_scene.unpause()
	if Input.is_action_just_released("PAUSE"):
		can_unpause = true

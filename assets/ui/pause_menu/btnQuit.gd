extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self.on_pressed)

func on_pressed()->void:
	#make sure that we are no longer playing
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/GameStart.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(on_pressed)

func on_pressed()->void:
	get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

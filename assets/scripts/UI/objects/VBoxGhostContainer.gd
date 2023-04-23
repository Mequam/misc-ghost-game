extends VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	for n in get_children():
		if n is Button or n is TextureButton:
			n.pressed.connect(move_leni.bindv([n]))

			
func move_leni(btn)->void:
	$LeniGarnish.target = btn


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

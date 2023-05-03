extends VBoxContainer 

class_name LeniGarnish



func register_buttons():
	for n in get_children():
		if n is Button or n is TextureButton:
			n.focus_entered.connect(move_leni.bindv([n]))
			n.mouse_entered.connect(move_leni.bindv([n]))

# Called when the node enters the scene tree for the first time.
func _ready():
	register_buttons()

func move_leni(btn)->void:
	$LeniGarnish.target = btn


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

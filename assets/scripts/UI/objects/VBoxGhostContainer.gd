extends VBoxContainer 

class_name LeniGarnish

func register_garnish(garnish)->void:
	garnish.focus_entered.connect(move_leni.bindv([garnish]))
	garnish.mouse_entered.connect(move_leni.bindv([garnish]))


func register_buttons():
	for n in get_children():
		if n is Button or n is TextureButton:
			register_garnish(n)

# Called when the node enters the scene tree for the first time.
func _ready():
	register_buttons()

func move_leni(btn)->void:
	$LeniGarnish.target = btn


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

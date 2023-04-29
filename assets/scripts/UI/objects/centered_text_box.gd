extends TextEdit

@export
var txtlbl : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	text_changed.connect(on_text_changed)

func on_text_changed():
	txtlbl.text = text

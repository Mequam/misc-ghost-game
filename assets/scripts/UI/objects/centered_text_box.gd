extends TextEdit

@export
var txtlbl : Label 
@export 
var textureRect : TextureRect 

@export var focus_texture : Texture2D 
@export var normal_texture : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	text_changed.connect(on_text_changed)
	self.focus_entered.connect(on_focus_entered)
	self.focus_exited.connect(on_focus_exited)
	update_text()
#updates the centered label with the correct text
func update_text()->void:
	txtlbl.text = text if (text != "" or self.has_focus()) else self.placeholder_text
func on_focus_exited():
	textureRect.texture = normal_texture
func on_focus_entered():
	textureRect.texture = focus_texture
	update_text()

func on_text_changed():
	update_text()

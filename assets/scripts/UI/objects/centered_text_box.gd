extends TextEdit

@export_subgroup("node components")
@export
var txtlbl : Label 
@export 
var textureRect : TextureRect 
@export 
var cursor_timer : Timer 

@export_subgroup("texture components")
@export var focus_texture : Texture2D 
@export var normal_texture : Texture2D 

# Called when the node enters the scene tree for the first time.
func _ready():
	text_changed.connect(on_text_changed)
	self.focus_entered.connect(on_focus_entered)
	self.focus_exited.connect(on_focus_exited)
	get_parent().get_node("Curser Timer").timeout.connect(on_cursor_timeout)
	update_text()
var has_bar : bool = true
func on_cursor_timeout()->void:
	has_bar = not has_bar 
	update_text()
#updates the centered label with the correct text
func update_text()->void:
	txtlbl.text = text if (text != "" or self.has_focus()) else self.placeholder_text 
	if has_bar and self.has_focus():
		var cursor = self.get_caret_column()
		var new_text = ( txtlbl.text.substr(0,cursor) + "/" +
		txtlbl.text.substr(cursor,txtlbl.text.length()-cursor)
		)
		txtlbl.text = new_text
	else:
		txtlbl.text += " "
func on_focus_exited():
	textureRect.texture = normal_texture
func on_focus_entered():
	textureRect.texture = focus_texture
	update_text()

func on_text_changed():
	update_text()

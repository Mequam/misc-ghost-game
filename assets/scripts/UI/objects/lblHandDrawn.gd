extends Button 

class_name BtnHandDrawn

@export var texture_rect : TextureRect
@export var label : Label

@export
var hover_texture  : Texture2D
@export
var default_texture : Texture2D

func _ready():
	self.mouse_entered.connect(on_mouse_entered)
	self.mouse_exited.connect(on_mouse_exited)

func on_mouse_entered():
	texture_rect.texture = hover_texture 
func on_mouse_exited():
	texture_rect.texture = default_texture 

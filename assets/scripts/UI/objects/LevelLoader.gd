extends Control

@export 
var btnContainer : VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	for save in GameSaveResource.list_game_saves():
		var b = Button.new()
		b.text = save 
		btnContainer.add_child(b)

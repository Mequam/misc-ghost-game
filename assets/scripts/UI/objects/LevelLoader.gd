extends Control
#this class represents a UI node that lets the player select a game to do 
#something to, it could be save delete reset ect.

class_name GameSelector

@export 
var btnContainer : LeniGarnish 

#emited when the player selects a given game
signal game_select

#these are the buttons that we store to start the game!
var hand_drawn_button = preload("res://scenes/UI/game_control_options.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#append padding at the start for spacing
	var padding = Control.new()
	padding.size_flags_vertical = SIZE_EXPAND 
	btnContainer.add_child(padding)

	for save in GameSaveResource.list_game_saves():
		var custom_load_button = hand_drawn_button.instantiate()
		var b : BtnHandDrawn = custom_load_button.get_node("btnLoad")
		b.label.text = save
		b.size_flags_vertical = SIZE_FILL 
		b.size_flags_horizontal = SIZE_FILL
		btnContainer.add_child(custom_load_button)
		b.pressed.connect(on_save_selected.bindv([b]))
	
	#append padding at the end for spacing
	padding = Control.new()
	padding.size_flags_vertical = SIZE_EXPAND 
	btnContainer.add_child(padding)

	#register the buttons in the leni garnish once we finish adding them
	btnContainer.register_buttons()

func on_save_selected(btn):
	GameLoader.bootstrap_gn(btn.label.text)

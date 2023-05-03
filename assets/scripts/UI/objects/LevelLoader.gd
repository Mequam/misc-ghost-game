extends Control

@export 
var btnContainer : LeniGarnish

#these are the buttons that we store to start the game!
var hand_drawn_button = preload("res://scenes/UI/btnHandDrawn.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#append padding at the start
	var padding = Control.new()
	padding.size_flags_vertical = SIZE_EXPAND 
	btnContainer.add_child(padding)

	for save in GameSaveResource.list_game_saves():
		var b = hand_drawn_button.instantiate()
		b.label.text = save
		b.size_flags_vertical = SIZE_FILL 
		b.size_flags_horizontal = SIZE_FILL
		btnContainer.add_child(b)
	#append padding at the end
	padding = Control.new()
	padding.size_flags_vertical = SIZE_EXPAND 
	btnContainer.add_child(padding)

	btnContainer.register_buttons()

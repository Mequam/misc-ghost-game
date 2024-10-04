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
	var game_saves = GameSaveResource.list_game_saves()
	for save in game_saves:
		var custom_load_button : LoadDeleteWidget = hand_drawn_button.instantiate()
		custom_load_button.btn_delete.save_to_delete = save
		custom_load_button.btn_delete.on_save_delete.connect(self.on_save_delete)


		var b : BtnHandDrawn = custom_load_button.btn_load
		b.label.text = save
		b.size_flags_vertical = SIZE_FILL 
		b.size_flags_horizontal = SIZE_FILL
		btnContainer.add_child(custom_load_button)
		b.pressed.connect(on_save_selected.bindv([b]))
	
	#append some padding to the container to avoid obscenly large buttons
	if len(game_saves) < 20:
		for i in range(20 - len(game_saves)):
			var c : Control = Control.new()
			#take up space as a buffer
			c.grow_vertical = Control.GROW_DIRECTION_BOTH
			c.size_flags_vertical = Control.SIZE_EXPAND
			btnContainer.add_child(c)
		

	#append padding at the end for spacing
	padding = Control.new()
	padding.size_flags_vertical = SIZE_EXPAND 
	btnContainer.add_child(padding)

	#register the buttons in the leni garnish once we finish adding them
	btnContainer.register_buttons()


func on_save_delete(del_btn):
	#purge the button from the scene
	del_btn.get_parent().queue_free()
	$Control.visible = false
	$Control.call_deferred("set_visible", true)

	$GameDeleteSound.play()

func on_save_selected(btn):
	GameLoader.bootstrap_gn(btn.label.text)

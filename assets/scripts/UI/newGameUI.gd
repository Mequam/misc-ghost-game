extends Control

@export
var btnStart : Button 
@export var txtGameName : TextEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	#create a new game when the start button is pressed
	btnStart.pressed.connect(btn_start_pressed)

func btn_start_pressed():
	var gsr = GameSaveResource.new()
	gsr.game_name = txtGameName.text 
	gsr.save_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

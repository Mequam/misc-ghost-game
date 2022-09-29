extends Control
#this script is called checked the very first node in the very first scene of the game
#it is inteanded to initilize and control UI for that scene 



# Called when the node enters the scene tree for the first time.
func _ready():
	SaveUtils.generate_file_structure()


func _on_Button_pressed():
	var leni = load("res://scenes/entities/Leni.tscn").instantiate()
	SaveUtils.load_level("game1",
							get_tree().root,
							"level1",
							leni,
							"spawn_light_orchard/orchard_lamp_spawn")

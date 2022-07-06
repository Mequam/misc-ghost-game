extends Resource
#this class contains all of the data required to save and re-load the game

class_name SaveResource

#file path to the scene that the player was last at
export var saved_scene : String
#the name of the light that Leni spawns back in as
export var spawn_light : String
#a dictionary that scenes use to write data to for each individual scene
export var level_data : Dictionary

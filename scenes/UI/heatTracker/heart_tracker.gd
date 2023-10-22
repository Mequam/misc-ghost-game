extends Control

class_name HeartTracker



#this is where we store the hearts
@export var heart_container : HBoxContainer

#these represent the value of each heart
@export
var heart_texture : Array[Texture]


#displays the given life onto the ui
#with the given specifications
func update_display( hp : int,max_hp : int)->void:

	#clear out the existing children
	while self.heart_container.get_child(0):
		self.heart_container.remove_child(self.heart_container.get_child(0))

	while max_hp > 0:

		var text = TextureRect.new()
		text.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		var life = hp
		if hp >= len(heart_texture):
			life = len(heart_texture) - 1
	
		hp -= life
		print(life)
		print(hp)
		print(max_hp)
		print("-")

		text.texture = heart_texture[life] #store the appropriate 
		max_hp -= len(heart_texture) - 1 
		heart_container.add_child(text)

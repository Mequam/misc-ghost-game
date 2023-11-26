extends Node2D

class_name RandomSoundPlayer

func get_playing()->bool:
	for child in get_children():
		if child.playing:
			return true
	return false

#play one of the children randomly
func play()->void:
	print(randi_range(0,self.get_child_count()))
	self.get_child(randi_range(0,self.get_child_count()-1)).play()

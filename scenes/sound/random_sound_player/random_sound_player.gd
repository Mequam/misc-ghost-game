extends Node2D

class_name RandomSoundPlayer

#play one of the children randomly
func play()->void:
	print(randi_range(0,self.get_child_count()))
	self.get_child(randi_range(0,self.get_child_count()-1)).play()

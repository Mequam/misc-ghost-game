extends SoundTrack

#this class is inteanded to hold many different audio tracks

class_name AudioTrackContainer

#the setter functions to control our children
func set_vol_db(val)->void:
	volume_db = val
	for child in self.get_children():
		child.volume_db = child.initial_db * self.volume_db	
func get_vol_db()->float:
	return volume_db 

func get_playing()->bool:
	for child in self.get_children():
		if child.get_playing():
			return true
	return false  
func set_playing(val : bool)->void:
	if val:
		self.play()
		return
	self.stop()

func stop()->void:
	for child in self.get_children():
		child.stop()


#called when any if the children audio tracks finished
func child_finished()->void:
	if not self.playing:
		self.on_finished()
	
	#as far as the transitions are concerned we still
	#treat this like a finish for convinence
	self.check_apply_transitions(true)



#we play the first child if we are going to play
func play()->void:
	self.get_child(0).play()

func _ready()->void:
	self.volume_db = initial_db
	self.initial_play_amount = self.play_amount
	

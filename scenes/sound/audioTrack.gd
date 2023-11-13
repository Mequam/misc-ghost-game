extends AudioStreamPlayer

class_name SoundTrack

#this is a convinence class that provides some default
#functionality for the audio player class to transition between streams

#counts how many times we run before looping
@export var play_amount : int = 1
var initial_play_amount : int 
#if true, after finishing all play amounts, we reset to the initial value
@export var reset_play : bool = false
@export var transitions : Array[Transition] = []

var initial_db : float

func on_finished()->void:
	play_amount -= 1


	self.check_apply_transitions(true)

	if play_amount > 0: 
		self.play()
		return
	
	if reset_play:
		play_amount = initial_play_amount



func _ready()->void:
	self.initial_db = self.volume_db
	self.initial_play_amount = self.play_amount
	self.finished.connect(self.on_finished)

#returns the root of the sound tree
func get_sound_tree_root()->SoundTree:
	var buffer = get_parent()
	while not (buffer is SoundTree):
		buffer = buffer.get_parent()
	return buffer

#applies a given transition if possible
func check_apply_transitions(measure_break = false)->void:
	var tree_root = get_sound_tree_root()

	#check each transition
	for trans in self.transitions:
		trans.apply_transition(tree_root,self,measure_break) #indicate to the transition that we are running with an ending
	
func _process(delta)->void:
	if self.playing:
		self.check_apply_transitions()


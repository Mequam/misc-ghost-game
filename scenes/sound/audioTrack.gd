extends Node

#this class represents a track of sound

class_name SoundTrack

#this is a convinence class that provides some default
#functionality for the audio player class to transition between streams

#counts how many times we run before looping
@export var play_amount : int = 1
var initial_play_amount : int 


#if true, after finishing all play amounts, we reset to the initial value
@export var reset_play : bool = false
#array of transitions that we use to transition into OTHER audio tracks
@export var transitions : Array[Transition] = []

#reference to the audio stream that we play
@export var audio_stream : AudioStreamPlayer
#wrapper for setting the volume of this track
var volume_db : float :
	set (val):
		if self.audio_stream == null:
			volume_db = val 
		else:
			print("setting the audio volume of the child")
			self.audio_stream.volume_db = val 
	get:
		if self.audio_stream == null: return volume_db
		return self.audio_stream.volume_db

var playing : bool :
	set(val):
		self.audio_stream.playing = val 
	get:
		return self.audio_stream.playing

#used to set the initial sound of the audio stream

@export_range(-80,24) 
var initial_db : float

func stop()->void:
	self.audio_stream.stop()
func play()->void:
	self.audio_stream.play()

func on_finished()->void:
	print("finished!")
	play_amount -= 1


	self.check_apply_transitions(true)

	if play_amount > 0: 
		self.play()
		return
	
	if reset_play:
		play_amount = initial_play_amount
		self.play()



func _ready()->void:
	#set up the audio_stream reference
	if self.audio_stream == null and self.get_child(0) is AudioStreamPlayer:
		self.audio_stream = self.get_child(0)

	self.volume_db = initial_db
	print(self.name)
	print(volume_db)
	print(self.audio_stream.volume_db)
	print("-")
	self.audio_stream.volume_db = volume_db


	#store the initial_db
	#self.volume_db = volume_db
	##run the setter for the volume
	#self.initial_db = self.volume_db
	

	self.initial_play_amount = self.play_amount

	#set up the finished function
	self.audio_stream.finished.connect(self.on_finished)

	print(self.volume_db)
	print("-----------------")

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


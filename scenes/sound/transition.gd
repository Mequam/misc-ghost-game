extends Resource

class_name Transition

#is this transition on finish only?
@export 
var on_finish : bool = true

#do we run this transition when done looping?
@export 
var on_loop : bool = false

#should we stop the previous track from playing?
@export
var stop_previous : bool = true

@export 
var clear_transition_flags : bool

#list of flags when we transition
@export 
var flags : Array[String]

#the next audio stream player
#we need to use node path so the resource is referencing the tree, NOT loading a new node
@export 
var next : Array[NodePath] 



enum TransitionType {
	IMEDIATE,
	XFADE,
	FADE
}

@export 
var type : TransitionType

#returns true if the two arrays have an intersection
func check_flags(sound_tree : SoundTree)->bool:

	#no flags means no limits :D
	if len(self.flags) == 0: return true

	for flag in self.flags:
		if flag in sound_tree.flags:
			
			if self.clear_transition_flags: 
				sound_tree.unset_flag(flag)

			return true
	return false

#transitions to the next song based on the type of transition
func transition_to_next(sound_tree : SoundTree,track : SoundTrack)->void:
	for nt in self.next:
		var next_track = track.get_node(nt)

		next_track.playing = true
		match type:
			TransitionType.IMEDIATE:
				#stop the current track from playing
				track.stop()
			TransitionType.FADE:
				#fade out the old track
				var tween = track.get_tree().create_tween()
				tween.tween_property(track,"volume_db",-30,0.25)
				tween.tween_callback(track.stop)

				#fade in the new track
				next_track.volume_db = -30
				var tween_next = track.get_tree().create_tween()
				tween_next.tween_property(next_track,"volume_db",next_track.initial_db,0.5)


#applies the given transition to the sound tree
#measure_break is true if we are checking at the end of a measure
func apply_transition(sound_tree : SoundTree, track : SoundTrack,measure_break : bool = false)->void:
	#only run if the caller is finished with their animation
	var test =(self.on_finish or self.on_loop) and not measure_break and not (track.play_amount == 0) 
	print(test)
	if (test): return


	if self.check_flags(sound_tree):
		print("transitioning!")
		self.transition_to_next(sound_tree,track)
		return 
	



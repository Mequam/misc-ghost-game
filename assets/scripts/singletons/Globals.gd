extends Node

#this class is a singleton that is used to store global variables
#I will be happy if this stays small :)

#the name of the game save file, stored globaly in a location that the game can
#reference
var game_name : String = "game1"

#global time variables used by shaders
var rendering_start_time = -1
var first_frame = true

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.connect("frame_pre_draw",frame_draw_pre)



#called right before the first frame of the rendering server
#used to offset in time between game run time and shader TIME
func frame_draw_pre():
	var frame_time_us = Time.get_ticks_usec()
	var frame_time_s = frame_time_us / 1.0e+6
	# print(frame_time_s)
	if first_frame:
		rendering_start_time = frame_time_s
		first_frame = false

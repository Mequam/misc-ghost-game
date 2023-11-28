extends Resource

#this class is the one stop shop location where we can set the name 
#mapping for different inputs to be displayed out to the user in a 
#form that looks acceptable as apposed to the long noodle names that
#the engine comes with (im looking at you joystick inputs :p)

#additionally, if you need to change the name of a given input (perhaps
#for different platforms) this is the place where you should do it

class_name InputNamer

#map containing translations from input map names into names the user
#can see
@export var name_map : Dictionary

extends LinearDialogContainer

#this is a simple class that connects the nodes underneith
#it with lines to imitate a comic like apearence
#appearence

class_name ComicBubbleContainer

@export var line_color : Color = Color.BLACK
@export var line_ordering : int = -1

#we use this node to indicate where the speaker is
#to draw a line to the speaker if set
@export var entry_positition : Control = null

func add_line(from ,too )->void:
		var l = Line2D.new()
		l.add_point(too.size/(2*get_parent().scale))
		l.add_point((from.global_position - too.global_position + from.size/2)/get_parent().scale)
		l.modulate = line_color
		l.z_index = line_ordering
		too.add_child(l)
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(self.get_child_count()-1):
		add_line(get_child(i),get_child(i+1))
	
	if entry_positition:
		print_debug(entry_positition.global_position)
		print_debug(entry_positition.size)
		add_line(entry_positition,get_child(0))
	
	super._ready()


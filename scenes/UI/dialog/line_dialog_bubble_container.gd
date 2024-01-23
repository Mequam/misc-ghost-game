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

#if set to true the node tries to account for the global scale of
#node 2D elements that are connected to it
@export var correct_scale : bool = true

#attempts to get a node2d ancestor if one exists
func get_node2d_parent()->Node2D:
	var p = get_parent()
	for i in range(100):
		if p is Node2D:
			return p
		p = p.get_parent()
	return null

func add_line(from ,too )->void:
		var l = Line2D.new()
		l.add_point(too.size/(2))
		
		#attempt and get a correction scale from the highest node2D
		var correction_scale : Vector2 = Vector2(1,1)
		if correct_scale:
			var n = get_node2d_parent()
			correction_scale = n.global_scale

		l.add_point((from.global_position - too.global_position)/correction_scale+from.size/2)
		l.modulate = line_color
		l.z_index = line_ordering
		too.add_child(l)
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(self.get_child_count()-1):
		add_line(get_child(i),get_child(i+1))
	
	if entry_positition:
		add_line(entry_positition,get_child(0))
	
	super._ready()


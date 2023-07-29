@tool
extends Node2D
@export var parabala_segments : int = 4

func draw_line_at_parent(p1 : Vector2, p2 : Vector2, color : Color):
	draw_line(to_local(get_parent().to_global(p1)),to_local(get_parent().to_global(p2)),color)

#returns the y value of a parabala where WE are the vertex
#that starts with the left leg checked the parent and x is distance
#from the parent
func jump_parabala_path(x)->float:
	return (-position[1]/(position[0]*position[0]))*((x-position[0])*(x-position[0]))+position[1]
	#return (-posy/(posx*posx)) * ((x - posx)*(x - posx)+posy)

func draw_parabala_from_parent()->void:
	var xfinal = 2*position[0] #the final position of the parabala
	var last_point : float = 0
	for i in range(0,parabala_segments):
		#half our required computation by caching each point as apposed to recomputing
		var current_point = float(i)*xfinal/float(parabala_segments)
		draw_line_at_parent(Vector2(last_point,jump_parabala_path(last_point)),Vector2(current_point,jump_parabala_path(current_point)),Color.RED)
		last_point = current_point

func _draw():
	draw_parabala_from_parent()
	
func _process(delta):
	update()

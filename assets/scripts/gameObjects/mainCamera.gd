extends Camera2D

#simple script that gets the Camera2D to
#follow a given target

@export 
var target : Node2D = null

@export 
var player_camera_weight : float = 2.0

#array of wieghted values
#where each element is in the form (w,v)
@export 
var target_array = []

func get_weighted_sum(w_array):
	var total  : Vector2 = Vector2.ZERO
	var amount : float = 0

	for data in w_array:
		var w = data[0]
		var v = data[1]
		total += w*v
		amount += w

	return total / amount

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	var test = [1,2,3]
	var test2 = [4,5,6]
	var out = test + test2
	out[0] = 100

	if target:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create( 
			self.target.global_position-Vector2.DOWN*100,
			self.target.global_position+Vector2(0,500)
			)
		query.collision_mask = ColMath.Layer.TERRAIN | ColMath.ConstLayer.TILE_BORDER
		query.exclude = [self]
		var result = space_state.intersect_ray(query)

		var target_points = self.target_array + [[self.player_camera_weight,self.target.global_position]]

		
		if result:
			print(result["position"])
			target_points = target_points + [[5,result["position"]]]
			print(target_points)

		
		var new_target = get_weighted_sum(target_points)-Vector2.DOWN*200

		global_position = global_position.lerp(new_target,_delta*5)

extends Node2D

class_name ShotgunBlast

var collision_mask : int = 0
@export var spread_angle : float = 45  #the spread from the direction that we are given
@export var projectile_count : int  = 5 #the number of projectiles
@export var noise : float = 0 #how perfectly we divide the range
@export var projectile_scene : PackedScene #the projectile that we spawn in, must be node2d w/ velocity


#the direction that our offspring shoot in
@export var velocity : Vector2 = Vector2(0,1)


func _ready()->void:

	#make sure we are inside of the game BEFORE we spam it
	#with our global position
	await get_tree().process_frame 

	print_debug("FIRE AWAY CAPTAIN")
	#print(self.velocity)
	var rotation_step = spread_angle / projectile_count 
	var start_vector = velocity.rotated(-spread_angle / 2)
	

	#make sure that we are inside the tree when we call these	
	for i in range(self.projectile_count):
		var to_shoot = self.projectile_scene.instantiate()
		to_shoot.velocity = start_vector 

		get_parent().add_child(to_shoot)
	
		to_shoot.collision_mask = self.collision_mask
		
		to_shoot.global_position = self.global_position
		start_vector = start_vector.rotated(rotation_step + (randf()-0.5)*self.noise*2)
	self.queue_free()

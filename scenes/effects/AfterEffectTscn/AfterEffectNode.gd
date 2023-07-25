extends Node2D

class_name GhostAfterEffectNode

@export var the_sprite : Node :
	set (val):
		the_sprite = val 
	get:
		return the_sprite
@export var after_image_frequency = 4.0
@export var after_image_mesh_scene : PackedScene
@export_range(1,100,1) var after_image_count = 4:
	set(n_count):
		after_image_count = n_count
		set_the_after_image_count(after_image_count)

@export var after_image_slight_delay = 0.0
func set_the_after_image_count(n_count):
	for child in get_children():
		child.queue_free()
	mesh_array.clear()
	if n_count <= 0:
		return
	mesh_update_index = 0
	for i in range(n_count):
		var new_node = after_image_mesh_scene.instantiate()
		add_child(new_node)
		mesh_array.append(new_node)
@export var after_scale : Vector2 = Vector2(1,1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
var time = 0.0
var mesh_update_index = 0
var mesh_array : Array
# Called when the node enters the scene tree for the first time.
func _ready():
	self.after_image_count = after_image_count
	# var the_mesh_array = get_children().filter(func(node): return node is MeshInstance2D)
	# print(the_mesh_array)
	# print(the_mesh_array.get_typed_class_name())
	# mesh_array = the_mesh_array
	pass # Replace with function body.




func _process(delta):
	time += delta
	if time >= 1.0/after_image_frequency:
		update_after_image()
		time=0.0
	# time = mod(delta+time,1.0/after_image_frequency)
	pass

#gets a texture from the target
func get_texture()->Texture2D:
	if the_sprite == null:
		return 
	
	if the_sprite is AnimatedSprite2D:
		return the_sprite.sprite_frames.get_frame_texture(the_sprite.animation,the_sprite.frame)
	elif the_sprite is TextureButton:
		return the_sprite.texture_normal 
	elif the_sprite is BtnHandDrawn:
		return the_sprite.texture_rect.texture
	return null
func update_after_image():
	var the_texture : Texture2D = get_texture()
	if the_texture != null:
		var the_size = the_texture.get_size()
		var the_mesh_instance = mesh_array[mesh_update_index]
		var the_mesh = the_mesh_instance.mesh
		
		the_mesh.size = the_size
		the_mesh.size.y *= -1
		
		var the_global_transform = Transform2D()
		if the_sprite is Node2D:
			the_global_transform = the_sprite.global_transform 
			the_mesh_instance.global_transform = the_global_transform 
		elif the_sprite is BtnHandDrawn:
			the_global_transform = the_sprite.get_global_transform ()
			the_mesh_instance.global_transform = the_global_transform 
			the_mesh_instance.scale = the_sprite.size/the_texture.get_size()
			the_mesh_instance.scale.y*=1.5
			the_mesh_instance.global_position = the_sprite.global_position+the_sprite.size/2
		else:
			the_mesh_instance.global_position = the_sprite.global_position+the_sprite.size/2

		mesh_update_index = (1+mesh_update_index)%len(mesh_array)

		the_mesh_instance.material.set_shader_parameter("Start_Time", Time.get_ticks_usec()/1e+6)
		the_mesh_instance.texture = the_texture
		the_mesh.size *= after_scale
		if the_sprite is AnimatedSprite2D and the_sprite.flip_h:
			the_mesh_instance.scale.x *= -1

		var the_lifetime = after_image_count * 1.0/after_image_frequency
		the_mesh_instance.material.set_shader_parameter("Lifetime", the_lifetime)
		the_mesh_instance.material.set_shader_parameter("SlightDelay", Globals.rendering_start_time)

	#uncomment for debugging pauses ;)
	#func _input(event):
	#	if event is InputEventKey:
	#		if event.keycode == KEY_SPACE:
	#			get_tree().paused = !get_tree().paused

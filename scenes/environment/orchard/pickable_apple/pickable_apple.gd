extends Area2D

class_name PickableApple

@export var particles : Node2D 
@export var forever_particles : Node2D
@export var sprite : Node2D 

func is_harvestable()->bool:
	return sprite.visible
func pick()->int:
	$leaf_crunchies.play()
	if sprite.visible:
		sprite.visible = false 
		for node in particles.get_children():
			if node is GPUParticles2D:
				node.emitting = true 
		return 1
	
	for node in forever_particles.get_children():
		if node is GPUParticles2D:
			node.emitting = true 
	
	return 0
func unpick()->void:
	sprite.visible = true
	for node in particles.get_children():
		if node is GPUParticles2D:
			node.emitting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("pickable_apples")

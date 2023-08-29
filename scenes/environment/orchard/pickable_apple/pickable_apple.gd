extends Area2D

class_name PickableApple

@export var particles : Node2D 
@export var forever_particles : Node2D
@export var sprite : Node2D 

func pick()->int:
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
	pass # Replace with function body.

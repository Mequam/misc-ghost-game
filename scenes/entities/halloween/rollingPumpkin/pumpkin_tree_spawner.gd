extends Node2D 

class_name PumkinSpawner

#if this is set we add this to the scene INSTEAD of the 
#actual pumpkin
var pumpkin_reference : RotatingPumpkin = null

func on_animation_finished()->void:
	$AnimatedSprite2D.play("die")
	var inst = pumpkin_reference
	if not inst:
		#load in a new pumpkin scene
		var pumpkin_scene = load("res://scenes/entities/halloween/rollingPumpkin/rolling_pumpkin_entity.tscn") 
		inst = pumpkin_scene.instantiate()
	get_parent().add_child(inst)
	inst.on_tree_entered()
	
	inst.scale = self.scale
	inst.global_position = self.global_position
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation_finished.connect(self.on_animation_finished)
	$AnimatedSprite2D.play("spawn")

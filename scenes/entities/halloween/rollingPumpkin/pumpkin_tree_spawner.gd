extends Node2D

var pumpkin_scene = preload("res://scenes/entities/halloween/rollingPumpkin/rolling_pumpkin_entity.tscn")

func on_animation_finished()->void:
	$AnimatedSprite2D.play("die")
	var inst = pumpkin_scene.instantiate()
	get_parent().add_child(inst)
	inst.global_position = self.global_position
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation_finished.connect(self.on_animation_finished)
	$AnimatedSprite2D.play("spawn")

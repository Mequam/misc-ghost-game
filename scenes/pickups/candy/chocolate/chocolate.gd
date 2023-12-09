extends Area2D

class_name Candy

@export var heal_amount : int = 2
@export var animation_player : AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("default")	
	self.body_entered.connect(on_body_entered)

func on_body_entered(bod)->void:
	if bod is Leni:
		bod.health += self.heal_amount 
		$LiveRemover.mark_removal()
		queue_free()

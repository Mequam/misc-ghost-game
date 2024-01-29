extends Area2D

#simple animation glue script

func _ready():
	self.body_entered.connect(self.on_body_entered)

func on_body_entered(body)->void:
	get_parent().get_node("AnimationPlayer").play("rustle")

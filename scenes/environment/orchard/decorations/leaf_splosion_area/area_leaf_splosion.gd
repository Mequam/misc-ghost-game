extends Area2D

#simple animation script that rustles leafs when the player passes through
#make sure to set the collision mask on the area 2d to ensure it works properly

func _ready() -> void:
	body_entered.connect(on_body_entered)
	get_node("Timer").timeout.connect(on_timeout)

func on_timeout():
	get_node("leaf particles").emitting = false
func on_body_entered(_body):
	print_debug("we are entereing the body!")
	get_node("leaf particles").emitting = true
	get_node("Timer").start()

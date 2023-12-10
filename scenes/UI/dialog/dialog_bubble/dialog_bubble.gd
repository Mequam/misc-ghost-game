extends Control

@export var animation_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_next_bubble()->Node:
	return get_child(2)

func display_bubble()->void:
	animation_player.play("apear")
	visible = true

#show the next bubble in the chain, can be
#called from ANY bubble in the chain and still
#allow the next to show
func next()->void:
	if not visible:
		#show the bubble
		display_bubble()
	elif get_next_bubble():
		get_next_bubble().next()



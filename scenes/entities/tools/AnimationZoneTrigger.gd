extends Area2D

#this is a very simple node that is inteanded to be placed under
#an entity, the node causes the entity to play the given animation
#when the player steps into the animation zone
#and optionally another animation when the player leaves the zone


class_name AnimationZoneTrigger


@export var play_on_enter : String
@export var do_play_enter : bool = true
@export var play_on_exit : String = "idle"
@export var do_play_exit : bool = true

#if set the animation that the entity will default to playing
@export var ready_animation : String = ""




# Called when the node enters the scene tree for the first time.
func _ready():
	#we ONLY operate if our parent is an entity
	if not get_parent() is Entity: self.queue_free()

	self.body_entered.connect(self.on_entity_entered)
	self.body_exited.connect(self.on_entity_exited)
	if ready_animation != "": get_parent().get_sprite2D().play(self.ready_animation)

func on_entity_entered(_body : Node2D):
	if do_play_enter:
		get_parent().get_sprite2D().custom_play(self.play_on_enter)

func on_entity_exited(_body : Node2D):
	if do_play_exit:
		get_parent().get_sprite2D().custom_play(self.play_on_exit)



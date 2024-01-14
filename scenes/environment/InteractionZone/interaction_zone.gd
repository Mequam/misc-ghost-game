extends Area2D

class_name InteractionZone

var interacter : Entity = null

signal interacted_with

@export var information_label : Label

@export var interaction_action = "INTERACT"

#this controls what kinds of entities can interact with us,
#we only accept a certain kind of entity if this is set
@export var entity_filter : String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(on_body_entered)
	self.body_exited.connect(on_body_exited)

	$Bobber.animation_finished.connect(self.on_anim_finished)
	#make sure the text bobs up and down
	var actions = InputMap.action_get_events(interaction_action)
	if len(actions) > 0:
		information_label.text = actions[0].as_text()


func on_body_entered(body)->void:
	if not self.filter(body): return

	#indicate to the player that they can interact
	$Bobber.play("reveal")
	interacter = body
func on_body_exited(body)->void:
	if not self.filter(body): return

	$Bobber.play("hide")
	interacter = null

func on_anim_finished(anim)->void:
	match anim:
		"reveal":
			$Bobber.play("bob")

func _input(event):
	if Input.is_action_just_pressed("INTERACT") and interacter != null:
		$idicator.play("indication")
		interacted_with.emit(interacter)

func filter(body : Entity)->bool:
	return self.entity_filter == "" or body.get_entity_type() == self.entity_filter

extends Control

#this class represents a menu that the player can use
#to summon unlocked entities into the game at given locations

class_name SummonMenu


#the rectangle whos texture we change to indicate to the
#player what they are going to summon
@export var summon_indicator : TextureRect

#container of each of ourt menu indicator nodes
#that the player can click to summon an entity
@export var indicator_container : Node

var summon_location : Vector2 = Vector2(0,0)
var summoned_entity : Entity = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#sets us up to summon an entity at the given location
#also pauses the game while we cover the screen
func display(summon_location : Vector2)->void:
	self.summon_location = summon_location
	
	#setup the indicators to be synced to the game data
	for node in summon_indicator.get_children():
		node.display_unlocked()
	self.visible = true
	get_tree().paused = true

func undisplay()->void:
	self.visible = false

	get_tree().paused = false
#indicate that we want to summon an entity
func indicate(menu_indicator)->void:
	summon_indicator.texture = menu_indicator.entity_texture

#summons an entity at a given location
func summon(menu_indicator)->void:
	if is_instance_valid(summoned_entity):
		summoned_entity.queue_free()
	var entity = menu_indicator.entity_to_summon.instantiate()
	get_parent().get_parent().get_level().add_child(entity)
	entity.global_position = summon_location
	summoned_entity = entity
	
	#re-hide as the player already summoned us
	self.undisplay()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("SUMMON"):
		pass
		#self.undisplay()

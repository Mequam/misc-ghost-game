extends Area2D


@export var target_level : String

var used : bool = false 
@export var disabled : bool = false 
@export var do_disable_toggle : bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(on_body_entered)
	self.body_exited.connect(on_body_exited)

func on_body_exited(_body):
	disabled = disabled and not do_disable_toggle
func on_body_entered(body):
	print("someone entered me! " + self.name + "@" + get_parent().name)
	if used or disabled or not get_parent().allow_escape: return 
	used = true 
	#start the load
	GameLoader.call_deferred("load_level",load(target_level),self,[body])
	

#lets us interact with the load AFTER the game object loads them
func update_load(loaded_lvl : Level ,persist_obj):
	loaded_lvl.player_entity = persist_obj[0]
	
	#tell the loaded object that it needs to update
	if persist_obj[0].has_method("on_load"):
		persist_obj[0].on_load(loaded_lvl)

	var sibling_door = loaded_lvl.get_node(NodePath(self.name)) 

	print( self.name + " selected sibling door: " + str(sibling_door.name))
	if sibling_door:
		sibling_door.disabled = true
		persist_obj[0].global_position = sibling_door.global_position



		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

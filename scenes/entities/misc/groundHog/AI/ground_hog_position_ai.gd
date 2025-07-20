extends EntityAI

class_name GroundHogPositionAI

# this class represents a ground hog that alternates position

@export var movement_wait_ticks : int = 0 # the time we wait before moving again
var offset_timer : int = 0

@export var movement_tick_offset : int = 0 # the time we wait before starting the system

var tick_timer : int = 0

@export var height_targets : Array[float]
var height_target_pointer : int = 0


func on_caller_unposses(_object : Entity,_leni : Entity)->void:
	self.release_all_inputs()

func _ready() -> void:
	super._ready()
	caller.sig_unpossesed_by.connect(self.on_caller_unposses)

func get_error()->float:
	return (caller as GroundHogEnemy).height - self.height_targets[self.height_target_pointer]

func is_moving()->bool:
	return caller.pressed_inputs["DOWN"] or caller.pressed_inputs["UP"]

func correct_error()->void:
	if self.get_error() > 0:
		self.perform_action("DOWN",true)
	else:
		self.perform_action("UP",true)

func tick(_player_location : Entity)->void:
	tick_timer += 1
	offset_timer += 1

	if self.is_moving() and self.caller or offset_timer < movement_tick_offset or tick_timer < movement_tick_offset:
		return

	self.release_all_inputs()
	self.correct_error()

	self.tick_timer = 0

func _process(_delta: float) -> void:
	if abs(self.get_error()) < 0.01:
		self.release_all_inputs()

		height_target_pointer = (height_target_pointer + 1) % len(height_targets) # move to the next target



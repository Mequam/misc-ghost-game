extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	custom_play("posses_end")

var ectoSplosion : PackedScene = load("res://scenes/animations/EctoSplosion.tscn")
var ghost_run_counter : int = 0

#how high up and down we go when running
var turbulance : float = 5

#up is a boolean that determines if the sprite is 
#elevated by turbulance from start position
var up : bool = false :
	get:
		return up # TODOConverter40 Copy here content of get_up
	set(mod_value):
		up = mod_value  # TODOConverter40 Copy here content of set_up

func custom_play(anim : StringName = "",backwords : bool = false)->void:
	print("playing " + anim)
	position = Vector2(0,0)
	match anim:
		"posses_col":
			speed_scale = 3
		"posses_launch":
			speed_scale = 5
		"posses_end":
			position = Vector2(55,0) if flip_h	else Vector2(-55,0) 
			speed_scale = 2.5
		_:
			speed_scale = 1.5
	play(anim,1,backwords)

func set_up(val : bool)->void:
	if val:
		position = Vector2(0,turbulance)
	else:
		position = Vector2(0,0)
	up = val
func get_up()->bool:
	return up

#emits ectosplosion particles
func emit_ectosplosion():
	var to_spawn = ectoSplosion.instantiate()
	if not flip_h:
		to_spawn.scale.x *= -1
	to_spawn.global_position = global_position
	get_parent().get_parent().add_child(
		to_spawn
		)




func _on_animation_looped():
	pass

func _on_frame_changed():
	if animation == "run" and ghost_run_counter == 2:
		self.up = !up
		ghost_run_counter = -1
	ghost_run_counter += 1

func _on_animation_finished():
	print("hello from sprite2d animation finished")
	match animation:
		"posses_col":
			emit_ectosplosion()
		"posses_launch":
			custom_play("posses")
		"posses_end":
			custom_play("idle")

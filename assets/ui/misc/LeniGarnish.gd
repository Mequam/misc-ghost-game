extends AnimatedSprite2D

@export 
var after_effect_node : GhostAfterEffectNode 

@export 
var noise_strength :float= 10

#we aim for this when moving
var target : Control :
	set (val):
		if val != target:
			target = val 
			velocity = Vector2(12*cos(randf()*2*PI),sin(randf()*2*PI))*noise_strength 
			play("run")
			seek = true 
			visible = true
			after_effect_node.the_sprite = null
	get:
		return target 
var seek : bool = false 
@export 
var starting_speed : float = 100
var speed : float = 100
var chaos_speed : float= 206
var velocity : Vector2 = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_finished.connect(on_anim_finished)
	play("run")
func on_anim_finished():
	match animation:
		"posses":
			visible = false 
			after_effect_node.the_sprite = target
			#ensure that the possesion effect indicates focus
			target.grab_focus()

#gets the position that we are aiming for
func get_target_position()->Vector2:
	return target.position+target.size/2

#returns true if we hit the target
func hit_target()->bool:
	var new_chord : Vector2 = (position - target.position)
	return (new_chord.x > 0) and (new_chord.y > 0) and (new_chord.x < target.size.x) and (new_chord.y < target.size.y)
# Called every frame. 'delta' is the elapsed time since the previous sframe.
func _process(delta):
	if (seek and visible and not hit_target()):
		velocity += (get_target_position()-position).normalized()*speed 
		rotation = velocity.angle()
		position += velocity*delta 
		speed+=delta*chaos_speed
	elif seek and visible:
		play("posses")
		speed = starting_speed
		seek = false
		
	
	

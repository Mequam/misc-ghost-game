extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#used to keep track of the number of times
#that we finished the idle animation
var idle_count : int = 0
func play(anim : String="idle",val : bool=false)->void:
	print("playing " + anim)
	match anim:
		"idle":
			idle_count = 0
			speed_scale = 2
		"idle_long":
			speed_scale = 1.5
		_:
			speed_scale = 2
	.play(anim,val)

func _on_witchSprite_animation_finished():
	match animation:
		"fall_start":
			play("fall")
		"idle_long":
			play("idle")
		"idle":
			idle_count += 1
			if idle_count >= 10:
				play("idle_long")
		"jump":
			play("up")

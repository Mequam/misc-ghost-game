extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var idle_count : int = 0
func custom_play(anim : StringName = "idle",val : bool=false)->void:
	match anim:
		"idle":
			idle_count = 0
			speed_scale = 2
		"idle_long":
			speed_scale = 1.5
		_:
			speed_scale = 2
	print(anim + " " + str(speed_scale))
	super.play(anim,val)

func _on_witchSprite_animation_finished():
	print("the finished animation is " + animation)
	match animation:
		"fall_start":
			custom_play("fall")
		"idle_long":
			custom_play("idle")
		"idle":
			idle_count += 1
			if idle_count >= 10:
				custom_play("idle_long")
		"jump":
			custom_play("up")

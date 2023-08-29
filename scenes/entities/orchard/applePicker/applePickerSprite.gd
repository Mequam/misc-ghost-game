extends AnimatedSprite2D

@export var anim_tree : AnimationTree

func custom_play(anim : StringName = "",backwords : bool = false)->void:
	match anim:
		"up":
			anim = "fly_up"
		"run":
			anim = "walk" 
		"zoom":
			anim = "run"
		"down":
			anim = "fall"
	reset_animation()
	anim_tree.set("parameters/conditions/" + anim,true)

func on_anim_started(anim : StringName)->void:
	pass
	#print("reseting the animations!")
	#if self.animation != "shoot_prep" and self.animation != "walk": reset_animation()
func _ready()->void:
	anim_tree.animation_started.connect(self.on_anim_started)
func reset_animation()->void:
	anim_tree.set("parameters/conditions/fly_up",false)
	anim_tree.set("parameters/conditions/walk",false)
	anim_tree.set("parameters/conditions/idle",false)
	anim_tree.set("parameters/conditions/shoot",false)
	anim_tree.set("parameters/conditions/fall",false)
	anim_tree.set("parameters/conditions/pick",false)
	anim_tree.set("parameters/conditions/run",false)


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

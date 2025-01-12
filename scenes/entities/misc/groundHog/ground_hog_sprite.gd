extends AnimatedSprite2D

@export var animation_player : AnimationPlayer

#used to determine when we want to do a bubble eye animation
var default_animation_amount : int = 0
@export var maximum_bubble_eyes : int = 5

func custom_play(anim)->void:
	self.animation_player.play(anim)

func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(self.on_animation_player_finished)
	self.custom_play("idle")


func on_animation_player_finished(anim)->void:
	match anim:
		"idle":
			default_animation_amount += 1
			if default_animation_amount >= self.maximum_bubble_eyes:
				self.custom_play("eye_replace")
				self.default_animation_amount = 0
			else:
				self.custom_play("idle")
		"eye_replace":
			self.custom_play("idle")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#we need to do this in order to have our scale dynamically change properly
	#without it the bubble animation gets all wonky as we ground hog up and down
	#the constants were just fuzzed out to what looked good
	self.material.set_shader_parameter("scale",self.global_scale.y/5)
	
	if get_parent().pressed_inputs["UP"]:
		self.custom_play("up")
	elif get_parent().pressed_inputs["DOWN"]:
		self.custom_play("down")
	elif not $AnimationPlayer.is_playing():
		self.custom_play("idle")

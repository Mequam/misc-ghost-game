extends AnimatedSprite2D


@export var animation_player : AnimationPlayer
@export var rotation_bone : Node2D

@export var eye_rotation_sensativity : float 
@export var ouch_threshold : float #when we collide harder than this, indicate ouch

var rotation_speed : float :
	set (val):
		speed_scale = rotation_speed*eye_rotation_sensativity/2
		rotation_speed = val 
		if abs(rotation_speed)  < 0.1:
			self.rolling = false 
		elif not self.rolling and abs(rotation_speed) > 0.1:
			self.custom_play("roll")
	get:
		return rotation_speed
var rolling : bool = false 



func custom_play(animation : StringName  = "idle",backwards : bool = false)->void:
	match animation:
		"expload":
			stop()
			animation_player.play("expload")
		"roll":
			if not rolling:
				stop()
				animation_player.play("roll_prep")
			self.rolling = true 
		"roll_prep_recover":
			self.stop()
			animation_player.play(animation)
		"ouch":
			stop()
			animation_player.play("ouch")
		_:
			if self.rolling:
				animation_player.play("RESET") #reset everything
				animation_player.stop()
				self.play("eye_roll")
			else:
				stop()
				animation_player.play(animation)
func _ready()->void:
	animation_player.animation_finished.connect(self.anim_finished)

func anim_finished(anim : StringName)->void:
	animation_finished.emit(anim) #make sure that the rolling pumkin is aware of the signal
	#print("animation finished on sprite2D " + anim )
	match anim:
		"roll_prep":
			animation_finished.emit("roll_prep")
			custom_play("roll_prep_recover")
		"roll_prep_recover":
			#not really used but just in case we want to use them the strings match the animation that plays
			custom_play("eye_roll") 
		"ouch":
			custom_play("eye_roll")
func _process(delta)->void:
	rotation_bone.rotate(delta*rotation_speed)

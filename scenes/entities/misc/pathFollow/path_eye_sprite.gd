extends AnimatedSprite2D

# sprite logic for the path follow entity eye
# path follow is agnostic to the art attached to it
# (as other entities SHOULD be honestly) so we move the logic
# here

@export var flip_slope : float = 2
var last_position : Vector2 = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.last_position = get_parent().global_position
	orientate_sprite(Vector2(1,0))

func custom_play(anim : String)->void:
	self.play(anim)

#aligns the sprite to the current direction of motion
func orientate_sprite(velocity : Vector2)->void:
	var orientation : Vector2 = (get_child(0).global_position - self.global_position)

	#make sure that we are allways pointing up
	self.flip_v = orientation.y > 0

	if velocity.length() > 0.02: #make sure we are moving
		if abs(velocity.y) > abs(velocity.x*flip_slope): #are we going up-ish?
			if velocity.y > 0:
				self.custom_play("up")
				self.global_rotation = 0
			elif velocity.y < 0:
				self.custom_play("down")
		else: #we are going left to right
			#look where were going
			self.global_rotation = velocity.angle()
			self.custom_play("left_right")
	elif self.animation == "up" or self.animation == "down":
		self.custom_play("left_right")

		self.flip_h = (velocity.x < 0) != (orientation.y > 0)


	self.last_position = get_parent().global_position

func _process(delta: float) -> void:
	var velocity : Vector2 = (last_position - get_parent().global_position)*delta

	orientate_sprite(velocity)


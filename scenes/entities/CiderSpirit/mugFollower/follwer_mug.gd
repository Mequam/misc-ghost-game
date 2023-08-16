extends RigidBody2D

class_name FollowerMug 

@export var attaction : float = 500
@export var initial_speed : float = 100

var ciderSpirit : CiderSpirit


func unhide_self(tail : String)->void:
	visible = true
	$AnimatedSprite2D.play("after_launch" + tail)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.constant_force = Vector2(0,-1000)
	self.constant_force = (ciderSpirit.position - self.position).normalized()*attaction 

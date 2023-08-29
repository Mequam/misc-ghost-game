extends Projectile

class_name SingleAppleProjectile 

@export var apple_gravity : Vector2 

#we fall downwards as a single apple
func main_process(delta : float)->void:
	self.velocity += self.apple_gravity * delta
	super.main_process(delta)

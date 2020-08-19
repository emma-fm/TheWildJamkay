extends Node2D


var is_held = false
var flying = false
var direction
var speed = Vector2()
var velocity = Vector2()
var floor_y

const gravity = 80
const deceleration = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if flying:
		speed.x -= deceleration * delta
		speed.x = max(0, speed.x)
		velocity.x = speed.x * delta * direction.x
		
		speed.y += gravity * delta
		velocity.y = speed.y * delta
		
		position.x += velocity.x
		position.y = min(floor_y, position.y + velocity.y)
		print(floor(position.y))
		print(floor(floor_y))
		if floor(position.y) == floor(floor_y):
			flying = false

func fly(direction):
	flying = true
	self.direction = direction
	speed.y = -40
	speed.x = 150
	floor_y = position.y + 10
	pass

func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		body.cangrab(self)
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		body.dontgrab(self)
	pass # Replace with function body.

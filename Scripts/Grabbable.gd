extends Node2D

export(String) var type
var is_held = false
var flying = false
var direction
var speed = Vector2()
var velocity = Vector2()
var floor_y
var been_picked = false
var at_floor = false
var spawn_position

signal picked

const gravity = 90
const deceleration = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("spawn")
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
		if floor(position.y) == floor(floor_y):
			flying = false

func fly(direction):
	flying = true
	self.direction = direction
	speed.y = -30
	speed.x = 180
	floor_y = position.y + 10
	pass

func picked():
	if not been_picked:
		emit_signal("picked",self)
		been_picked = true
	at_floor = false
	is_held = true
	
func dropped():
	at_floor = true
	$DespawnTimer.start()
		
func setup(manager,pos):
	spawn_position = pos
	connect("picked", manager, "on_picked")

func _on_Area2D_body_entered(body):
	if body is StaticBody2D:
		return
	if body.has_method("cangrab"):
		body.cangrab(self)
	elif not body.served:
		body.give(self)
	pass


func _on_Area2D_body_exited(body):
	if body is StaticBody2D:
		return
	elif body.has_method("dontgrab"):
		body.dontgrab(self)
	pass # Replace with function body.


func _on_DespawnTimer_timeout():
	if not been_picked or at_floor:
		$AnimationPlayer.play("banish")
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "banish":
		if not at_floor:
			emit_signal("picked",self)
		queue_free()
	pass # Replace with function body.

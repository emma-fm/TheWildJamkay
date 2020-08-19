extends KinematicBody2D

var velocity
var speed = 100
var player = "p1"
var grabrange = []
var item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity != Vector2():
		if item:
			$AnimatedSprite.play("walk_hold")
		else:
			$AnimatedSprite.play("walk")
		if velocity.x != 0:	
			$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 0
	pass

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	pass
	
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed(player + "_up"):
		velocity.y -= 1
	if Input.is_action_pressed(player + "_down"):
		velocity.y += 1
	if Input.is_action_pressed(player + "_left"):
		velocity.x -= 1
	if Input.is_action_pressed(player + "_right"):
		velocity.x += 1
	velocity = velocity.normalized() * speed
	if Input.is_action_just_pressed(player + "_grab"):
		if item:
			throw()
		else:
			grab()
	pass

func cangrab(item):
	grabrange.append(item)
	pass

func dontgrab(item):
	grabrange.erase(item)
	pass

func grab():
	if grabrange.size() > 0:
		if grabrange.size() == 1 and not grabrange[0].is_held:
			hold(grabrange[0])
		else:
			grabrange.sort_custom(Sorter, "mysort")
			if not grabrange[0].is_held:
				hold(grabrange[0])
			pass
	pass
	
func hold(i):
	item = i
	item.is_held = true
	get_parent().remove_child(item)
	add_child(item)
	item.position.x = 0
	item.position.y = -10
	pass

func throw():
	remove_child(item)
	get_parent().add_child(item)
	item.position = position + Vector2(0, -10)
	item.is_held = false
	grabrange.erase(item)
	if $AnimatedSprite.flip_h == false:
		item.fly(Vector2(1, 0))
	else:
		item.fly(Vector2(-1, 0))
	item = null
	$AnimatedSprite.play("walk")
	pass

class Sorter:
	static func mysort(a, b):
		if a.is_held and not b.is_held:
			return true
		elif b.is_held and not a.is_held:
			return false
		else:
			return true

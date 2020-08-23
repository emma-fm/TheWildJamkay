extends KinematicBody2D

export var evil = false
export var speed = 30
var need_type
var served = false

signal good_item
signal bad_item

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	move_and_slide(Vector2(0, speed))


func setup(manager,type,x,y,speed):
	need_type = type
	self.speed = speed
	$SpriteBubble/Sprite.region_rect = Rect2(x, y, 16, 16)
	connect("bad_item", manager, "on_bad_item")
	connect("good_item", manager, "on_good_item")
	pass
	
func give(item):
	$SpriteBubble.hide()
	item.queue_free()
	served = true
	if item.type == need_type and not evil:
		$Good.play()
		emit_signal("good_item")
	else:
		if evil:
			$Evil.play()
		else:
			$Bad.play()
		emit_signal("bad_item")

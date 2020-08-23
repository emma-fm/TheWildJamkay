extends Node

var faces = [
	preload("res://Graphics/Face1.png"),
	preload("res://Graphics/Face2.png"),
	preload("res://Graphics/Face3.png"),
	preload("res://Graphics/Face4.png")
]
var clients = [
	preload("res://Scenes/Clients/Astronaut.tscn"),
	preload("res://Scenes/Clients/Alien.tscn"),
	preload("res://Scenes/Clients/Crocodile.tscn"),
	preload("res://Scenes/Clients/Gnome.tscn"),
	preload("res://Scenes/Clients/Rat.tscn"),
	preload("res://Scenes/Clients/Spacesuit.tscn")
]
var items_scenes = [
	preload("res://Scenes/Items/Meat.tscn"),
	preload("res://Scenes/Items/Cheese.tscn"),
	preload("res://Scenes/Items/Apple.tscn"),
	preload("res://Scenes/Items/Carrot.tscn")
]
var players = [
	preload("res://Scenes/PlayerOne.tscn"),
	preload("res://Scenes/PlayerTwo.tscn")
]
var morale = 8
var morale_recover = 0
var items = {
	"meat": Vector2(528,256),
	"cheese": Vector2(544,256),
	"apple": Vector2(528,288),
	"carrot": Vector2(544,320)
}
var spawn_queue = []
var spawner_left
var spawner_right
var table = [false, false, false]
var speed
var freq
var incspeed = false
var score = 0
var player_spawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	spawner_left = get_parent().get_node("SpawnerLeft")
	spawner_right = get_parent().get_node("SpawnerRight")
	randomize()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not player_spawned:
		spawn_players()
		player_spawned = true
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = true
		get_parent().get_node("Taint").show()
		get_parent().get_node("CanvasLayer/Popup").show()
	if spawn_queue.size() > 0:
		if table[0] == false:
			table[0] = true
			_spawn_item("left")
		elif table[1] == false:
			table[1] = true
			_spawn_item("center")
		elif table[2] == false:
			table[2] = true
			_spawn_item("right")
	pass
	
func _spawn_item(pos):
	var new
	match spawn_queue[0]:
		"meat":
			new = items_scenes[0].instance()
		"cheese":
			new = items_scenes[1].instance()
		"apple":
			new = items_scenes[2].instance()
		"carrot":
			new = items_scenes[3].instance()
	get_parent().add_child(new)
	match pos:
		"left":
			new.position = get_parent().get_node("ItemSpawnLeft").position
		"center":
			new.position = get_parent().get_node("ItemSpawnCenter").position
		"right":
			new.position = get_parent().get_node("ItemSpawnRight").position
	new.setup(self,pos)
	spawn_queue.remove(0)

func on_good_item():
	if morale < 5:
		morale_recover += 1
		if morale_recover == 5:
			morale += 1
			morale_recover = 0
			change_face()
	score += 1
	get_parent().get_node("CanvasLayer/HBoxContainer/Score").text = "%03d" % score
	pass
	
func on_bad_item():
	get_parent().get_node("CanvasLayer/TextureRect/AnimationPlayer").play("shake")
	morale -= 1
	change_face()
	if morale == 0:
		$Die.play()
	pass

func change_face():
	if morale > 6:
		get_parent().get_node("CanvasLayer/TextureRect").texture = faces[0]
	elif morale > 4:
		get_parent().get_node("CanvasLayer/TextureRect").texture = faces[1]
	elif morale > 2:
		get_parent().get_node("CanvasLayer/TextureRect").texture = faces[2]
	else:
		get_parent().get_node("CanvasLayer/TextureRect").texture = faces[3]		
	pass

func on_picked(body):
	match body.spawn_position:
		"left":
			table[0] = false
		"center":
			table[1] = false
		"right":
			table[2] = false
	pass

func _on_Despawn_body_entered(body):
	if not body.served and not body.evil:
		$Bad.play()
		on_bad_item()
	body.queue_free()
	pass # Replace with function body.


func _on_ClientTimer_timeout():
	var new = clients[randi() % clients.size()].instance()
	get_parent().add_child(new)
	var pos = randi() % 2
	if pos == 0:
		new.position = spawner_left.position
	else:
		new.position = spawner_right.position
	var need = randi() % items.size()
	var name = items.keys()[need]
	new.setup(self, name, items[name].x, items[name].y, speed)
	spawn_queue.append(name)
	$ClientTimer.wait_time = freq
	$ClientTimer.start()
	pass # Replace with function body.

func _on_Die_finished():
	get_tree().change_scene("res://Scenes/GameOver.tscn")
	pass # Replace with function body.


func _on_ButtonResume_pressed():
	get_tree().paused = false
	get_parent().get_node("CanvasLayer/Popup").hide()
	get_parent().get_node("Taint").hide()
	pass # Replace with function body.


func _on_DifficultyTimer_timeout():
	if incspeed:
		speed += 5
		speed = min(35, speed)
	else:
		freq -= 0.5
		if get_node("/root/Singleton").mode == "single":
			freq = max(2, freq)
		else:
			freq = max(1, freq)
	incspeed = not incspeed
	pass # Replace with function body.


func spawn_players():
	match get_node("/root/Singleton").mode:
		"single":
			speed = 20
			freq = 4
			var p = players[0].instance()
			get_parent().add_child(p)
			p.position = Vector2(120, 100)
		"coop":
			speed = 25
			freq = 3
			var p1 = players[0].instance()
			get_parent().add_child(p1)
			p1.position = Vector2(100, 100)
			var p2 = players[1].instance()
			get_parent().add_child(p2)
			p2.position = Vector2(150, 100)


func _on_ButtonQuit_pressed():
	get_tree().change_scene("res://Scenes/Title.tscn")
	get_tree().paused = false
	pass # Replace with function body.

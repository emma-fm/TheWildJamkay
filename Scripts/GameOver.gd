extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node("/root/Singleton").winner_vs == "p1":
		$Label.text = "PLAYER 1 WINS"
	elif get_node("/root/Singleton").winner_vs == "p2":
		$Label.text = "PLAYER 2 WINS"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonRetry_pressed():
	get_tree().change_scene("res://Scenes/PlayArea.tscn")
	pass # Replace with function body.


func _on_ButtonMenu_pressed():
	get_node("/root/Singleton").winner_vs = null
	get_tree().change_scene("res://Scenes/Title.tscn")
	pass # Replace with function body.

extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.get_animation("titlemove").set_loop(true)
	$AnimationPlayer.play("titlemove")
	if not get_node("/root/Singleton/TitleMusic").playing:
		get_node("/root/Singleton/TitleMusic").play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonHowToPlay_pressed():
	get_tree().change_scene("res://Scenes/HowToPlay.tscn")
	pass # Replace with function body.


func _on_ButtonSingleplayer_pressed():
	get_node("/root/Singleton").mode = "single"
	get_node("/root/Singleton/TitleMusic").stop()
	get_tree().change_scene("res://Scenes/PlayArea.tscn")
	pass # Replace with function body.


func _on_ButtonCredits_pressed():
	get_tree().change_scene("res://Scenes/Credits.tscn")
	pass # Replace with function body.


func _on_ButtonCoop_pressed():
	get_node("/root/Singleton").mode = "coop"
	get_node("/root/Singleton/TitleMusic").stop()
	get_tree().change_scene("res://Scenes/PlayArea.tscn")
	pass # Replace with function body.


func _on_ButtonVersus_pressed():
	get_node("/root/Singleton").mode = "vs"
	get_node("/root/Singleton/TitleMusic").stop()
	get_tree().change_scene("res://Scenes/PlayArea.tscn")
	pass # Replace with function body.

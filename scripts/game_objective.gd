extends Area2D

var collected_keys: int = 0:
	get:
		return collected_keys
	set(value):
		collected_keys = value
		
		if collected_keys & Key.KeyType.RED:
			%RedIncomplete.visible = false
			%RedComplete.visible = true
			
		if collected_keys & Key.KeyType.GREEN:
			%GreenIncomplete.visible = false
			%GreenComplete.visible = true
			
		if collected_keys & Key.KeyType.BLUE:
			%BlueIncomplete.visible = false
			%BlueComplete.visible = true
			
		if collected_keys == (Key.KeyType.RED | Key.KeyType.BLUE):
			Stats.is_tracking_elapsed_time = false
			get_tree().change_scene_to_file("res://menus/game_over.tscn")


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(other: Node2D) -> void:
	var player = other as Player
	if player:
		collected_keys = player.collected_keys

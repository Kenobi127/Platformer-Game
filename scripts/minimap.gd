extends CanvasLayer

@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var player: Node2D 
var enemy_sprites = {}


func _ready():
	#read all the nodes in the cur level parent node
	#for node in get_tree().get_root().get_child(0).get_children(): 
	for node in get_parent().get_parent().get_children(): 
		if node.name == "Player":							#read the player node
			player = node
		
		if node.name == "TileMap":							#read the tilemap
			var tile_dup = node.duplicate()
			sub_viewport.add_child(tile_dup)
		
		if node.name == "Moving Platforms":			#read the moving platforms
			for platform in node.get_children():
				var plat_dup = platform.duplicate()
				sub_viewport.add_child(plat_dup)
		
		if node.name == "Spikes":					#read the spikes
			for spike in node.get_children():
				var spike_dup = spike.duplicate()
				sub_viewport.add_child(spike_dup)
		
		if node.name == "Enemies":					#read the enemies
			for enemy in node.get_children():
				enemy.connect("position_changed", _on_enemy_position_changed)
				enemy.connect("destroyed", _on_enemy_destroyed)

func _process(delta):
	$SubViewportContainer/SubViewport/Camera2D.position = player.position
	$SubViewportContainer/SubViewport/PlayerPos.position = player.position

func _on_enemy_position_changed(pos, enemy_instance_id):
	if enemy_instance_id not in enemy_sprites:
		# If the enemy sprite doesn't exist yet, create and add it to the minimap
		var enemy_sprite = preload("res://assets/textures/enemies/skeleton1.0/skeleton_map.tscn").instantiate()
		sub_viewport.add_child(enemy_sprite)
		enemy_sprites[enemy_instance_id] = enemy_sprite
	# Update the position of the enemy sprite
	enemy_sprites[enemy_instance_id].position = pos

func _on_enemy_destroyed(enemy_instance_id):
	if enemy_instance_id in enemy_sprites:
		# Remove the enemy sprite from the minimap
		enemy_sprites[enemy_instance_id].queue_free()
		enemy_sprites.erase(enemy_instance_id)



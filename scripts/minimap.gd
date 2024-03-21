extends CanvasLayer

@onready var camera = $SubViewportContainer/SubViewport/Camera2D
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var player: Node2D 

func _ready():
	#read all the nodes in the cur level parent node
	for node in get_tree().get_root().get_child(0).get_children(): 
		#print(node)
		#print(node.name)
		if node is Player:							#read the player node
			player = node
		
		if node is TileMap:							#read the tilemap
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position = player.position

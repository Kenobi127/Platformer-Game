extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$GemsControl/GemsLabel.text = str(SceneManager.total_gems)

extends TileMap

onready var animationPlayer := $AnimationPlayer

func goGreyscale():
	animationPlayer.play("go greyscale")
	
func returnFromGreyscale():
	animationPlayer.play("return from greyscale")
	
func disappear():
	animationPlayer.play("disappear")
	
func reappear():
	animationPlayer.play("reappear")

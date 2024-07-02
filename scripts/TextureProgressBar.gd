extends TextureProgressBar

var maxvalor:int

func _ready():
	maxvalor=100
	
func DisminuirVida(damage):
	value-=damage
	if value <=0:
		get_tree().get_nodes_in_group("player")[0].dead()

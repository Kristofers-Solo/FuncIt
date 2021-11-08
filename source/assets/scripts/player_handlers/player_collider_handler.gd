extends CollisionShape2D

onready var playerSpriteNAHeight = get_parent().get_child(2).texture.get_height() * get_parent().get_child(2).scale.y
onready var playerSpriteNAWidth = get_parent().get_child(2).texture.get_width() * get_parent().get_child(2).scale.x

func _ready():
	var expectedColliderShape = CircleShape2D.new()
	set_shape(expectedColliderShape)
	var colliderRadius = playerSpriteNAHeight / 2
	expectedColliderShape.set_radius(colliderRadius)
	pass

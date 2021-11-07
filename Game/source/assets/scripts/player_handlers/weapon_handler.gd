extends CollisionShape2D

var weaponWidth = 0
var weaponHeight = 0
var weaponOffset = Vector2(0,0)
var weaponHolderRadius = get_shape().get_radius()
var weaponPosition = Vector2(0,0)

var weaponPreviousAngle = 0
var weaponAngle = 0

func _ready():
	weaponWidth = $"Player-character-theme-gun-01".texture.get_width() * $"Player-character-theme-gun-01".scale.x
	weaponHeight = $"Player-character-theme-gun-01".texture.get_height() * $"Player-character-theme-gun-01".scale.y
	weaponOffset = Vector2(-weaponWidth, -weaponHeight / 2)
	weaponPosition += weaponOffset
	pass

func _process(delta):
	if Input.is_action_pressed("rotation_increase"):
		rotate_weapon(2)
	if Input.is_action_pressed("rotation_decrease"):
		rotate_weapon(-2)
	$"Player-character-theme-gun-01".position = weaponPosition

func rotate_weapon(degrees):
	weaponAngle += degrees
	if weaponAngle > -10 and weaponAngle < 90:
		weaponPosition -= weaponOffset.rotated(deg2rad(weaponPreviousAngle))
		weaponPosition += weaponOffset.rotated(deg2rad(weaponAngle))
		$"Player-character-theme-gun-01".rotation_degrees = weaponAngle
		weaponPreviousAngle = weaponAngle
	else:
		weaponAngle -= degrees
	

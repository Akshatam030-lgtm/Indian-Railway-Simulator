extends Node3D

var train_speed: float = 0.0
var throttle: float = 0.0
var brake: float = 0.0

const MAX_SPEED: float = 160.0
const ACCELERATION: float = 0.65
const BRAKING: float = 1.5

var train: Node3D
var camera: Camera3D

func _ready() -> void:
    train = get_node("Train")
    camera = get_node("Camera3D")

    print("INDIAN RAILWAY SIMULATOR")
    print("Main Game Initialized!")
    print("Train System Ready!")
    print("Camera System Ready!")

func _physics_process(delta: float) -> void:
    handle_controls()
    update_train(delta)
    update_camera(delta)

func handle_controls() -> void:
    throttle = 0.0
    brake = 0.0

    if Input.is_key_pressed(KEY_W):
        throttle = 1.0
    elif Input.is_key_pressed(KEY_S):
        throttle = 0.5

    if Input.is_key_pressed(KEY_SPACE):
        brake = 1.0

func update_train(delta: float) -> void:
    if brake > 0.0:
        train_speed -= BRAKING * brake * 3.6 * delta
    else:
        train_speed += ACCELERATION * throttle * 3.6 * delta

    train_speed = clampf(train_speed, 0.0, MAX_SPEED)

    var movement: float = train_speed / 3.6
    train.position.z -= movement * delta

func update_camera(delta: float) -> void:
    var target_position: Vector3 = train.global_position + Vector3(0, 6, 18)

    camera.global_position = camera.global_position.lerp(
        target_position,
        clampf(4.0 * delta, 0.0, 1.0)
    )

    camera.look_at(train.global_position + Vector3(0, 1, 0), Vector3.UP)

extends CharacterBody2D
class_name BaseCharacter

var _can_attack: bool = true
var _attack_animation_name: String = ""

@export_category("Variables") # Cria uma categoria de parâmetro para o script
@export var _motion_speed: float = 128 # Adiciona um valor padrão para os BaseCharacters

@export_category("Objects") # Cria uma categoria de parâmetro para o script
@export var _sprite2D: Sprite2D # Cria uma variável _sprite2D do tipo Sprite2D
@export var _animation: AnimationPlayer # Cria uma variável _animation do tipo AnimationPlayer
@export var _right_attack_name: String = ""
@export var _left_attack_name: String = ""

func _physics_process(_delta: float) -> void: # Função que executará o script 60 vezes por segundo, voltado exclusivamente para mexer com a física
	_move()
	_attack()
	_animate()
	
func _attack() -> void:
	if Input.is_action_just_pressed("attack_left") and _can_attack:
		_can_attack = false
		_attack_animation_name = _left_attack_name
		_motion_speed /= 2
	if Input.is_action_just_pressed("attack_right") and _can_attack:
		_can_attack = false
		_attack_animation_name = _right_attack_name
		set_physics_process(false)
	

func _move() -> void:
	var _direction: Vector2 = Input.get_vector( # Variável _direction do tipo Vector2D receberá os valores das inputs marcados no InputMap
		"move_left", "move_right", "move_up", "move_down" # Valores marcados no InputMap
	)
	velocity = _motion_speed * _direction # Velocidade final
	move_and_slide() # Normaliza e também deixa o movimento mais natural	
	

func _animate() -> void:
	if velocity.x < 0: # Ao se mover pra esquerda
		_sprite2D.flip_h = true # Virará para a esquerda
		
	if velocity.x > 0: # Ao se mover para a direita
		_sprite2D.flip_h = false # Virará para a direita
		
	if _can_attack == false:
		_animation.play(_attack_animation_name)
		return
		
	if velocity: # Se a velocidade for maior que 0
		_animation.play("run") # Animação de Correr
		return
		
	_animation.play("idle") # Animação de Idle caso negativo


func _on_animation_finished(_anim_name: StringName) -> void:
	if _anim_name == "smash":
		_can_attack = true
		set_physics_process(true)
	if _anim_name == "swing":
		_can_attack = true
		_motion_speed *= 2

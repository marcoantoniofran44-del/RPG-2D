extends Node2D


# =========================
# STATUS DO JOGADOR
# =========================

var player_hp = 100
var player_max_hp = 100


# =========================
# STATUS DO INIMIGO
# =========================

var enemy_hp = 100
var enemy_max_hp = 100


# =========================
# CONTROLE DA BATALHA
# =========================

var player_turn = true
var defending = false
var battle_finished = false


# =========================
# REFERÊNCIAS DA INTERFACE
# =========================

@onready var player_hp_bar = $CanvasLayer/Control/PlayerName/PlayerHP
@onready var enemy_hp_bar = $CanvasLayer/Control/EnemyName/EnemyHP

@onready var message = $CanvasLayer/Control/Message

@onready var attack_button = $CanvasLayer/Control/Menu/AttackButton
@onready var skills_button = $CanvasLayer/Control/Menu/SkillButton
@onready var guard_button = $CanvasLayer/Control/Menu/GuardButton
@onready var item_button = $CanvasLayer/Control/Menu/ItemButton


# =========================
# INÍCIO
# =========================

func _ready():

	update_hp()

	message.text = "O que você fará?"

	attack_button.pressed.connect(attack)
	skills_button.pressed.connect(skill)
	guard_button.pressed.connect(guard)
	item_button.pressed.connect(item)


# =========================
# ATUALIZAR HP
# =========================

func update_hp():

	player_hp_bar.value = player_hp
	enemy_hp_bar.value = enemy_hp


# =========================
# ATACAR
# =========================

func attack():

	if not player_turn:
		return

	if battle_finished:
		return

	message.text = "Você atacou o inimigo!"

	enemy_hp -= 20

	if enemy_hp < 0:
		enemy_hp = 0

	update_hp()

	if enemy_hp <= 0:

		victory()

		return

	player_turn = false

	await get_tree().create_timer(1.0).timeout

	enemy_turn()


# =========================
# HABILIDADE
# =========================

func skill():

	if not player_turn:
		return

	if battle_finished:
		return

	message.text = "Você usou uma habilidade!"

	enemy_hp -= 30

	if enemy_hp < 0:
		enemy_hp = 0

	update_hp()

	if enemy_hp <= 0:

		victory()

		return

	player_turn = false

	await get_tree().create_timer(1.0).timeout

	enemy_turn()


# =========================
# DEFENDER
# =========================

func guard():

	if not player_turn:
		return

	if battle_finished:
		return

	defending = true

	message.text = "Você se preparou para defender!"

	player_turn = false

	await get_tree().create_timer(1.0).timeout

	enemy_turn()


# =========================
# ITEM
# =========================

func item():

	if not player_turn:
		return

	if battle_finished:
		return

	player_hp += 25

	if player_hp > player_max_hp:
		player_hp = player_max_hp

	update_hp()

	message.text = "Você recuperou 25 HP!"

	player_turn = false

	await get_tree().create_timer(1.0).timeout

	enemy_turn()


# =========================
# TURNO DO INIMIGO
# =========================

func enemy_turn():

	if battle_finished:
		return

	message.text = "O inimigo está atacando..."

	await get_tree().create_timer(1.0).timeout

	var damage = 15


	if defending:

		damage = 5

		defending = false

		message.text = "Você bloqueou parte do ataque!"


	else:

		message.text = "O inimigo atacou!"


	player_hp -= damage

	if player_hp < 0:
		player_hp = 0

	update_hp()


	if player_hp <= 0:

		defeat()

		return


	await get_tree().create_timer(1.0).timeout

	message.text = "Sua vez!"

	player_turn = true


# =========================
# VITÓRIA
# =========================

func victory():

	battle_finished = true

	message.text = "VOCÊ VENCEU!"

	disable_buttons()


# =========================
# DERROTA
# =========================

func defeat():

	battle_finished = true

	message.text = "VOCÊ FOI DERROTADO..."

	disable_buttons()


# =========================
# DESATIVAR MENU
# =========================

func disable_buttons():

	attack_button.disabled = true
	skills_button.disabled = true
	guard_button.disabled = true
	item_button.disabled = true

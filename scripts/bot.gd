class_name Bot
extends Node

enum BotState {AGGRESSIVE, DEFENSIVE, NEUTRAL, RETREAT, COMBO}

var character: Character
var rival: Character

var walk_direction: int = 0
var frame_count: int = 0
var bot_state: BotState = BotState.NEUTRAL
var state_duration: int = 0
var reaction_delay: int = 0
var combo_count: int = 0
var last_rival_x: float = 0.0
var hesitation: int = 0
var personality_aggression: float = 0.5 # 0.0 = 防御的, 1.0 = 攻撃的

func _init(character: Character, rival: Character) -> void:
	self.character = character
	self.rival = rival

	frame_count = randi_range(15, 45)
	# 個性をランダムに設定
	personality_aggression = randf_range(0.3, 0.8)
	_change_state()


func _change_state() -> void:
	var roll = randf()
	if roll < personality_aggression * 0.5:
		bot_state = BotState.AGGRESSIVE
		state_duration = randi_range(60, 180)
	elif roll < personality_aggression * 0.5 + 0.2:
		bot_state = BotState.DEFENSIVE
		state_duration = randi_range(30, 90)
	elif roll < personality_aggression * 0.5 + 0.4:
		bot_state = BotState.RETREAT
		state_duration = randi_range(20, 60)
	else:
		bot_state = BotState.NEUTRAL
		state_duration = randi_range(45, 120)


func process() -> void:
	# 状態の持続時間を減らす
	state_duration -= 1
	if state_duration <= 0:
		_change_state()
	
	# 反応遅延の処理
	if reaction_delay > 0:
		reaction_delay -= 1
	
	# ためらいの処理
	if hesitation > 0:
		hesitation -= 1
		character.walk(0)
		return
	
	var direction = 1 if rival.position.x > character.position.x else -1
	var distance = abs(rival.position.x - character.position.x)
	
	# 相手の動きを検知（反応遅延付き）
	var rival_moving = abs(rival.position.x - last_rival_x) > 2
	last_rival_x = rival.position.x
	
	# コンボ中の処理
	if bot_state == BotState.COMBO:
		_process_combo(direction, distance)
		return
	
	# 攻撃中は追加入力の可能性
	if character.state == Character.State.ATTACKING:
		if randf() < 1 / 20.0:
			character.attack()
		return
	
	# 状態に応じた行動
	match bot_state:
		BotState.AGGRESSIVE:
			_process_aggressive(direction, distance)
		BotState.DEFENSIVE:
			_process_defensive(direction, distance)
		BotState.RETREAT:
			_process_retreat(direction, distance)
		BotState.NEUTRAL:
			_process_neutral(direction, distance, rival_moving)
	
	# ジャンプの判定
	_process_jump(distance)


func _process_aggressive(direction: int, distance: float) -> void:
	# 積極的に近づく
	frame_count -= 1
	if frame_count < 0:
		frame_count = randi_range(10, 30)
		# 相手に向かって移動する確率が高い
		if randf() < 0.85:
			walk_direction = direction
		elif randf() < 0.5:
			walk_direction = 0
		else:
			walk_direction = - direction
	
	character.walk(walk_direction)
	
	# 近距離で攻撃
	if distance < 180:
		if randf() < 1 / 8.0:
			# コンボ開始の可能性
			if randf() < 0.3:
				bot_state = BotState.COMBO
				combo_count = randi_range(2, 4)
			character.attack()
	elif distance < 300:
		if randf() < 1 / 30.0:
			character.attack()
	
	# 必殺技
	if randf() < 1 / 200.0:
		character.special()


func _process_defensive(direction: int, distance: float) -> void:
	frame_count -= 1
	if frame_count < 0:
		frame_count = randi_range(20, 50)
		# 距離を保つ動き
		if distance < 150:
			walk_direction = - direction
		elif distance > 300:
			walk_direction = direction
		else:
			var choices = [0, 0, 0, direction, -direction]
			choices.shuffle()
			walk_direction = choices[0]
	
	character.walk(walk_direction)
	
	# カウンター攻撃（相手が近づいてきたとき）
	if distance < 120:
		if randf() < 1 / 12.0:
			character.attack()
			# 攻撃後に下がる
			if randf() < 0.5:
				bot_state = BotState.RETREAT
				state_duration = randi_range(15, 30)


func _process_retreat(direction: int, distance: float) -> void:
	# 後退する
	walk_direction = - direction
	character.walk(walk_direction)
	
	# 一定距離離れたら状態変更
	if distance > 350:
		_change_state()
	
	# 逃げながらも時々攻撃
	if randf() < 1 / 60.0:
		character.attack()


func _process_neutral(direction: int, distance: float, rival_moving: bool) -> void:
	frame_count -= 1
	if frame_count < 0:
		frame_count = randi_range(15, 45)
		# ランダムな動き
		var directions = [direction, direction, direction, 0, 0, 0, 0, -direction, -direction]
		directions.shuffle()
		walk_direction = directions[0]
		
		# たまにためらう
		if randf() < 0.15:
			hesitation = randi_range(10, 25)
	
	character.walk(walk_direction)
	
	# 相手の動きに反応（遅延付き）
	if rival_moving and reaction_delay <= 0:
		reaction_delay = randi_range(5, 15)
		if randf() < 0.4:
			walk_direction = direction
	
	# 攻撃判定
	if distance < 200:
		if randf() < 1 / 20.0:
			character.attack()
	elif distance < 350:
		if randf() < 1 / 90.0:
			character.attack()
	
	# 必殺技
	if randf() < 1 / 400.0:
		character.special()


func _process_combo(direction: int, distance: float) -> void:
	character.walk(direction)
	
	if character.state != Character.State.ATTACKING:
		if combo_count > 0:
			# コンボの間に少し待つ
			if randf() < 0.7:
				character.attack()
				combo_count -= 1
			else:
				# コンボミス
				combo_count = 0
		else:
			_change_state()
	else:
		# 攻撃中の追加入力
		if randf() < 1 / 10.0:
			character.attack()


func _process_jump(distance: float) -> void:
	# 基本のジャンプ確率
	var jump_chance = 1.0 / 240.0
	
	# 相手がジャンプしていたら追従ジャンプ
	if rival.is_jumping():
		if reaction_delay <= 0:
			jump_chance = 1.0 / 20.0
			reaction_delay = randi_range(3, 10)
	
	# 近距離では回避ジャンプ
	if distance < 100 and bot_state == BotState.DEFENSIVE:
		jump_chance = 1.0 / 30.0
	
	# 攻撃的なときは飛び込みジャンプ
	if distance < 250 and distance > 150 and bot_state == BotState.AGGRESSIVE:
		jump_chance = 1.0 / 45.0
	
	if randf() < jump_chance:
		character.jump()
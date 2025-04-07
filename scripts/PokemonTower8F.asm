PokemonTower8F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PokemonTower8TrainerHeaders
	ld de, PokemonTower8F_ScriptPointers
	ld a, [wPokemonTower8FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonTower8FCurScript], a
	ret

PokemonTower8FSetDefaultScript:
	xor a
	ld [wJoyIgnore], a
	ld [wPokemonTower8FCurScript], a ; SCRIPT_POKEMONTOWER8F_DEFAULT
	ld [wCurMapScript], a ; SCRIPT_POKEMONTOWER8F_DEFAULT
	ret

PokemonTower8F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_POKEMONTOWER8F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_POKEMONTOWER7F_START_BATTLE
	dw_const PokemonTower8FEndBattleScript,         SCRIPT_POKEMONTOWER8F_END_BATTLE
	dw_const PokemonTower8FHideNPCScript,           SCRIPT_POKEMONTOWER8F_HIDE_NPC


PokemonTower8FEndBattleScript:
	ld hl, wMiscFlags
	res BIT_SEEN_BY_TRAINER, [hl]
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonTower8FSetDefaultScript
	call EndTrainerBattle
	ld a, D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, [wSpriteIndex]
	ldh [hSpriteIndex], a
	call DisplayTextID
	call PokemonTower8FRocketLeaveMovementScript
	ld a, SCRIPT_POKEMONTOWER8F_HIDE_NPC
	ld [wPokemonTower8FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower8FHideNPCScript:
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
	ld hl, wMissableObjectList
	ld a, [wSpriteIndex]
	ld b, a
.missableObjectsListLoop
	ld a, [hli]
	cp b            ; search for sprite ID in missing objects list
	ld a, [hli]
	jr nz, .missableObjectsListLoop
	ld [wMissableObjectIndex], a   ; remove missable object
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	ld [wSpriteIndex], a
	ld [wTrainerHeaderFlagBit], a
	ld [wOpponentAfterWrongAnswer], a
	ld a, SCRIPT_POKEMONTOWER8F_DEFAULT
	ld [wPokemonTower8FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonTower8FRocketLeaveMovementScript:
	ld hl, PokemonTower8FNPCCoordMovementTable
	ld a, [wSpriteIndex]
	dec a
	swap a
	ld d, $0
	ld e, a
	add hl, de
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
.loop
	ld a, [hli]
	cp b
	jr nz, .inc_and_skip
	ld a, [hli]
	cp c
	jr nz, .skip
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld a, [wSpriteIndex]
	ldh [hSpriteIndex], a
	jp MoveSprite
.inc_and_skip
	inc hl
.skip
	inc hl
	inc hl
	jr .loop

PokemonTower8FNPCCoordMovementTable:
	map_coord_movement  9, 12, PokemonTower8FRocket1ExitRightDownMovement
	map_coord_movement 10, 11, PokemonTower8FRocket1ExitDownRightMovement
	map_coord_movement 11, 11, PokemonTower8FRocketExitDownMovement
	map_coord_movement 12, 11, PokemonTower8FRocketExitDownMovement
	map_coord_movement 12, 10, PokemonTower8FRocket2ExitLeftDownMovement
	map_coord_movement 11,  9, PokemonTower8FRocket2ExitDownLeftMovement
	map_coord_movement 10,  9, PokemonTower8FRocketExitDownMovement
	map_coord_movement  9,  9, PokemonTower8FRocketExitDownMovement
	map_coord_movement  9,  8, PokemonTower8FRocket3ExitRightDownMovement
	map_coord_movement 10,  7, PokemonTower8FRocketExitDownMovement
	map_coord_movement 11,  7, PokemonTower8FRocketExitDownMovement
	map_coord_movement 12,  7, PokemonTower8FRocketExitDownMovement

PokemonTower8FRocket1ExitRightDownMovement:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db -1 ; end

PokemonTower8FRocket1ExitDownRightMovement:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

PokemonTower8FRocketExitDownMovement:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

PokemonTower8FRocket2ExitLeftDownMovement:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

PokemonTower8FRocket2ExitDownLeftMovement:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_DOWN
	db -1 ; end

PokemonTower8FRocket3ExitRightDownMovement:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db -1 ; end

PokemonTower8F_TextPointers:
	def_text_pointers
	dw_const PokemonTower8FRocket1Text, TEXT_POKEMONTOWER8F_ROCKET1
	dw_const PokemonTower8FRocket2Text, TEXT_POKEMONTOWER8F_ROCKET2
	dw_const PokemonTower8FRocket3Text, TEXT_POKEMONTOWER8F_ROCKET3

PokemonTower8TrainerHeaders:
	def_trainers
PokemonTower8TrainerHeader0:
	trainer EVENT_BEAT_POKEMONTOWER_8_TRAINER_0, 3, PokemonTower8FRocket1BattleText, PokemonTower8FRocket1EndBattleText, PokemonTower8FRocket1AfterBattleText
PokemonTower8TrainerHeader1:
	trainer EVENT_BEAT_POKEMONTOWER_8_TRAINER_1, 3, PokemonTower8FRocket2BattleText, PokemonTower8FRocket2EndBattleText, PokemonTower8FRocket2AfterBattleText
PokemonTower8TrainerHeader2:
	trainer EVENT_BEAT_POKEMONTOWER_8_TRAINER_2, 3, PokemonTower8FRocket3BattleText, PokemonTower8FRocket3EndBattleText, PokemonTower8FRocket3AfterBattleText
	db -1 ; end

PokemonTower8FRocket1Text:
	text_asm
	ld hl, PokemonTower8TrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

PokemonTower8FRocket2Text:
	text_asm
	ld hl, PokemonTower8TrainerHeader1
	call TalkToTrainer
	rst TextScriptEnd

PokemonTower8FRocket3Text:
	text_asm
	ld hl, PokemonTower8TrainerHeader2
	call TalkToTrainer
	rst TextScriptEnd

PokemonTower8FRocket1BattleText:
	text_far _PokemonTower8FRocket1BattleText
	text_end

PokemonTower8FRocket1EndBattleText:
	text_far _PokemonTower8FRocket1EndBattleText
	text_end

PokemonTower8FRocket1AfterBattleText:
	text_far _PokemonTower8FRocket1AfterBattleText
	text_end

PokemonTower8FRocket2BattleText:
	text_far _PokemonTower8FRocket2BattleText
	text_end

PokemonTower8FRocket2EndBattleText:
	text_far _PokemonTower8FRocket2EndBattleText
	text_end

PokemonTower8FRocket2AfterBattleText:
	text_far _PokemonTower8FRocket2AfterBattleText
	text_end

PokemonTower8FRocket3BattleText:
	text_far _PokemonTower8FRocket3BattleText
	text_end

PokemonTower8FRocket3EndBattleText:
	text_far _PokemonTower8FRocket3EndBattleText
	text_end

PokemonTower8FRocket3AfterBattleText:
	text_far _PokemonTower8FRocket3AfterBattleText
	text_end

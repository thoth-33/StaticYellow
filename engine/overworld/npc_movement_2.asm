SetEnemyTrainerToStayAndFaceAnyDirection::
	ld a, [wCurMap]
	cp POKEMON_TOWER_7F
	ret z ; the Rockets on Pokemon Tower 7F leave after battling, so don't freeze them
	ld hl, DontFreezeIDs
	; PureRGBnote: FIXED: this byte will actually hold the value they wanted to check here...old one was overwritten in battle
	ld a, [wCurOpponent]
	ld b, a
.loop
	ld a, [hli]
	cp -1
	jr z, .doFreeze
	cp b
	ret z ; certain NPCs we won't freeze after battling since they might walk away or talk to us immediately
	jr .loop
.doFreeze
	ld a, [wSpriteIndex]
	ldh [hSpriteIndex], a
	jp SetSpriteMovementBytesToFF

DontFreezeIDs:
	db OPP_RIVAL1
	db OPP_RIVAL2
	db OPP_RIVAL3
	db OPP_BROCK
	db OPP_MISTY
	db OPP_LT_SURGE
	db OPP_ERIKA
	db OPP_KOGA
	db OPP_SABRINA
	db OPP_BLAINE
	db OPP_GIOVANNI
	db OPP_LORELEI
	db OPP_BRUNO
	db OPP_AGATHA
	db OPP_LANCE
	db OPP_PROF_OAK
	db -1 ; end

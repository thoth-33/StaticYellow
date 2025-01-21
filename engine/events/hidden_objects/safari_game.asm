SafariZoneCheck::
	CheckEventHL EVENT_IN_SAFARI_ZONE ; if we are not in the Safari Zone,
	jr z, SafariZoneGameStillGoing ; don't bother printing game over text
;;;;;;;;;; PureRGBnote: ADDED: free roam safari doesn't end based on steps
	ld a, [wSafariType]
	cp SAFARI_TYPE_FREE_ROAM ; in Classic when safari ball counter reaches 0 we end the safari.
	jr z, SafariZoneGameStillGoing ; if we're in a Free Roam safari game, we can't game over from 0 safari balls since there aren't any.
;;;;;;;;;;
	ld a, [wNumSafariBalls]
	and a
	jr z, SafariZoneGameOver
	jr SafariZoneGameStillGoing

SafariZoneCheckSteps::
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
;;;;;;;;;; PureRGBnote: ADDED: free roam safari doesn't end based on steps
	ld a, [wSafariType]
	cp SAFARI_TYPE_FREE_ROAM
	ret z ; if we're in a free roam safari, there's no game over caused by step limit.
;;;;;;;;;;
	ld a, [wSafariSteps]
	ld b, a
	ld a, [wSafariSteps + 1]
	ld c, a
;	bc_deref_reverse wSafariSteps ;; PURERGB CODE. Could try if bugs.
	or b
	jr z, SafariZoneGameOver
	dec bc
	ld a, b
	ld [wSafariSteps], a
	ld a, c
	ld [wSafariSteps + 1], a
SafariZoneGameStillGoing:
	xor a
	ld [wSafariZoneGameOver], a
	ret

SafariZoneGameOver:
	call EnableAutoTextBoxDrawing
	xor a
	ld [wAudioFadeOutControl], a
	call StopAllMusic
	ld c, BANK(SFX_Safari_Zone_PA)
	ld a, SFX_SAFARI_ZONE_PA
	call PlayMusic
.waitForMusicToPlay
	ld a, [wChannelSoundIDs + CHAN5]
	cp SFX_SAFARI_ZONE_PA
	jr nz, .waitForMusicToPlay
	ld a, TEXT_SAFARI_GAME_OVER
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wPlayerMovingDirection], a
	ld a, SAFARI_ZONE_GATE
	ldh [hWarpDestinationMap], a
	ld a, $3
	ld [wDestinationWarpID], a
	ld a, SCRIPT_SAFARIZONEGATE_LEAVING_SAFARI
	ld [wSafariZoneGateCurScript], a
	SetEvent EVENT_SAFARI_GAME_OVER
	ld a, 1
	ld [wSafariZoneGameOver], a
	ret

PrintSafariGameOverText::
	xor a
	ld [wJoyIgnore], a
	ld hl, SafariGameOverText
	jp PrintText

SafariGameOverText:
	text_asm
	ld a, [wNumSafariBalls]
	and a
	jr z, .noMoreSafariBalls
	ld hl, TimesUpText
	call PrintText
.noMoreSafariBalls
	ld hl, GameOverText
	call PrintText
	rst TextScriptEnd

; PureRGBnote: ADDED: used when leaving the safari zone by flying, teleporting, blacking out, etc.
;                     clears all variables related to the safari game you were in
ClearSafariFlags::
	ResetEvents EVENT_SAFARI_GAME_OVER, EVENT_IN_SAFARI_ZONE
	xor a
	ld [wSafariType], a
	ld [wNumSafariBalls], a
	ld [wSafariSteps], a
	ld [wSafariZoneGameOver], a 
	ld [wSafariZoneGateCurScript], a ; SCRIPT_SAFARIZONEGATE_DEFAULT
	ret

TimesUpText:
	text_far _TimesUpText
	text_end

GameOverText:
	text_far _GameOverText
	text_end

SafariZoneGatePrintSafariZoneWorker1WouldYouLikeToJoinText::
	ld hl, .WelcomeText
	rst _PrintText
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .PleaseComeAgain
	
	xor a
	ldh [hMoney], a
	ldh [hMoney + 2], a
	ld a, 5
	ldh [hMoney + 1], a
	call HasEnoughMoney
	jr nc, .success
	ld hl, .NotEnoughMoneyText
	rst _PrintText
	jr .CantPayWalkDown

.success
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 2], a
	ld a, 5
	ld [wPriceTemp + 1], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, 3
	predef SubBCDPredef
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, .MakePaymentText
	rst _PrintText
	call AskGameType
	jr c, .PleaseComeAgain ; if we cancelled, don't continue
	ld a, D_UP
	ld c, 3
	call SafariZoneEntranceAutoWalk2
	SetEvent EVENT_IN_SAFARI_ZONE
	ResetEventReuseHL EVENT_SAFARI_GAME_OVER
	ld a, SCRIPT_SAFARIZONEGATE_PLAYER_MOVING
	ld [wSafariZoneGateCurScript], a
	jr .done
.PleaseComeAgain
	ld hl, .PleaseComeAgainText
	rst _PrintText
.CantPayWalkDown
	ld a, D_DOWN
	ld c, 1
	call SafariZoneEntranceAutoWalk2
	ld a, SCRIPT_SAFARIZONEGATE_PLAYER_MOVING_DOWN
	ld [wSafariZoneGateCurScript], a
.done
	rst TextScriptEnd

.WelcomeText
	text_far _SafariZoneGateSafariZoneWorker1WouldYouLikeToJoinText
	text_end

.MakePaymentText
	text_far _SafariZoneGateSafariZoneWorker1ThatllBe500PleaseText
;	sound_get_item_1
	text_end

.PleaseComeAgainText:
	text_far _SafariZoneGateSafariZoneWorker1PleaseComeAgainText
	text_end

.NotEnoughMoneyText
	text_far _SafariZoneGateSafariZoneWorker1NotEnoughMoneyText
	text_end

SafariZoneGatePrintSafariZoneWorker2Text::
	ld hl, .FirstTimeHereText
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, .YoureARegularHereText
	jr nz, .print_text
	call AskGameTypeExplanation
	jr c, .noSelection
	rst TextScriptEnd
.noSelection
	ld hl, .YoureARegularHereText
.print_text
	rst _PrintText
	rst TextScriptEnd

.FirstTimeHereText
	text_far _SafariZoneGateSafariZoneWorker2FirstTimeHereText
	text_end

.SafariZoneExplanationText
	text_far _SafariZoneGateSafariZoneWorker2SafariZoneExplanationText
	text_end

.YoureARegularHereText
	text_far _SafariZoneGateSafariZoneWorker2YoureARegularHereText
	text_end

SafariZoneEntranceAutoWalk2:
	push af
	ld b, 0
	ld a, c
	ld [wSimulatedJoypadStatesIndex], a
	ld hl, wSimulatedJoypadStatesEnd
	pop af
	call FillMemory
	jp StartSimulatingJoypadStates

SafariZoneEntranceConvertBCDtoNumber:
	push hl
	ld c, a
	and $f
	ld l, a
	ld h, $0
	ld a, c
	and $f0
	swap a
	ld bc, 10
	call AddNTimes
	ld a, l
	pop hl
	ret

AskGameType:
	ld hl, SafariZoneEntranceWhatGame
	rst _PrintText
	ld hl, SafariTypeOptions
	ld b, A_BUTTON | B_BUTTON
	call DisplayMultiChoiceTextBox
	jr nz, .goodbye
	ld hl, TextPointers_SafariGames
	ld a, [wCurrentMenuItem]
	call GetAddressFromPointerArray
	rst _PrintText
	and a
	ret
.goodbye
	; give back the 500 that was just deducted
	ld de, wPlayerMoney + 2
	ld hl, hMoney + 2 ; total price of items
	ld c, 3 ; length of money in bytes
	predef AddBCDPredef ; add total price to money
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID ; redraw money text box
	scf
	ret

TextPointers_SafariGames:
	dw SafariClassicPaidInfo
	dw SafariFreeRoamPaidInfo

SafariZoneEntranceWhatGame:
	text_far _SafariZoneEntranceWhatGame
	text_end

SafariZoneEntranceSafariBallsReceived:
	text_far _SafariZoneEntranceSafariBallsReceived
	sound_get_item_1
	text_end

SafariZonePAText:
	text_far _SafariZoneEntranceText_75360
	text_end

SafariClassicPaidInfo:
	text_asm
	ld hl, SafariZoneClassicText
	rst _PrintText
	ld hl, SafariZoneEntranceSafariBallsReceived
	rst _PrintText
	ld hl, SafariZonePAText
	rst _PrintText
	ld a, 30
	ld [wNumSafariBalls], a
	ld a, HIGH(502)
	ld [wSafariSteps], a
	ld a, LOW(502)
	ld [wSafariSteps + 1], a
	ld a, SAFARI_TYPE_CLASSIC
	ld [wSafariType], a
	rst TextScriptEnd


SafariFreeRoamPaidInfo:
	text_asm
	ld hl, SafariZoneFreeRoam
	rst _PrintText
	xor a
	ld [wNumSafariBalls], a
	ld a, SAFARI_TYPE_FREE_ROAM
	ld [wSafariType], a
	rst TextScriptEnd

SafariZoneClassicText:
	text_far _SafariZoneClassic
	text_end

SafariZoneFreeRoam:
	text_far _SafariZoneFreeRoam
	text_end

AskGameTypeExplanation:
	ld hl, SafariZoneHelp
	rst _PrintText
	ld hl, SafariTypeOptions
	ld b, A_BUTTON | B_BUTTON
	call DisplayMultiChoiceTextBox
	jr nz, .goodbye
	ld hl, TextPointers_SafariExplanations
	ld a, [wCurrentMenuItem]
	call GetAddressFromPointerArray
	rst _PrintText
	and a
	ret
.goodbye
	scf
	ret

TextPointers_SafariExplanations:
	dw ExplanationText
	dw SafariZoneFreeRoam

SafariZoneHelp:
	text_far _SafariZoneHelp
	text_end

ExplanationText:
	text_far _SafariZoneGateSafariZoneWorker2SafariZoneExplanationText
	text_end

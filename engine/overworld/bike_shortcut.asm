TryRideBike::
	xor a
.setUp
	ld a,BICYCLE
	ld [wCurPartySpecies],a
	ld [wPseudoItemID],a
	ld [wPokedexNum],a ; store item ID for GetItemName
	call GetItemName
	call CopyToStringBuffer
.tryForBike
	ld b,BICYCLE
	call IsItemInBag
	jr nz,.hasBike
	call EnableBikeShortcutText
	ld hl,TextNoBike ; if no bike
	call PrintText
	jr .cleanUp
.hasBike
	farcall IsBikeRidingAllowed
	jr c, .checkSurfing
	call EnableBikeShortcutText
.checkSurfing
	ld a,[wWalkBikeSurfState]
	cp 2
	jr nz,.checkCyclingRoad ; if not surfing
	call EnableBikeShortcutText
.checkCyclingRoad
	ld a,[wStatusFlags6] ; cycling road
	bit BIT_ALWAYS_ON_BIKE, a
	jr z, .useItem ;if not on cycling road skip text
	call EnableBikeShortcutText
.useItem
	call UseItem
.cleanUp
	call CloseBikeShortcutText
	ret

TextNoBike:
	text_far _NoBicycleText1
	text_end

EnableBikeShortcutText: ; Gets everything setup to let you display text properly
	call EnableAutoTextBoxDrawing
	ld a, 1 ; not 0
	ld [hTextID], a
	farcall DisplayTextIDInit
	ret

CloseBikeShortcutText: ; Closes the text out properly to prevent glitches
	ld a,[hLoadedROMBank]
	push af
	jp CloseTextDisplay

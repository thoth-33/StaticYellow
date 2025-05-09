VBlank::

	push af
	push bc
	push de
	push hl

	ldh a, [rVBK] ; vram bank
	push af
	xor a
	ldh [rVBK], a ; reset vram bank to 0

	ldh a, [hLoadedROMBank]
	ld [wVBlankSavedROMBank], a

	; joenote - set the correct backed-up bank if vblank happened during a DelayFrame function
	ld a, [wDelayFrameBank]
	and a
	jr z, .no_delay_bank
	ld [hLoadedROMBank], a
	ld [MBC1RomBank], a
.no_delay_bank

	ldh a, [hSCX]
	ldh [rSCX], a
	ldh a, [hSCY]
	ldh [rSCY], a

	ld a, [wDisableVBlankWYUpdate]
	and a
	jr nz, .ok
	ldh a, [hWY]
	ldh [rWY], a
.ok

	call AutoBgMapTransfer
	call VBlankCopyBgMap
	call RedrawRowOrColumn
	call VBlankCopy
	call VBlankCopyDouble
	call UpdateMovingBgTiles
;;;;;;;;;;;;;;;; marcelnote - OAM updates can be interrupted by V-Blank (pokered Wiki)
	ld a, [hSkipOAMUpdates]
	bit 0, a
	call z, hDMARoutine
;;;;;;;;;;;;;;;;
;	call hDMARoutine
;	ld a, BANK(PrepareOAMData)
;	ldh [hLoadedROMBank], a
;	ld [MBC1RomBank], a
;	call PrepareOAMData

	; VBlank-sensitive operations end.
	call TrackPlayTime ; keep track of time played

	call Random
	call ReadJoypad

	ldh a, [hVBlankOccurred]
	and a
	jr z, .skipZeroing
	xor a
	ldh [hVBlankOccurred], a

.skipZeroing
	ldh a, [hFrameCounter]
	and a
	jr z, .skipDec
	dec a
	ldh [hFrameCounter], a

.skipDec
	farcall FadeOutAudio

	ld a, BANK(Music_DoLowHealthAlarm)
	call BankswitchCommon
	call Music_DoLowHealthAlarm
	ld a, BANK(Audio1_UpdateMusic)
	call BankswitchCommon
	call Audio1_UpdateMusic

	call SerialFunction

	ld a, [wVBlankSavedROMBank]
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a

	pop af
	ldh [rVBK], a

	pop hl
	pop de
	pop bc
	pop af
	reti


DelayFrame::
; Wait for the next vblank interrupt.
; As a bonus, this saves battery.

DEF NOT_VBLANKED EQU 1

	ld a, NOT_VBLANKED
	ldh [hVBlankOccurred], a

	ldh a, [hLoadedROMBank]
	ld [wDelayFrameBank], a

	call home_PrepareOAMData

	xor a
	ld [wDelayFrameBank], a

	ldh a, [rLCDC]
	bit rLCDC_ENABLE, a
	jp z, VBlank ;You will never enter the vblank interrupt if the LCD is disabled, so call it manually
.halt
	halt
	nop
	ldh a, [hVBlankOccurred]
	and a
	jr nz, .halt
	ret

;joenote - optimize PrepareOAMData so that overworld sprites don't wobble
home_PrepareOAMData::
	push bc
	push de
	push hl
	ld hl, hSkipOAMUpdates
	bit 0, [hl] ; is OAM skip enabled?
	jr nz, .skipOAM
; if disabled, then enable it for now
; This is so DMA transfer is skipped in case vblank triggers while PrepareOAMData is running.
	set 0, [hl]
	farcall PrepareOAMData
	ld hl, hSkipOAMUpdates
	res 0, [hl] ; disable the OAM skip flag
.skipOAM
	pop hl
	pop de
	pop bc
;Notes:
; - A good place to test this is the row of four trainers on route 8.
; - There may be a rare 1-frame flicker due to instances where DMA transfer gets skipped for 1 frame.
; --> But trying to do DMA transfer here is worse because audio noise gets injected when drawing the screen.
; --> A real gameboy's TFT screen might be able to hide this.
	ret

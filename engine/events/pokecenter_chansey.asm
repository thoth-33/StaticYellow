PokecenterChanseyText::
	ld hl, NurseChanseyText
	rst _PrintText
	ld a, CHANSEY
	call PlayCry
	call WaitForSoundToFinish
	ret

NurseChanseyText:
	text_far _NurseChanseyText
	text_end

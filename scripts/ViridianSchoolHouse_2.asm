ViridianSchoolHousePrintLittleGirlText::
	ld hl, .text
	rst _PrintText
	ret

.text
	text_far _ViridianSchoolHouseLittleGirlText
	text_end

ViridianSchoolHousePrintCooltrainerFText::
	ld hl, .text
	rst _PrintText
	ret

.text
	text_far _ViridianSchoolHouseCooltrainerFText
	text_end

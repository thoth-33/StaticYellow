CeladonCityPrintTrainerTips1Text::
	ld hl, .text
	rst _PrintText
	ret

.text
	text_far _CeladonCityTrainerTips1Text
	text_end

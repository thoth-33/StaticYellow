Route1PrintYoungster1Text::
	CheckAndSetEvent EVENT_GOT_POTION_SAMPLE
	jr nz, .got_item
	ld hl, .MartSampleText
	rst _PrintText
	lb bc, POTION, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, .GotPotionText
	jr .done
.bag_full
	ld hl, .NoRoomText
	jr .done
.got_item
	ld hl, .AlsoGotPokeballsText
.done
	rst _PrintText
	ret

.MartSampleText:
	text_far _Route1Youngster1MartSampleText
	text_end

.GotPotionText:
	text_far _Route1Youngster1GotPotionText
	sound_get_item_1
	text_end

.AlsoGotPokeballsText:
	text_far _Route1Youngster1AlsoGotPokeballsText
	text_end

.NoRoomText:
	text_far _Route1Youngster1NoRoomText
	text_end

Route1PrintYoungster2Text::
	ld hl, .text
	rst _PrintText
	ret

.text
	text_far _Route1Youngster2Text
	text_end

Route1PrintSignText::
	ld hl, .text
	rst _PrintText
	ret

.text
	text_far _Route1SignText
	text_end

CeladonDinerPrintGymGuideText::
	CheckEvent EVENT_GOT_COIN_CASE
	jr nz, .got_item
	ld hl, .ImFlatOutBustedText
	rst _PrintText
	lb bc, COIN_CASE, 1
	call GiveItem
	jr nc, .bag_full
	SetEvent EVENT_GOT_COIN_CASE
	ld hl, .ReceivedCoinCaseText
	rst _PrintText
	jr .done
.bag_full
	ld hl, .CoinCaseNoRoomText
	rst _PrintText
	jr .done
.got_item
	ld hl, .WinItBackText
	rst _PrintText
.done
	ret

.ImFlatOutBustedText:
	text_far _CeladonDinerGymGuideImFlatOutBustedText
	text_end

.ReceivedCoinCaseText:
	text_far _CeladonDinerGymGuideReceivedCoinCaseText
	sound_get_key_item
	text_end

.CoinCaseNoRoomText:
	text_far _CeladonDinerGymGuideCoinCaseNoRoomText
	text_end

.WinItBackText:
	text_far _CeladonDinerGymGuideWinItBackText
	text_end

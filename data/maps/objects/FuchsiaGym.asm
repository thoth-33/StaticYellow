	object_const_def
	const_export FUCHSIAGYM_KOGA
	const_export FUCHSIAGYM_ROCKER1
	const_export FUCHSIAGYM_ROCKER2
	const_export FUCHSIAGYM_ROCKER3
	const_export FUCHSIAGYM_ROCKER4
	const_export FUCHSIAGYM_ROCKER5
	const_export FUCHSIAGYM_ROCKER6
	const_export FUCHSIAGYM_ROCKER7
	const_export FUCHSIAGYM_GYM_GUIDE

FuchsiaGym_Object:
	db $3 ; border block

	def_warp_events
	warp_event  4, 17, LAST_MAP, 6
	warp_event  5, 17, LAST_MAP, 6

	def_bg_events

	def_object_events
	object_event  4, 10, SPRITE_KOGA2, STAY, DOWN, TEXT_FUCHSIAGYM_KOGA, OPP_KOGA, 1
	object_event  8, 13, SPRITE_ROCKER, STAY, RIGHT, TEXT_FUCHSIAGYM_ROCKER1, OPP_JUGGLER, 7
	object_event  7,  8, SPRITE_ROCKER, STAY, RIGHT, TEXT_FUCHSIAGYM_ROCKER2, OPP_JUGGLER, 3
	object_event  2,  7, SPRITE_JANINE, STAY, LEFT, TEXT_FUCHSIAGYM_JANINE, OPP_JANINE, 1
	object_event  3,  5, SPRITE_ROCKER, STAY, LEFT, TEXT_FUCHSIAGYM_ROCKER4, OPP_TAMER, 1
	object_event  8,  2, SPRITE_ROCKER, STAY, RIGHT, TEXT_FUCHSIAGYM_ROCKER5, OPP_TAMER, 2
	object_event  4,  2, SPRITE_ROCKER, STAY, UP, TEXT_FUCHSIAGYM_ROCKER6, OPP_JUGGLER, 4
	object_event  1, 12, SPRITE_ROCKER, STAY, DOWN, TEXT_FUCHSIAGYM_ROCKER7, OPP_JUGGLER, 8
	object_event  7, 15, SPRITE_GYM_GUIDE, STAY, DOWN, TEXT_FUCHSIAGYM_GYM_GUIDE

	def_warps_to FUCHSIA_GYM

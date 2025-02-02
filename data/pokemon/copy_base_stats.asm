CopyBaseStats:
	ld a, [wPokedexNum]
	dec a
	ld hl, BaseStats
	ld bc, BASE_DATA_SIZE
	call AddNTimes
	ld de, wMonHeader
	jp CopyData
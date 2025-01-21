; Boolean checks
DEF FALSE EQU 0
DEF TRUE  EQU 1

; flag operations
	const_def
	const FLAG_RESET ; 0
	const FLAG_SET   ; 1
	const FLAG_TEST  ; 2

;;;;;;;;;; PureRGBnote: constants for indicating which type of safari game the player is currently playing
DEF SAFARI_TYPE_CLASSIC EQU 0
DEF SAFARI_TYPE_FREE_ROAM EQU 1
;;;;;;;;;;
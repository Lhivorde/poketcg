Func_10000: ; 10000 (4:4000)
	ld a, $0
	ld [wTileMapFill], a
	call EmptyScreen
	call LoadSymbolsFont
	lb de, $30, $7f
	call SetupText
	call Set_OBJ_8x8
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, [wLCDC]
	bit LCDC_ENABLE_F, a
	jr nz, .asm_10025
	xor a
	ld [rSCX], a
	ld [rSCY], a

.asm_10025
	call Func_1288c
	call ZeroObjectPositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	ret

Func_10031: ; 10031 (4:4031)
	ldh a, [hBankSRAM]
	push af
	ld a, $1
	call BankswitchSRAM
	call $4cbb
	call DisableSRAM
	call $4b28
	call FlushAllPalettes
	call EnableLCD
	call DoFrameIfLCDEnabled
	call $4cea
	call FlushAllPalettes
	pop af
	call BankswitchSRAM
	call DisableSRAM
	ret

Func_10059: ; 10059 (4:4059)
	INCROM $10059, $100a2

Func_100a2: ; 100a2 (4:40a2)
	INCROM $100a2, $1029e

Medal_1029e: ; 1029e (4:429e)
	sub $8
	ld c, a
	ld [wd115], a
	ld a, [wd291]
	push af
	push bc
	call PauseSong
	ld a, MUSIC_STOP
	call PlaySong
	farcall Func_70000
	call DisableLCD
	call $4000
	ld a, $fa
	ld [wd114], a
	call $410c
	pop bc
	ld a, c
	add a
	ld c, a
	ld b, $0
	ld hl, Unknown_1030b
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	call $4031
	ld a, MUSIC_MEDAL
	call PlaySong
	ld a, $ff
	ld [wd116], a
.asm_102e2
	call DoFrameIfLCDEnabled
	ld a, [wd116]
	inc a
	ld [wd116], a
	and $f
	jr nz, .asm_102e2
	call $4197
	ld a, [wd116]
	cp $e0
	jr nz, .asm_102e2
	ldtx hl, WonTheMedalText
	call PrintScrollableText_NoTextBoxLabel
	call Func_3c96
	call ResumeSong
	pop af
	ld [wd291], a
	ret

Unknown_1030b: ; 1030b (4:430b)
	INCROM $1030b, $1031b

BoosterPack_1031b: ; 1031b (4:431b)
	ld c, a
	ld a, [wd291]
	push af
	push bc
	call DisableLCD
	call $4000
	xor a
	ld [wTextBoxFrameType], a
	pop bc
	push bc
	ld b, $0
	ld hl, $43a5
	add hl, bc
	ld a, [hl]
	ld c, a
	add a
	add a
	ld c, a
	ld hl, $43c2
	add hl, bc
	ld a, [hli]
	push hl
	ld bc, $0600
	call $70ca
	pop hl
	ld a, [hli]
	ld [wTxRam3], a
	xor a
	ld [wTxRam3 + 1], a
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	call $4031
	call PauseSong
	ld a, MUSIC_BOOSTER_PACK
	call PlaySong
	pop bc
	ld a, c
	farcall GenerateBoosterPack
	ldtx hl, ReceivedBoosterPackText
	ld a, [wd117]
	cp $1
	jr nz, .asm_10373
	ldtx hl, AndAnotherBoosterPackText
.asm_10373
	call PrintScrollableText_NoTextBoxLabel
	call Func_3c96
	call ResumeSong
	ldtx hl, CheckedCardsInBoosterPackText
	call PrintScrollableText_NoTextBoxLabel
	call DisableLCD
	call Func_1288c
	call ZeroObjectPositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	ld a, $4
	ld [wTextBoxFrameType], a
	farcall Func_7599
	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	pop af
	ld [wd291], a
	ret
; 0x103a5

	INCROM $103a5, $103d2

Func_103d2: ; 103d2 (4:43d2)
	INCROM $103d2, $103d3

Duel_Init: ; 103d3 (4:43d3)
	ld a, [wd291]
	push af
	call DisableLCD
	call $4000
	ld a, $4
	ld [wTextBoxFrameType], a
	lb de, 0, 12
	lb bc, 20, 6
	call DrawRegularTextBox
	ld a, [wcc19]
	add a
	add a
	ld c, a
	ld b, $0
	ld hl, $445b
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hli]
	ld [wTxRam2 + 1], a
	push hl
	ld a, [wOpponentName]
	ld [wTxRam2_b], a
	ld a, [wOpponentName + 1]
	ld [wTxRam2_b + 1], a
	ld hl, $4451
	call $51b3 ; LoadDuelistName
	pop hl
	ld a, [hli]
	ld [wTxRam2], a
	ld c, a
	ld a, [hli]
	ld [wTxRam2 + 1], a
	or c
	jr z, .asm_10425
	ld hl, $4456
	call $51b3 ; LoadDeckName

.asm_10425
	ld bc, $0703
	ld a, [wOpponentPortrait]
	call Func_3e2a ; LoadDuelistPortrait
	ld a, [wMatchStartTheme]
	call PlaySong
	call $4031
	call DoFrameIfLCDEnabled
	lb bc, $2f, $1d ; cursor tile, tile behind cursor
	lb de, 18, 17 ; x, y
	call SetCursorParametersForTextBox
	call WaitForButtonAorB
	call Func_3c96
	call Func_10ab4 ; fade out
	pop af
	ld [wd291], a
	ret
; 0x10451

	INCROM $10451, $10548

Func_10548: ; 10548 (4:4548)
	INCROM $10548, $10756

Func_10756: ; 10756 (4:4756)
	INCROM $10756, $10a70

Func_10a70: ; 10a70 (4:4a70)
	push hl
	push bc
	push de
	ld b, a
	ld c, $f
	ld hl, wPCPacks
.asm_10a79
	ld a, [hli]
	and $7f
	cp b
	jr z, .asm_10a97
	dec c
	jr nz, .asm_10a79
	ld c, $f
	ld hl, wPCPacks
.asm_10a87
	ld a, [hl]
	and $7f
	jr z, .asm_10a93
	inc hl
	dec c
	jr nz, .asm_10a87
	debug_ret
	jr .asm_10a97

.asm_10a93
	ld a, b
	or $80
	ld [hl], a

.asm_10a97
	pop de
	pop bc
	pop hl
	ret

Func_10a9b: ; 10a9b (4:4a9b)
	INCROM $10a9b, $10ab4

Func_10ab4: ; 10ab4 (4:4ab4)
	INCROM $10ab4, $10af9

Func_10af9: ; 10af9 (4:4af9)
	INCROM $10af9, $10c96

Func_10c96: ; 10c96 (4:4c96)
	ldh a, [hBankSRAM]
	push af
	push bc
	ld a, $1
	call BankswitchSRAM
	call $4cbb
	call Func_10ab4
	pop bc
	ld a, c
	or a
	jr nz, .asm_10cb0
	call $4cea
	call Func_10af9

.asm_10cb0
	call EnableLCD
	pop af
	call BankswitchSRAM
	call DisableSRAM
	ret
; 0x10cbb

	INCROM $10cbb, $10dba

Func_10dba: ; 10dba (4:4dba)
	ld a, $1
	farcall Func_c29b
	ld a, [wd0ba]
	ld hl, $4e17
	farcall Func_111e9
.asm_10dca
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .asm_10dca
	ld a, e
	ld [wd0ba], a
	ldh a, [hCurMenuItem]
	cp e
	jr z, .asm_10ddd
	ld a, $4

.asm_10ddd
	ld [wd10e], a
	push af
	ld hl, $4df0
	call JumpToFunctionInTable
	farcall Func_c135
	call DoFrameIfLCDEnabled
	pop af
	ret
; 0x10df0

	INCROM $10df0, $10e28

Func_10e28: ; 10e28 (4:4e28)
	INCROM $10e28, $10e55

Func_10e55: ; 10e55 (4:4e55)
	ld a, [wd336]
	ld [wWhichSprite], a
	ld a, [wd33e]
	or a
	jr nz, .asm_10e65
	call Func_10e71
	ret
.asm_10e65
	cp $2
	jr z, .asm_10e6d
	call Func_11060
	ret
.asm_10e6d
	call LoadOverworldMapSelection
	ret

Func_10e71: ; 10e71 (4:4e71)
	ldh a, [hKeysPressed]
	and D_PAD
	jr z, .asm_10e83
	farcall Func_c5d5
	ld [wd334], a
	call Func_10e97
	jr .asm_10e96
.asm_10e83
	ldh a, [hKeysPressed]
	and A_BUTTON
	jr z, .asm_10e96
	ld a, SFX_02
	call PlaySFX
	call Func_11016
	call Func_11024
	jr .asm_10e96
.asm_10e96
	ret

Func_10e97: ; 10e97 (4:4e97)
	push hl
	pop hl
	ld a, [wd32e]
	rlca
	rlca
	ld c, a
	ld a, [wd334]
	add c
	ld c, a
	ld b, $0
	ld hl, Unknown_10ebc
	add hl, bc
	ld a, [hl]
	or a
	jr z, .asm_10eb9
	ld [wd32e], a
	call Func_10f2e
	ld a, SFX_01
	call PlaySFX
.asm_10eb9
	pop bc
	pop hl
	ret

Unknown_10ebc: ; 10ebc (4:4ebc)
	INCROM $10ebc, $10efd

Func_10efd: ; 10efd (4:4efd)
	push hl
	push de
	rlca
	ld e, a
	ld d, $0
	ld hl, Unknown_10f14
	add hl, de
	pop de
	ld a, [hli]
	add $8
	add d
	ld d, a
	ld a, [hl]
	add $10
	add e
	ld e, a
	pop hl
	ret

Unknown_10f14: ; 10f14 (4:4f14)
	INCROM $10f14, $10f2e

Func_10f2e: ; 10f2e (4:4f2e)
	push hl
	push de
	lb de, 1, 1
	call InitTextPrinting
	call Func_10f4a
	rlca
	ld e, a
	ld d, $0
	ld hl, Unknown_397b
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessTextFromID
	pop de
	pop hl
	ret

Func_10f4a: ; 10f4a (4:4f4a)
	push bc
	ld a, [wd32e]
	cp $2
	jr nz, .asm_10f5f
	ld c, a
	ld a, $1e
	farcall CheckIfEventFlagSet
	or a
	ld a, c
	jr nz, .asm_10f5f
	ld a, $d
.asm_10f5f
	pop bc
	ret

LoadOverworldMapSelection: ; 10f61 (4:4f61)
	push hl
	push bc
	ld a, [wd32e]
	rlca
	rlca
	ld c, a
	ld b, $0
	ld hl, OverworldMapIndexes
	add hl, bc
	ld a, [hli]
	ld [wd0bb], a
	ld a, [hli]
	ld [wd0bc], a
	ld a, [hli]
	ld [wd0bd], a
	ld a, $0
	ld [wd0be], a
	ld hl, wd0b4
	set 4, [hl]
	pop bc
	pop hl
	ret

INCLUDE "data/overworld_indexes.asm"

Func_10fbc: ; 10fbc (4:4fbc)
	ld a, $25
	farcall Func_1299f
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, $80
	ld [hli], a
	ld a, $10
	ld [hl], a
	ld b, $34
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .asm_10fd8
	ld b, $37
.asm_10fd8
	ld a, b
	farcall Func_12ab5
	ret

Func_10fde: ; 10fde (4:4fde)
	ld a, [wd32e]
	ld [wd33d], a
	xor a
	ld [wd33e], a
	ld a, $25
	call Func_1299f
	ld a, [wWhichSprite]
	ld [wd33b], a
	ld b, $35
	ld a, [wConsole]
	cp $2
	jr nz, .asm_10ffe
	ld b, $38
.asm_10ffe
	ld a, b
	ld [wd33c], a
	call Func_12ab5
	ld a, $3e
	farcall CheckIfEventFlagSet
	or a
	jr nz, .asm_11015
	ld c, SPRITE_ANIM_FIELD_0F
	call GetSpriteAnimBufferProperty
	set 7, [hl]
.asm_11015
	ret

Func_11016: ; 11016 (4:5016)
	ld a, [wd33b]
	ld [wWhichSprite], a
	ld a, [wd33c]
	inc a
	call Func_12ab5
	ret

Func_11024: ; 11024 (4:5024)
	ld a, SFX_57
	call PlaySFX
	ld a, [wd336]
	ld [wWhichSprite], a
	ld c, SPRITE_ANIM_FIELD_0F
	call GetSpriteAnimBufferProperty
	set 2, [hl]
	ld hl, Unknown_1229f
	ld a, [wd33d]
	dec a
	add a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wd32e]
	dec a
	add a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hli]
	ld [wd33f], a
	ld a, [hl]
	ld [wd340], a
	ld a, $1
	ld [wd33e], a
	xor a
	ld [wd341], a
	ret

Func_11060: ; 11060 (4:5060)
	ld a, [wd336]
	ld [wWhichSprite], a
	ld a, [wd341]
	or a
	jp nz, Func_11184
	ld a, [wd33f]
	ld l, a
	ld a, [wd340]
	ld h, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	and b
	cp $ff
	jr z, .asm_110a0
	ld a, c
	or b
	jr nz, .asm_11094
	ld a, [wd33d]
	ld e, a
	ld a, [wd32e]
	cp e
	jr z, .asm_110a0
	ld de, $0000
	call Func_10efd
	ld b, d
	ld c, e
.asm_11094
	ld a, l
	ld [wd33f], a
	ld a, h
	ld [wd340], a
	call Func_110a6
	ret
.asm_110a0
	ld a, $2
	ld [wd33e], a
	ret

Func_110a6: ; 110a6 (4:50a6)
	push hl
	push bc
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	pop bc
	ld a, b
	sub [hl]
	ld [wd343], a
	ld a, $0
	sbc $0
	ld [wd344], a
	inc hl
	ld a, c
	sub [hl]
	ld [wd345], a
	ld a, $0
	sbc $0
	ld [wd346], a
	ld a, [wd343]
	ld b, a
	ld a, [wd344]
	bit 7, a
	jr z, .asm_110d8
	ld a, [wd343]
	cpl
	inc a
	ld b, a
.asm_110d8
	ld a, [wd345]
	ld c, a
	ld a, [wd346]
	bit 7, a
	jr z, .asm_110e9
	ld a, [wd345]
	cpl
	inc a
	ld c, a
.asm_110e9
	ld a, b
	cp c
	jr c, .asm_110f2
	call Func_11102
	jr .asm_110f5
.asm_110f2
	call Func_1113e
.asm_110f5
	xor a
	ld [wd347], a
	ld [wd348], a
	farcall Func_c5e9
	pop hl
	ret

Func_11102: ; 11102 (4:5102)
	ld a, b
	ld [wd341], a
	ld e, a
	ld d, $0
	ld hl, wd343
	xor a
	ld [hli], a
	bit 7, [hl]
	jr z, .asm_11115
	dec a
	jr .asm_11116
.asm_11115
	inc a
.asm_11116
	ld [hl], a
	ld b, c
	ld c, $0
	call DivideBCbyDE
	ld a, [wd346]
	bit 7, a
	jr z, .asm_11127
	call Func_11179
.asm_11127
	ld a, c
	ld [wd345], a
	ld a, b
	ld [wd346], a
	ld hl, wd344
	ld a, $1
	bit 7, [hl]
	jr z, .asm_1113a
	ld a, $3
.asm_1113a
	ld [wd334], a
	ret

Func_1113e: ; 1113e (4:513e)
	ld a, c
	ld [wd341], a
	ld e, a
	ld d, $0
	ld hl, wd345
	xor a
	ld [hli], a
	bit 7, [hl]
	jr z, .asm_11151
	dec a
	jr .asm_11152
.asm_11151
	inc a
.asm_11152
	ld [hl], a
	ld c, $0
	call DivideBCbyDE
	ld a, [wd344]
	bit 7, a
	jr z, .asm_11162
	call Func_11179
.asm_11162
	ld a, c
	ld [wd343], a
	ld a, b
	ld [wd344], a
	ld hl, wd346
	ld a, $2
	bit 7, [hl]
	jr z, .asm_11175
	ld a, $0
.asm_11175
	ld [wd334], a
	ret

Func_11179: ; 11179 (4:5179)
	ld a, c
	cpl
	add $1
	ld c, a
	ld a, b
	cpl
	adc $0
	ld b, a
	ret

Func_11184: ; 11184 (4:5184)
	ld a, [wd347]
	ld d, a
	ld a, [wd348]
	ld e, a
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, [wd343]
	add d
	ld d, a
	ld a, [wd344]
	adc [hl]
	ld [hl], a
	inc hl
	ld a, [wd345]
	add e
	ld e, a
	ld a, [wd346]
	adc [hl]
	ld [hl], a
	ld a, d
	ld [wd347], a
	ld a, e
	ld [wd348], a
	ld hl, wd341
	dec [hl]
	ret
; 0x111b3

	INCROM $111b3, $111e9

Func_111e9: ; 111e9 (4:51e9)
	INCROM $111e9, $1124d

Func_1124d: ; 1124d (4:524d)
	INCROM $1124d, $11320

Func_11320: ; 11320 (4:5320)
	INCROM $11320, $11343

Func_11343: ; 11343 (4:5343)
	INCROM $11343, $11416

Func_11416: ; 11416 (4:5416)
	INCROM $11416, $11430

Func_11430: ; 11430 (4:5430)
	INCROM $11430, $1157c

Func_1157c: ; 1157c (4:557c)
	ld a, c
	or a
	jr nz, .asm_11586
	farcall Func_c228
	jr .asm_1159f

.asm_11586
	ld a, $2
	ld [wd0bc], a
	ld a, $4
	ld [wd0bd], a
	ld a, $2
	ld [wd0be], a
	ld a, $1
	ld [wd0bb], a
	ld a, $1
	ld [wd32e], a

.asm_1159f
	call $5238
	ret
; 0x115a3

Func_115a3: ; 115a3 (4:55a3)
	INCROM $115a3, $1162a

INCLUDE "data/map_scripts.asm"

; loads a pointer into hl found on PointerTable_118f5
Func_1184a: ; 1184a (4:584a)
	; this may have been a macro
	rlca
	add LOW(PointerTable_118f5)
	ld l, a
	ld a, HIGH(PointerTable_118f5)
	adc $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Func_11857: ; 11857 (4:5857)
	push hl
	push bc
	call Func_1184a
	ld a, [hli]
	ld [wd3ab], a
	ld a, [hli]
	ld [wd3b3], a
	ld a, [hli]
	ld [wd3b1], a
	ld a, [hli]
	push af
	ld a, [hli]
	ld [wd3b2], a
	pop bc
	ld a, [wConsole]
	cp $2
	jr nz, .asm_1187a
	ld a, b
	ld [wd3b1], a
.asm_1187a
	pop bc
	pop hl
	ret

; this appears to find data about the NPC we're talking to
Func_1187d: ; 1187d (4:587d)
	push hl
	call Func_1184a
	ld bc, $5
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld [wd0c8], a
	ld a, [hli]
	ld [wd0c9], a
	pop hl
	ret

Func_11893: ; 11893 (4:5893)
	push hl
	push bc
	call Func_1184a
	ld bc, $0007
	add hl, bc
	ld a, [hli]
	ld [wd0c8], a
	ld a, [hli]
	ld [wd0c9], a
	pop bc
	pop hl
	ret

Func_118a7: ; 118a7 (4:58a7)
	push hl
	push bc
	call Func_1184a
	ld bc, $0007
	add hl, bc
	ld a, [hli]
	ld [wOpponentName], a
	ld a, [hli]
	ld [wOpponentName + 1], a
	ld a, [hli]
	ld [wOpponentPortrait], a
	pop bc
	pop hl
	ret

Func_118bf: ; 118bf (4:58bf)
	push hl
	push bc
	call Func_1184a
	ld bc, $000a
	add hl, bc
	ld a, [hli]
	ld [wcc19], a
	ld a, [hli]
	ld [wDuelTheme], a
	pop bc
	pop hl
	ret

Func_118d3: ; 118d3 (4:58d3)
	push hl
	push bc
	push af
	call Func_1184a
	ld bc, $000c
	add hl, bc
	ld a, [hli]
	ld [wMatchStartTheme], a
	pop af
	cp $2
	jr nz, .asm_118f2
	ld a, [wCurMap]
	cp $20
	jr nz, .asm_118f2
	ld a, $17
	ld [wMatchStartTheme], a

.asm_118f2
	pop bc
	pop hl
	ret

INCLUDE "data/npcs.asm"

Func_11f4e: ; 11f4e (4:5f4e)
	INCROM $11f4e, $1217b

OverworldScriptTable: ; 1217b (4:617b)
	dw OWScript_EndScriptLoop1
	dw OWScript_CloseTextBox
	dw OWScript_PrintTextString
	dw Func_ccdc
	dw OWScript_AskQuestionJump
	dw OWScript_StartBattle
	dw Func_cd83
	dw Func_cda8
	dw OWScript_PrintTextCloseBox
	dw Func_cdcb
	dw Func_ce26
	dw Func_ce84
	dw OWScript_GiveBoosterPacks
	dw Func_cf0c
	dw Func_cf12
	dw Func_cf3f
	dw Func_cf4c
	dw Func_cf53
	dw Func_cf7b
	dw Func_cf2d
	dw Func_cf96
	dw Func_cfc6
	dw Func_cfd4
	dw Func_d00b
	dw Func_d025
	dw Func_d032
	dw Func_d03f
	dw OWScript_ScriptJump
	dw Func_d04f
	dw Func_d055
	dw OWScript_MovePlayer
	dw Func_cee2
	dw Func_d080
	dw Func_d088
	dw Func_d095
	dw Func_d0be
	dw Func_d0ce
	dw Func_d0d9
	dw Func_d0f2
	dw Func_ce4a
	dw Func_ceba
	dw Func_d103
	dw Func_d125
	dw Func_d135
	dw Func_d16b
	dw Func_cd4f
	dw Func_cd94
	dw Func_ce52
	dw Func_cdd8
	dw Func_cdf5
	dw Func_d195
	dw Func_d1ad
	dw Func_d1b3
	dw OWScript_EndScriptCloseText
	dw Func_d244
	dw Func_d24c
	dw OWScript_OpenDeckMachine
	dw Func_d271
	dw Func_d36d
	dw Func_ce6f
	dw Func_d209
	dw Func_d38f
	dw Func_d396
	dw Func_cd76
	dw Func_d39d
	dw Func_d3b9
	dw Func_d3c9
	dw Func_d3d1
	dw Func_d3d4
	dw Func_d3e0
	dw Func_d3fe
	dw Func_d408
	dw Func_d40f
	dw Func_d416
	dw Func_d423
	dw Func_d429
	dw Func_d41d
	dw Func_d42f
	dw Func_d435
	dw Func_cce4
	dw Func_d2f6
	dw Func_d317
	dw Func_d43d
	dw OWScript_EndScriptLoop2
	dw OWScript_EndScriptLoop3
	dw OWScript_EndScriptLoop4
	dw OWScript_EndScriptLoop5
	dw OWScript_EndScriptLoop6
	dw OWScript_CustomModifyEventFlags
	dw Func_d460
	dw OWScript_JumpIfFlagSet
	dw Func_d484
	dw Func_d49e
	dw Func_d4a6
	dw Func_d4ae
	dw OWScript_SetEventFlags
	dw Func_d4c3
	dw Func_d4ca
	dw OWScript_JumpIfFlagNotSet
	dw Func_d452
	dw OWScript_EndScriptLoop7
	dw OWScript_EndScriptLoop8
	dw OWScript_EndScriptLoop9
	dw OWScript_EndScriptLoop10

	INCROM $1224b, $1229f

Unknown_1229f: ; 1229f (4:629f)
	INCROM $1229f, $126d1

; usually, the game doesn't loop here at all, since as soon as a main menu option
; is selected, there is no need to come back to the menu.
; the only exception is after returning from Card Pop!
_GameLoop: ; 126d1 (4:66d1)
	call ZeroObjectPositions
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	farcall Func_70018
	ld a, $ff
	ld [wd627], a
.main_menu_loop
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	farcall Func_c1f8
	farcall Func_1d078
	ld a, [wd628]
	ld hl, MainMenuFunctionTable
	call JumpToFunctionInTable
	jr c, .main_menu_loop ; return to main menu
	jr _GameLoop ; virtually restart game

; this is never reached
	scf
	ret

MainMenuFunctionTable:
	dw MainMenu_CardPop
	dw MainMenu_ContinueFromDiary
	dw MainMenu_NewGame
	dw MainMenu_ContinueDuel

MainMenu_NewGame: ; 12704 (4:6704)
	farcall Func_c1b1
	call DisplayPlayerNamingScreen
	farcall Func_1996e
	call EnableSRAM
	ld a, [s0a007]
	ld [wd421], a
	ld a, [s0a006]
	ld [wTextSpeed], a
	call DisableSRAM
	ld a, MUSIC_STOP
	call PlaySong
	farcall Func_70000
	ld a, $9
	ld [wd111], a
	call Func_39fc
	farcall Func_1d306
	ld a, GAME_EVENT_OVERWORLD
	ld [wGameEvent], a
	farcall $03, ExecuteGameEvent
	or a
	ret

MainMenu_ContinueFromDiary: ; 12741 (4:6741)
	ld a, MUSIC_STOP
	call PlaySong
	call Func_11320
	jr nc, MainMenu_NewGame
	farcall Func_c1ed
	farcall Func_70000
	call EnableSRAM
	xor a
	ld [$ba44], a
	call DisableSRAM
	ld a, GAME_EVENT_OVERWORLD
	ld [wGameEvent], a
	farcall $03, ExecuteGameEvent
	or a
	ret

MainMenu_CardPop: ; 12768 (4:6768)
	ld a, MUSIC_CARD_POP
	call PlaySong
	bank1call Func_7571
	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	ld a, MUSIC_STOP
	call PlaySong
	scf
	ret

MainMenu_ContinueDuel: ; 1277e (4:677e)
	ld a, MUSIC_STOP
	call PlaySong
	farcall Func_c9cb
	farcall $04, Func_3a40
	farcall Func_70000
	ld a, GAME_EVENT_CONTINUE_DUEL
	ld [wGameEvent], a
	farcall $03, ExecuteGameEvent
	or a
	ret
; 0x1279a

	INCROM $1279a, $12871

Func_12871: ; 12871 (4:6871)
	INCROM $12871, $1288c

Func_1288c: ; 1288c (4:688c)
	INCROM $1288c, $128a9

DisplayPlayerNamingScreen:: ; 128a9 (4:68a9)
	; clear the name buffer.
	ld hl, wNameBuffer ; c500: name buffer.
	ld bc, NAME_BUFFER_LENGTH
	ld a, TX_END
	call FillMemoryWithA

	; get player's name
	; from the user into hl.
	ld hl, wNameBuffer
	farcall InputPlayerName

	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	call DisableLCD
	ld hl, wNameBuffer
	; get the first byte of the name buffer.
	ld a, [hl]
	or a
	; check if anything typed.
	jr nz, .no_name
	ld hl, .data
.no_name
	; set the default name.
	ld de, sPlayerName
	ld bc, NAME_BUFFER_LENGTH
	call EnableSRAM
	call CopyDataHLtoDE_SaveRegisters
	; it seems for integrity checking.
	call UpdateRNGSources
	ld [sPlayerName+$e], a
	call UpdateRNGSources
	ld [sPlayerName+$f], a
	call DisableSRAM
	ret
.data
	; "MARK": default player name.
	; last two bytes are reserved for RNG.
	textfw3 "M", "A", "R", "K"
rept 6
	done
endr
	db $10, $12
Unknown_128fb: ; 128fb
	INCROM $128fb, $1296e

Func_1296e: ; 1296e (4:696e)
	INCROM $1296e, $1299f

Func_1299f: ; 1299f (4:699f)
	push af
	ld a, [wd5d7]
	or a
	jr z, .asm_129a8
	pop af
	ret
.asm_129a8
	pop af
	push bc
	push hl
	call Func_12c05
	ld [wd5d3], a
	xor a
	ld [wWhichSprite], a
	call Func_3db7
	ld bc, $0010
.asm_129bb
	ld a, [hl]
	or a
	jr z, .asm_129cf
	add hl, bc
	ld a, [wWhichSprite]
	inc a
	ld [wWhichSprite], a
	cp $10
	jr nz, .asm_129bb
	debug_ret
	scf
	jr .asm_129d6
.asm_129cf
	ld a, $1
	ld [hl], a
	call Func_129d9
	or a
.asm_129d6
	pop hl
	pop bc
	ret

Func_129d9: ; 129d9 (4:69d9)
	push hl
	push bc
	push hl
	inc hl
	ld c, $f
	xor a
.asm_129e0
	ld [hli], a
	dec c
	jr nz, .asm_129e0
	pop hl
	ld bc, $0004
	add hl, bc
	ld a, [wd5d3]
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ld bc, $0009
	add hl, bc
	ld a, $ff
	ld [hl], a
	pop bc
	pop hl
	ret
; 0x129fa

	INCROM $129fa, $12a21

Func_12a21: ; 12a21 (4:6a21)
	INCROM $12a21, $12ab5

Func_12ab5: ; 12ab5 (4:6ab5)
	push hl
	push af
	ld c, SPRITE_ANIM_FIELD_05
	call GetSpriteAnimBufferProperty
	pop af
	cp [hl]
	pop hl
	ret z
	push hl
	call Func_12ae2
	call Func_12b13
	pop hl
	ret
; 0x12ac9

	INCROM $12ac9, $12ae2

Func_12ae2: ; 12ae2 (4:6ae2)
	push bc
	push af
	call Func_3db7
	pop af
	push hl
	ld bc, $0005
	add hl, bc
	ld [hli], a
	push hl
	ld l, $6
	farcall Func_8020f
	farcall Func_80229
	pop hl
	ld a, [wd4c6]
	ld [hli], a
	ld a, [wd4c4]
	ld [hli], a
	ld c, a
	ld a, [wd4c5]
	ld [hli], a
	ld b, a
	ld a, $3
	add c
	ld [hli], a
	ld a, $0
	adc b
	ld [hli], a
	pop hl
	pop bc
	ret

Func_12b13: ; 12b13 (4:6b13)
	push bc
	push de
	push hl
.asm_12b16
	push hl
	ld bc, $0006
	add hl, bc
	ld a, [hli]
	ld [wd4c6], a
	inc hl
	inc hl
	ld a, [hl]
	ld [wd4c4], a
	add $4
	ld [hli], a
	ld a, [hl]
	ld [wd4c5], a
	adc $0
	ld [hl], a
	ld de, wd23e
	ld bc, $0004
	call Func_3bf5
	pop hl
	ld de, wd23e
	ld a, [de]
	call Func_12b6a
	inc de
	ld a, [de]
	call Func_12b89
	jr c, .asm_12b16
	inc de
	ld bc, $0002
	add hl, bc
	push hl
	ld bc, $000d
	add hl, bc
	ld b, [hl]
	pop hl
	ld a, [de]
	bit 0, b
	jr z, .asm_12b5a
	cpl
	inc a
.asm_12b5a
	add [hl]
	ld [hli], a
	inc de
	ld a, [de]
	bit 1, b
	jr z, .asm_12b64
	cpl
	inc a
.asm_12b64
	add [hl]
	ld [hl], a
	pop hl
	pop de
	pop bc
	ret

Func_12b6a: ; 12b6a (4:6b6a)
	ld [wd4ca], a
	push hl
	push bc
	push de
	push hl
	ld bc, $0006
	add hl, bc
	ld a, [hli]
	ld [wd4c6], a
	ld a, [hli]
	ld [wd4c4], a
	ld a, [hli]
	ld [wd4c5], a
	pop hl
	call Func_3d72
	pop de
	pop bc
	pop hl
	ret

Func_12b89: ; 12b89 (4:6b89)
	push hl
	push bc
	ld bc, $000e
	add hl, bc
	ld [hl], a
	or a
	jr nz, .asm_12ba4
	ld bc, $fff9
	add hl, bc
	ld a, [hli]
	add $3
	ld c, a
	ld a, [hli]
	adc $0
	ld b, a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a
	scf
.asm_12ba4
	pop bc
	pop hl
	ret

Func_12ba7: ; 12ba7 (4:6ba7)
	INCROM $12ba7, $12bcd

Func_12bcd: ; 12bcd (4:6bcd)
	INCROM $12bcd, $12c05

Func_12c05: ; 12c05 (4:6c05)
	push hl
	push bc
	push de
	ld b, a
	ld d, $0
	ld a, [wd618]
	ld c, a
	ld hl, wd5d8
	or a
	jr z, .asm_12c22
.asm_12c15
	inc hl
	ld a, [hl]
	cp b
	jr z, .asm_12c3a
	inc hl
	ld a, [hli]
	add [hl]
	ld d, a
	inc hl
	dec c
	jr nz, .asm_12c15
.asm_12c22
	ld a, [wd618]
	cp $10
	jr nc, .asm_12c48
	inc a
	ld [wd618], a
	inc hl
	push hl
	ld a, b
	ld [hli], a
	call Func_12c4f
	push af
	ld a, d
	ld [hli], a
	pop af
	ld [hl], a
	pop hl
.asm_12c3a
	dec hl
	inc [hl]
	inc hl
	inc hl
	ld a, [hli]
	add [hl]
	cp $81
	jr nc, .asm_12c48
	ld a, d
	or a
	jr .asm_12c4b
.asm_12c48
	debug_ret
	xor a
	scf
.asm_12c4b
	pop de
	pop bc
	pop hl
	ret

Func_12c4f: ; 12c4f (4:6c4f)
	push af
	xor a
	ld [wd4cb], a
	ld a, d
	ld [wd4ca], a
	pop af
	farcall Func_8025b
	ret

Func_12c5e: ; 12c5e (4:6c5e)
	INCROM $12c5e, $12c7f

Func_12c7f: ; 12c7f (4:6c7f)
	INCROM $12c7f, $131b3

Func_131b3: ; 131b3 (4:71b3)
	INCROM $131b3, $131d3

Func_131d3: ; 131d3 (4:71d3)
	INCROM $131d3, $1344d

Func_1344d: ; 1344d (4:744d)
	call PauseSong
	ld a, MUSIC_MEDAL
	call PlaySong
	ldtx hl, DefeatedFiveOpponentsText
	call PrintScrollableText_NoTextBoxLabel
	call Func_3c96
	call ResumeSong
	ret
; 0x13462

	INCROM $13462, $13485

Func_13485: ; 13485 (4:7485)
	call EnableSRAM
	ld a, [$ba68]
	or a
	ret z
	ld a, [$ba56]
	ld [wTxRam3], a
	ld a, [$ba57]
	ld [wTxRam3 + 1], a
	call DisableSRAM
	call PauseSong
	ld a, MUSIC_MEDAL
	call PlaySong
	ldtx hl, ConsecutiveWinRecordIncreasedText
	call PrintScrollableText_NoTextBoxLabel
	call Func_3c96
	call ResumeSong
	ret
; 0x134b1

	INCROM $134b1, $14000

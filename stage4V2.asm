// ==================================================
// MATCHSTICKS GAME – STAGES 1–4 + REPLAY
// Stage 4: Multi‑row bar + colour‑flag end states
// ==================================================
//
// Registers:
// R0 – remaining matchsticks
// R1 – string address / pixel base
// R2 – temp / colour
// R3 – byte offset
// R4 – temp
// R5 – counter
// ==================================================
// =====================
// STAGE 1 : SETUP
// =====================
      MOV R1, #msg_enter_name
      STR R1, .WriteString
      MOV R1, #player_name
      STR R1, .ReadString
get_start_count:
      MOV R1, #msg_enter_count
      STR R1, .WriteString
      LDR R0, .InputNum
      CMP R0, #10
      BLT get_start_count
      CMP R0, #100
      BGT get_start_count
      STR R0, initial_count
// =====================
// GAME + REPLAY
// =====================
restart_game:
      LDR R0, initial_count
      BL draw_matchsticks
game_loop:
      MOV R1, #msg_player_prefix
      STR R1, .WriteString
      MOV R1, #player_name
      STR R1, .WriteString
      MOV R1, #msg_remaining_text
      STR R1, .WriteString
      STR R0, .WriteUnsignedNum
      MOV R1, #msg_remaining_end
      STR R1, .WriteString
// =====================
// HUMAN TURN
// =====================
      MOV R1, #msg_prompt_prefix
      STR R1, .WriteString
      MOV R1, #player_name
      STR R1, .WriteString
      MOV R1, #msg_prompt_suffix
      STR R1, .WriteString
human_input:
      LDR R2, .InputNum
      CMP R2, #1
      BLT human_input
      CMP R2, #7
      BGT human_input
      CMP R2, R0
      BGT human_input
      SUB R0, R0, R2
      BL draw_matchsticks
      CMP R0, #1
      BEQ human_wins
      CMP R0, #0
      BEQ draw_game
// =====================
// COMPUTER TURN
// =====================
      MOV R1, #msg_computer_turn
      STR R1, .WriteString
computer_pick:
      LDR R2, .Random
      AND R2, R2, #7
      CMP R2, #0
      BEQ computer_pick
      CMP R2, R0
      BGT computer_pick
      SUB R0, R0, R2
      BL draw_matchsticks
      CMP R0, #1
      BEQ computer_wins
      CMP R0, #0
      BEQ draw_game
      B game_loop
// =====================
// END STATES
// =====================
human_wins:
      BL clear_screen
      BL draw_win_flag
      MOV R1, #msg_win_prefix
      STR R1, .WriteString
      MOV R1, #player_name
      STR R1, .WriteString
      MOV R1, #msg_win_suffix
      STR R1, .WriteString
      B ask_replay
computer_wins:
      BL clear_screen
      BL draw_lose_flag
      MOV R1, #msg_lose_prefix
      STR R1, .WriteString
      MOV R1, #player_name
      STR R1, .WriteString
      MOV R1, #msg_lose_suffix
      STR R1, .WriteString
      B ask_replay
draw_game:
      BL clear_screen
      BL draw_draw_flag
      MOV R1, #msg_draw
      STR R1, .WriteString
// =====================
// REPLAY
// =====================
ask_replay:
      MOV R1, #msg_replay
      STR R1, .WriteString
      MOV R1, #replay_input
      STR R1, .ReadString
      LDR R2, replay_input
      CMP R2, #121      // 'y'
      BEQ restart_game
      CMP R2, #110      // 'n'
      BEQ end_program
      B ask_replay
end_program:
      HALT
// ==================================================
// STAGE 4 : GRAPHICS (BAR DURING PLAY)
// ==================================================
draw_matchsticks:
      PUSH {R1-R5, LR}
      MOV R1, #.PixelScreen
// Clear screen to WHITE
      MOV R3, #0
dm_clear:
      CMP R3, #12288
      BEQ dm_baseline
      MOV R2, #0x00FFFFFF
      STR R2, [R1+R3]
      ADD R3, R3, #4
      B dm_clear
// Draw GREY baseline
dm_baseline:
      MOV R2, #0x00808080
      MOV R3, #256
      MOV R5, #0
dm_base_loop:
      CMP R5, #64
      BEQ dm_colour
      STR R2, [R1+R3]
      ADD R3, R3, #4
      ADD R5, R5, #1
      B dm_base_loop
// Choose colour
dm_colour:
      CMP R0, #3
      BGT dm_check_yellow
      MOV R2, #0x00FF0000 // RED
      B dm_bar
dm_check_yellow:
      CMP R0, #10
      BGT dm_green
      MOV R2, #0x00FFFF00 // YELLOW
      B dm_bar
dm_green:
      MOV R2, #0x0000FF00 // GREEN
// Draw multi‑row bar
dm_bar:
      MOV R3, #512      // Row 2
      MOV R5, #0
      MOV R4, R0
dm_row1:
      CMP R4, #0
      BEQ dm_done
      CMP R5, #64
      BEQ dm_row2
      STR R2, [R1+R3]
      ADD R3, R3, #4
      ADD R5, R5, #1
      SUB R4, R4, #1
      B dm_row1
dm_row2:
      MOV R3, #768      // Row 3
dm_row2_loop:
      CMP R4, #0
      BEQ dm_done
      STR R2, [R1+R3]
      ADD R3, R3, #4
      SUB R4, R4, #1
      B dm_row2_loop
dm_done:
      POP {R1-R5, LR}
      RET
// ==================================================
// END‑STATE FLAG ROUTINES
// ==================================================
clear_screen:
      PUSH {R1-R3, LR}
      MOV R1, #.PixelScreen
      MOV R3, #0
cs_loop:
      CMP R3, #12288
      BEQ cs_done
      MOV R2, #0x00FFFFFF
      STR R2, [R1+R3]
      ADD R3, R3, #4
      B cs_loop
cs_done:
      POP {R1-R3, LR}
      RET
draw_win_flag:
      MOV R2, #0x0000FF00 // GREEN
      B draw_flag
draw_lose_flag:
      MOV R2, #0x00FF0000 // WHITE
      B draw_flag
draw_draw_flag:
      MOV R2, #0x00808080 // GREY
draw_flag:
      PUSH {R1-R5, LR}
      MOV R1, #.PixelScreen
      MOV R3, #5120     // Row 20
      MOV R4, #8        // Height
flag_row:
      MOV R5, #0
flag_col:
      CMP R5, #64
      BEQ next_flag_row
      STR R2, [R1+R3]
      ADD R3, R3, #4
      ADD R5, R5, #1
      B flag_col
next_flag_row:
      ADD R3, R3, #0
      SUB R4, R4, #1
      CMP R4, #0
      BGT flag_row
      POP {R1-R5, LR}
      RET
// ==================================================
// DATA
// ==================================================
msg_enter_name: .ASCIZ "Please enter your name:\n"
msg_enter_count: .ASCIZ "How many matchsticks (10-100)?\n"
msg_player_prefix: .ASCIZ "\nPlayer "
msg_remaining_text: .ASCIZ ", there are "
msg_remaining_end: .ASCIZ " matchsticks remaining\n"
msg_prompt_prefix: .ASCIZ "Player "
msg_prompt_suffix: .ASCIZ ", how many do you want to remove (1-7)? "
msg_computer_turn: .ASCIZ "\nComputer Player’s turn\n"
msg_win_prefix: .ASCIZ "\nPlayer "
msg_win_suffix: .ASCIZ ", YOU WIN!\n"
msg_lose_prefix: .ASCIZ "\nPlayer "
msg_lose_suffix: .ASCIZ ", YOU LOSE!\n"
msg_draw: .ASCIZ "\nIt's a draw!\n"
msg_replay: .ASCIZ "\nPlay again (y/n) ? "
      .ALIGN 4
player_name: .BLOCK 64
initial_count: .WORD 0
replay_input: .WORD 0

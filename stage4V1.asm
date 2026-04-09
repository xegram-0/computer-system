// ==================================================
// MATCHSTICKS GAME
// Stages 1, 2, 3, 4 + Replay (FINAL ARMlite version)
// ==================================================
//
// Registers:
// R0 - remaining matchsticks
// R1 - string address / pixel base
// R2 - amount taken / colour
// R3 - byte offset
// R4 - temp address
// R5 - matchstick counter
// R6 - temp
// R7 - temp
// =====================
// STAGE 1 : SETUP
// =====================
// Ask for player name
      MOV R1, #msg_enter_name
      STR R1, .WriteString
      MOV R1, #player_name
      STR R1, .ReadString
// Ask for starting matchsticks (10–100)
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
// "Player <name>, there are <X> matchsticks remaining"
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
// Prompt
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
      MOV R1, #msg_win_prefix
      STR R1, .WriteString
      MOV R1, #player_name
      STR R1, .WriteString
      MOV R1, #msg_win_suffix
      STR R1, .WriteString
      B ask_replay
computer_wins:
      MOV R1, #msg_lose_prefix
      STR R1, .WriteString
      MOV R1, #player_name
      STR R1, .WriteString
      MOV R1, #msg_lose_suffix
      STR R1, .WriteString
      B ask_replay
draw_game:
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
// STAGE 4 : GRAPHICS (BOOK-CORRECT, MID-RES)
// ==================================================
// Mid-res screen: 64 x 48 pixels
// Pixel memory: 64 * 48 * 4 = 12288 bytes
// Each matchstick = 1 horizontal pixel
// ==================================================
draw_matchsticks:
      PUSH {R1-R5, LR}
      MOV R1, #.PixelScreen // Base of framebuffer
// ---------- Clear screen ----------
      MOV R3, #0        // Byte offset
clear_loop:
      CMP R3, #12288    // CORRECT LIMIT (64*48*4)
      BEQ draw_bar
      MOV R2, #0        // Black
      STR R2, [R1+R3]
      ADD R3, R3, #4
      B clear_loop
// ---------- Draw horizontal bar ----------
draw_bar:
      MOV R2, #.green   // Bar colour
      MOV R3, #512      // Start at row 2 (2 * 256 bytes)
      MOV R5, #0        // Counter
bar_loop:
      CMP R5, R0
      BEQ done
      CMP R5, #64       // Do not exceed screen width
      BEQ done
      STR R2, [R1+R3]
      ADD R3, R3, #4    // Move right one pixel
      ADD R5, R5, #1
      B bar_loop
done:
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

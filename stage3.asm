// ==================================================
// MATCHSTICKS GAME
// Stages 1, 2, 3 + Replay (Refactored & Clean)
// ==================================================
// Registers
// R0 : remaining matchsticks
// R1 : string address
// R2 : number taken
// R3 : temp
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
// GAME (with replay)
// =====================
restart_game:
      LDR R0, initial_count
game_loop:
// "Player <name>, there are <X> matchsticks remaining"
      MOV R1, #msg_player_prefix
      STR R1, .WriteString
      MOV R1, #player_name
      STR R1, .WriteString
      MOV R1, #msg_remaining_text
      STR R1, .WriteString
      STR R0, .WriteUnsignedNum
      MOV R1, #msg_newline
      STR R1, .WriteString
// =====================
// HUMAN TURN
// =====================
// "Player <name>, how many do you want to remove (1-7)?"
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
// REPLAY LOGIC
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
// DATA SECTION
// ==================================================
// ----- Setup -----
msg_enter_name: .ASCIZ "Please enter your name:\n"
msg_enter_count: .ASCIZ "How many matchsticks (10-100)?\n"
// ----- Status -----
msg_player_prefix: .ASCIZ "\nPlayer "
msg_remaining_text:.ASCIZ ", there are "
msg_newline: .ASCIZ " matchsticks remaining\n"
// ----- Prompts -----
msg_prompt_prefix: .ASCIZ "Player "
msg_prompt_suffix: .ASCIZ ", how many do you want to remove (1-7)? "
msg_computer_turn: .ASCIZ "\nComputer Player’s turn\n"
// ----- End messages -----
msg_win_prefix: .ASCIZ "\nPlayer "
msg_win_suffix: .ASCIZ ", YOU WIN!\n"
msg_lose_prefix: .ASCIZ "\nPlayer "
msg_lose_suffix: .ASCIZ ", YOU LOSE!\n"
msg_draw: .ASCIZ "\nIt's a draw!\n"
// ----- Replay -----
msg_replay: .ASCIZ "\nPlay again (y/n) ? "
      .ALIGN 4
player_name: .BLOCK 64
initial_count: .WORD 0
replay_input: .WORD 0

// =======================================
// Stage 1 + Stage 2 : Matchsticks Game
// =======================================
// R0 : remaining matchsticks
// R1 : message / string address
// R2 : number to remove
// ---------- Stage 1 : Setup ----------
// Ask for player name
      MOV R1, #msg_name
      STR R1, .WriteString
// Read player name
      MOV R1, #p1_name
      STR R1, .ReadString
// Ask for number of matchsticks (10–100)
get_count:
      MOV R1, #msg_count
      STR R1, .WriteString
      LDR R0, .InputNum
      CMP R0, #10
      BLT get_count
      CMP R0, #100
      BGT get_count
// Print required confirmation
      MOV R1, #msg_player
      STR R1, .WriteString
      MOV R1, #p1_name
      STR R1, .WriteString
      MOV R1, #msg_matches
      STR R1, .WriteString
      STR R0, .WriteUnsignedNum
// ---------- Stage 2 : Single Player Game ----------
game_loop:
// Print remaining matchsticks
      STR R0, .WriteUnsignedNum
      MOV R1, #msg_remaining
      STR R1, .WriteString
// Prompt for removal
      MOV R1, #msg_prompt
      STR R1, .WriteString
input_loop:
      LDR R2, .InputNum
      CMP R2, #1
      BLT input_loop
      CMP R2, #7
      BGT input_loop
      CMP R2, R0
      BGT input_loop
// Update matchsticks
      SUB R0, R0, R2
// Check for game over
      CMP R0, #0
      BEQ game_over
      B game_loop
game_over:
      MOV R1, #msg_game_over
      STR R1, .WriteString
      HALT
// =======================================
// Data Section
// =======================================
// Stage 1 messages
msg_name: .ASCIZ "Please enter your name:\n"
msg_count: .ASCIZ "How many matchsticks (10-100)?\n"
msg_player: .ASCIZ "Player 1 is "
msg_matches: .ASCIZ "\nMatchsticks: "
// Stage 2 messages
msg_remaining: .ASCIZ " matchsticks remaining\n"
msg_prompt: .ASCIZ "How many do you want to remove (1-7)? "
msg_game_over: .ASCIZ "Game Over\n"
      .ALIGN 4
p1_name: .BLOCK 64

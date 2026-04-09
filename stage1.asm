// =======================
// Stage 1 – Game Setup
// =======================
// R0 : matchsticks
// R1 : message / string address
// Ask for player name
      MOV R1, #msg_name
      STR R1, .WriteString
// Read player name into memory
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
// ---------- Output required messages ----------
// Line 1: Player 1 is <name>
      MOV R1, #msg_player
      STR R1, .WriteString
      MOV R1, #p1_name
      STR R1, .WriteString
// Line 2: Matchsticks: <number>
      MOV R1, #msg_matches
      STR R1, .WriteString
      STR R0, .WriteUnsignedNum
      HALT
// =======================
// Data
// =======================
msg_name: .ASCIZ "Please enter your name:\n"
msg_count: .ASCIZ "How many matchsticks (10-100)?\n"
msg_player: .ASCIZ "Player 1 is "
msg_matches: .ASCIZ "\nMatchsticks: "
      .ALIGN 4
p1_name: .BLOCK 64

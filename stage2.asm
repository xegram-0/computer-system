; Student: Hong Nhan Nguyen
; ID: 102632476
; Assignment 2: Matchsticks
; Stage 2: Single player input
;
; Assigning registers
; R0: remaining matchsticks
; R1: message
; R2: number of matchsticks to be removed
;
; Achieved:
; Print remaining matchsticks
; Prompt for removing matchsticks
; Check logic of removing matchsticks from 1 to 7 inclusively
; Update remaining matchsticks
; Game over message
;
; Used resources: Lecture week 8, lab 8 and online book chapter 3
;
; Stage 1
; Player name getter
      MOV R1, #msg_name
      STR R1, .WriteString
      MOV R1, #p1_name
      STR R1, .ReadString
; Matchsticks getter
get_count:
      MOV R1, #msg_count
      STR R1, .WriteString
      LDR R0, .InputNum
      CMP R0, #10
      BLT get_count     ; If < 10
      CMP R0, #100
      BGT get_count     ; If > 100
; Print message
      MOV R1, #msg_player
      STR R1, .WriteString
      MOV R1, #p1_name
      STR R1, .WriteString
      MOV R1, #msg_matches
      STR R1, .WriteString
      STR R0, .WriteUnsignedNum
; Stage 2
game_loop:
; Print remaining matchsticks
      STR R0, .WriteUnsignedNum
      MOV R1, #msg_remaining
      STR R1, .WriteString
; Prompt for removal
      MOV R1, #msg_prompt
      STR R1, .WriteString
input_loop:
      LDR R2, .InputNum
      CMP R2, #1
      BLT input_loop    ; If < 1
      CMP R2, #7
      BGT input_loop    ; If > 7
      CMP R2, R0
      BGT input_loop    ; If input > remaining
; Update matchsticks
      SUB R0, R0, R2    ; Update R0: remaining matchsticks
; Check for game over
      CMP R0, #0        ; Gameover condition
      BEQ game_over
      B game_loop
game_over:
      MOV R1, #msg_game_over
      STR R1, .WriteString
      HALT
; Assigning variables
; Stage 1 messages
msg_name: .ASCIZ "Please enter your name:\n"
msg_count: .ASCIZ "How many matchsticks (10-100)?\n"
msg_player: .ASCIZ "Player 1 is "
msg_matches: .ASCIZ "\nMatchsticks: "
; Stage 2 messages
msg_remaining: .ASCIZ " matchsticks remaining\n"
msg_prompt: .ASCIZ "How many do you want to remove (1-7)? "
msg_game_over: .ASCIZ "Game Over\n"
; Ensure safe, word-aligned memory and later use of STR and LDR
; Headache prevention
; 64 bytes as name is often short and divisible by 4
; Save a space to store player name and prevent overwrite
      .ALIGN 4
p1_name: .BLOCK 64

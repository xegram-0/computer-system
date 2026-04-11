; Student: Hong Nhan Nguyen
; ID: 102632476
; Assignment 2: Matchsticks
; Stage 1: Game Setup
;
; Assigning registers
; R0: matchsticks
; R1: message
;
; Achieved:
; Ask for player name
; Ask for matchsticks number from 10 to 100 inclusively
; Print message after inputs
;
; Used resources: Lecture week 8, lab 8 and online book chapter 3
;
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
      HALT
; Assigning variables
msg_name: .ASCIZ "Please enter your name:\n"
msg_count: .ASCIZ "How many matchsticks (10-100)?\n"
msg_player: .ASCIZ "Player 1 is "
msg_matches: .ASCIZ "\nMatchsticks: "
; Ensure safe, word-aligned memory and later use of STR and LDR
; Headache prevention
; 64 bytes as name is often short and divisible by 4
; Save a space to store player name and prevent overwrite
      .ALIGN 4
p1_name: .BLOCK 64

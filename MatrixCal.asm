.code
org 100h

call main

ret

main PROC
  ; Define matrices as 3x3
  MOV ra, 3
  MOV ca, 3
  MOV rb, 3
  MOV cb, 3

  ; 1. Addition
  CALL clear_matrixC
  CALL addition
  LEA DX, add_res_msg
  CALL print_string
  MOV AL, 3
  MOV AH, 3
  CALL print_matrix

  ; 2. Subtraction
  CALL clear_matrixC
  CALL subtraction
  LEA DX, sub_res_msg
  CALL print_string
  MOV AL, 3
  MOV AH, 3
  CALL print_matrix

  ; 3. Multiplication
  CALL clear_matrixC
  CALL multiply
  LEA DX, mul_res_msg
  CALL print_string
  MOV AL, 3
  MOV AH, 3
  CALL print_matrix

  ; 4. Scalar Multiplication (Matrix A * Scalar 2)
  CALL clear_matrixC
  MOV SI, scalar
  CALL scalar_multiply
  LEA DX, scalar_res_msg
  CALL print_string
  MOV AL, 3
  MOV AH, 3
  CALL print_matrix

  ret
main ENDP

multiply PROC
  PUSHA
  MOV BX, 0
  MOV CX, ra
X1:
  MOV SI, 0
  PUSH CX
  MOV CX, cb
X2:
  MOV DI, 0
  MOV BP, 0
  PUSH CX
  MOV CX, ca
X3:
  MOV AX, matrixA[BX +  DI]
  MUL WORD PTR matrixB[BP +  SI]
  ADD WORD PTR matrixC[BX +  SI], AX
  ADD DI, 2
  ADD BP, 6
  LOOP X3
  POP CX
  ADD SI, 2
  LOOP X2
  POP CX
  ADD BX, 6
  LOOP X1
  POPA
  ret
multiply ENDP

addition PROC
  MOV BX, 0
  MOV CX, ra
L1:
  MOV SI, 0
  PUSH CX
  MOV CX, ca
L2:
  MOV DX, matrixA[BX +  SI]
  ADD DX, matrixB[BX +  SI]
  MOV matrixC[BX +  SI], DX
  ADD SI, 2
  LOOP L2
  POP CX
  ADD BX, 6
  LOOP L1
  ret
addition ENDP

subtraction PROC
  MOV BX, 0
  MOV CX, ra
L3:
  MOV SI, 0
  PUSH CX
  MOV CX, ca
L4:
  MOV DX, matrixA[BX +  SI]
  SUB DX, matrixB[BX +  SI]
  MOV matrixC[BX +  SI], DX
  ADD SI, 2
  LOOP L4
  POP CX
  ADD BX, 6
  LOOP L3
  ret
subtraction ENDP

scalar_multiply PROC
  MOV BX, 0
  MOV CX, ra
SM1:
  MOV SI, 0
  PUSH CX
  MOV CX, ca
SM2:
  MOV AX, matrixA[BX + SI]
  MUL scalar
  MOV matrixC[BX + SI], AX
  ADD SI, 2
  LOOP SM2
  POP CX
  ADD BX, 6
  LOOP SM1
  ret
scalar_multiply ENDP

clear_matrixC PROC
  MOV DI, 0
  MOV CX, 100
CLRMEM:
  MOV WORD PTR matrixC[DI], 0
  ADD DI, 2
  LOOP CLRMEM
  RET
clear_matrixC ENDP

print_matrix PROC
  MOV BX, 0
  MOV CX, 0
  MOV CL, AL
O1:
  MOV SI, 0
  PUSH CX
  MOV CX, 0
  MOV CL, AH
O2:
  PUSH AX
  MOV AX, matrixC[BX +  SI]
  CALL print_number
  MOV DL, 9
  MOV AH, 2
  INT 21h
  ADD SI, 2
  POP AX
  LOOP O2
  CALL newline
  POP CX
  ADD BX, 6
  LOOP O1
  ret
print_matrix ENDP

newline PROC
  PUSHA
  LEA DX, newline_msg
  CALL print_string
  POPA
  ret
newline ENDP

print_string PROC
  PUSH AX
  MOV AH, 9
  INT 21h
  POP AX
  ret
print_string ENDP

print_number PROC
  PUSH CX
  MOV CX, 0
  CMP AX, 0
  JGE print_positive
  PUSH AX
  MOV AH, 2
  MOV DL, '-'
  INT 21h
  POP AX
  NEG AX
print_positive:
  MOV DX, 0
  DIV ten
  ADD DX, 48
  PUSH DX
  INC CX
  CMP AX, 0
  JNZ print_positive
PN:
  POP DX
  PUSH AX
  MOV AH, 2
  INT 21h
  POP AX
  LOOP PN
  POP CX
  ret
print_number ENDP

.data
matrixA DW 1, 2, 3
        DW 4, 5, 6
        DW 7, 8, 9

matrixB DW 9, 8, 7
        DW 6, 5, 4
        DW 3, 2, 1

matrixC DW 100 DUP(?)

ra DW 3
ca DW 3
rb DW 3
cb DW 3

scalar DW 2
ten DW 10
newline_msg db 10, 13, '$'
add_res_msg     db "Addition result (A + B):", 10, 13, '$'
sub_res_msg     db "Subtraction result (A - B):", 10, 13, '$'
mul_res_msg     db "Multiplication result (A * B):", 10, 13, '$'
scalar_res_msg  db "Scalar Multiplication result (A * 2):", 10, 13, '$'

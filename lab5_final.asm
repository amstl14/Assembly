**************************************
*
* Name: Art Martin
* ID: 12402146
* Date: 4/20/15
* Lab5
*
* Program description: This program, like lab 3/4, the program will get the 
* factorial for the numbers in the given table. This will be done using a 
* subroutine that is completely transparent.
*
* Pseudocode of Main Program:
*
* int table[];
* int NFAC[];
* #define Sentinel $FF
* int main()
* {
*   int *pointer1, *pointer2;
*   pointer1 = &table[0];
*   pointer2 = &NFAC[0];
*
*   while(pointer1->item != Sentinel)
*   {
*     pointer2->item = Sub(pointer1->item);
*     pointer1++;
*     pointer2++;
*     pointer2++;
*   }
*     return 0;
* }
*
* Pseudocode of Subroutine:
*
* int Sub(int num)
* {
*   int result, count1 = 1, count2 = 0, temp;
*   
*   while(count2 <= num)
*   {
*     count1 = 1;
*     temp = result;
*     while(count1 < count2)
*     {
*       result = result + temp;
*       count1++;
*     }
*     count2++;
*   }
*   return result;
* }
**************************************


* start of data section

	ORG	$B000
N	FCB 	0, 1, 2, 3, 4, 5, 6, 7, 8, $FF
SENTIN	EQU 	$FF

	ORG	$B010
NFAC	RMB 18



* define any variables that your MAIN program might need here
* REMEMBER: Your subroutine must not access any of the main
* program variables including N and NFAC.



	ORG	$C000
	LDS	#$01FF	*initialize stack pointer

* start of your main program
	LDX	#N	*table to x-reg
	LDY	#NFAC	*NFAC to y-reg
WHL1	LDAA	0,X
	CMPA	#SENTIN	*while(count2 <= num)
	BEQ	DONE
	JSR	SUB	*jump to subroutine
	PULA
	PULB	
	STD	0,Y
	INX	*pointer1++
	INY	*pointer2++
	INY	*pointer2++
	BRA	WHL1
DONE	BRA	DONE
* NOTE: NO STATIC VARIABLES ALLOWED IN SUBROUTINE
* AND SUBROUTINE MUST BE TRANSPARENT TO MAIN PROGRAM

	ORG	$D000
* start of your subroutine
SUB	DES *open 2 holes for return param.
	DES
	PSHX *push all registers onto stack
	PSHY
	PSHA
	PSHB
	TPA *contents of cc go to a-reg
	PSHA
	DES *hole for X_L
	DES *hole for X_H	
	DES *hole for Y_L
	DES	*hole for Y_H
	DES	*hole for A
	DES	*hole for B
	DES	*hole for CC
	TSX *get variable address
	LDAA	9,X
	STAA	0,X
	CLRA
	STAA	3,X *int count2 = 0
	LDD	#$0001
	STD	5,X *int result = 1
WL2 	LDAA 	3,X *while(count2 <= num)
	CMPA 0,X
	BHI	ENDWL2
	LDAB 	#1
	STAB 	4,X *count1 = 1
	LDD 	5,X
	STD 	1,X *temp = result
WL3 	LDAA 	4,X *while(count1<count2)
	CMPA	3,X
	BHS 	ENDWL3
	LDD 	5,X *result goes to d reg
	ADDD	1,X *result = result + temp
	STD 	5,X
	INC 	4,X *count1++
	BRA 	WL3
ENDWL3	INC	3,X *count2++
	BRA 	WL2
ENDWL2	LDY	16,X *move RA up 2 positions in stack
	STY 	14,X
	LDD 	5,X *move result to the bottom of the stack
	STD 	16,X
	LDAB 	#7 *number of variable holes
	ABX
	TXS *close variable holes
	PULA	*pull registers off the stack
	TAP
	PULB	
	PULA
	PULY
	PULX
	RTS		*return from subroutine

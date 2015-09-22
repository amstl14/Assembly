*************************************
* Name: Art Martin
* ID: 12402146
* Date: 4/7/15
* LAB4
*
* Program description:
*
* This program, like lab 3, the program will get 
* the factorial for the numbers in a given table.
* This will be done using a subroutine rather than in main.
*
* Psuedocode for Main Program:
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
*     pointer2 = Sub(table[]);
*     pointer1++;
*     pointer2++;
*     pointer2++;
*   }
*     return 0;
* }
*
* Psuedocode for Subroutine:
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
*************************************

* start of data section

	ORG	$B000
N	FCB	0,1,2,3,4,5,6,7,8,$FF
SENTIN	EQU	$FF

	ORG	$B010
NFAC	RMB	18

	ORG	$C000
	LDS	#$01FF

* start of your main program

	LDX	#N	*table to x-reg
	LDY	#NFAC	*NFAC to y-reg
WHILE1	LDAA	0,X
	CMPA	#SENTIN 	*while(pointer1->item != $FF)
	BEQ	DONE
	JSR	SUB	*jump to subroutine
	PULA
	PULB
	STD	0,Y
	INX		*pointer1++;
	INY		*pointer2++;
	INY		*pointer2++;
	BRA	WHILE1
DONE 	BRA	DONE

* define any variables that your subroutine might need here

RESULT	RMB	2
COUNT1	RMB	1
COUNT2	RMB	1
TEMP	RMB	2
N_TEMP	RMB	1
TEMP2	RMB	2

	ORG	$D000

* start of your subroutine

SUB	STAA	N_TEMP
	CLR	COUNT2	*int count2 = 0;
	LDD	#$001
	STD	RESULT	*int result = 1; 
WHILE2	LDAA	COUNT2	*while(count2 <= num);
	CMPA	N_TEMP
	BHI	ENDWHL2
	LDAB	#1
	STAB	COUNT1	*count1 = 1;
	LDD	RESULT	
	STD 	TEMP	*temp = result;
WHILE3	LDAA	COUNT1	*while(count1<count2);
	CMPA	COUNT2
	BHS	ENDWHL3
	LDD 	RESULT	*result goes to d-reg
	ADDD	TEMP	*result = result + temp;
	STD	RESULT
	INC	COUNT1	*count1++;
	BRA	WHILE3
ENDWHL3	INC	COUNT2	*count2++;
	BRA	WHILE2	
ENDWHL2	STX	TEMP2	*temp var used to store x-reg contents
	PULX		*pull off the return address
	LDD	RESULT	*d-reg contents go to result
	PSHB		*push results low byte onto stack
	PSHA		*push results high byte onto stack
	PSHX		*push return address onto stack
	LDX	TEMP2	
	RTS	
NTEST 5
NTAPS EQU 3
NCOEFFS EQU 3

;=========================

		ORG Y:$0
fir_coeffs		equ * 
		dc		0.75
		dc		0.5
		dc		0.25
		ORG Y:$1000
ans DS NTEST+NCOEFFS-1
;=========================
		ORG	X:$0
x_taps DS	NTAPS
		ORG X:$1000
x_test equ * 
		dc	0.25
		dc 	0
		dc 	0
		dc 	0
		dc 	0
;=========================

		ORG P:$E000
main 
;--------init circular buffers-------
		move #x_taps,r0 ;pointer init
		move #fir_coeffs,r4
		
		move #NTAPS-1,m0 ;set buffer module
		move #NTAPS-1,m4
;=========================

;--------init test pointers and asnwer pointers-------
		move #x_test,r1
		move #ans,r2
		
;--------init circular buffers-------

		DO #NTEST+NCOEFFS-1,END1
		
		move x:(r1)+,x0 ;from x_test to x0

		clr a x0,x:(r0)+ y:(r4)+,y0 ;r0 points to xtaps
		rep #NTAPS-1
		mac x0,y0,a x:(r0)+,x0 y:(r4),y0
		mac x0,y0,a (r0)-
		
		move a,y:(r2)+
END1
		end main
 datasg SEGMENT PARA 'data'
  n DW 500
  dizi DB 0,1,1, 498 DUP(0)
  print_array DB 0,0,0
 datasg ENDS
 
 stacksg SEGMENT STACK PARA 'stack'
   DW 50 DUP(?)
 stacksg ENDS
 
 codesg SEGMENT PARA 'code'
 ASSUME CS: codesg, SS: stacksg, DS: datasg
 
	MAIN PROC FAR
      PUSH DS
	  XOR AX,AX
	  PUSH AX
	  MOV AX,datasg
	  MOV DS,AX
	  
      PUSH n
	  CALL FAR PTR DNUM
	  
	  CALL FAR PTR PRINTINT

	RETF
	MAIN ENDP
 
 
 
 
 ;𝐷(𝐷(𝑛−1))+𝐷(𝑛−1−𝐷(𝑛−2)),𝑛≥3
 ; D(5) = D(D(4))+D(4-D(3))
 ; D(4) = D(D(3))+D(3-D(2))
 ; D(3)  = D(D(2))+D(2-D(1))
	DNUM PROC FAR
        PUSH BP
		MOV BP,SP
		PUSH SI
		PUSH BX
		PUSH AX
		PUSH DI
		PUSH DX
		
		XOR BH,BH
		XOR AH,AH
		XOR DH,DH
		
		MOV SI,[BP+6]; SI = n
		
		CMP SI,0
		JE L0
		CMP SI,1
		JE L1
		CMP SI,2
		JE L1
		
		JMP LBL
		
	L0: 
	    XOR AX,AX
	    MOV [BP+6],AX
	    JMP EXIT
    
	L1: MOV AX,1
	    MOV [BP+6],AX
	    JMP EXIT
	
		
    LBL:
		SUB SI,2	; SI= n-2
	    CMP SI,2
		JBE L3		; halihazırda D(n-2) değeri dizide mevcut demektir
		
		MOV AL,dizi[SI]
		CMP AL,0	; Eğer 0  eşitse bu durumda n-2 indexindeki değer henüz bulunmamış demektir
		JE L4
		
		; Eğer buraya inmişse AL'de şu an D(n-2)  değeri var demektir 
        JMP L5
        
	L3: MOV AL,dizi[SI]; AL = D(n-2)
	    JMP L5
		
	L4: PUSH SI 	            ; D(n-2) hesaplatacağız	
		CALL FAR PTR DNUM
		POP AX 					; AL'de şu an D(n-2)
		MOV dizi[SI],AL
		
		; Şu anda AL = 𝐷(𝑛−2)
	L5:	INC SI		; SI = n-1
	    MOV DI, SI 	; DI = n-1       SI değeri kaybolacağı için L8 Label'ında kullanmak üzere SI değerini DI'ya kopyaladık
	    SUB SI,AX 	; SI = n-1-D(n-2)
		CMP SI,2
		JBE L6
		
		MOV AL,dizi[SI]
		CMP AL,0
		JE L7
		
		;Eğer buraya inmişse AL = D(n-1-D(n-2))
		JMP L8
		
	L6: MOV AL, dizi[SI]; AL = D(n-1-D(n-2))
        JMP L8
	
	L7: PUSH SI
	    CALL FAR PTR DNUM
		POP AX; AL = D(n-1-D(n-2))
		MOV dizi[SI],AL
		
		; DI = n-1
	L8: CMP DI,2
		JBE L9
		
		MOV BL, dizi[DI]
		CMP BL,0
		JE L10
		
		;Eğer buraya inmişse BL = D(n-1)
		JMP L11
		
	L9: 
		MOV BL, dizi[DI]
		JMP L11
		
	L10:
		PUSH DI
        CALL FAR PTR DNUM
		POP BX; BL = D(n-1)
	    MOV dizi[DI],BL
		
	L11: CMP BL,2
		 JBE L12
		
		MOV DL, dizi[BX]
		CMP DL,0
		JE L13
		
		;Eğer buraya inmişse DL = D(D(n-1))
		JMP L14
		
	L12: 
		MOV DL, dizi[BX]
		JMP L14
	
	L13:
		PUSH BX
        CALL FAR PTR DNUM
		POP DX; DL = D(D(n-1))
		MOV dizi[BX],DL
		
	L14: ;  DX = 𝐷(𝐷(𝑛−1)), AX= 𝐷(𝑛−1−𝐷(𝑛−2))
		ADD AX,DX ; AX = 𝐷(𝐷(𝑛−1))+𝐷(𝑛−1−𝐷(𝑛−2))
		MOV [BP+6],AX
		INC DI ; DI = n
		MOV dizi[DI],AL

		
	
		
	EXIT : 
		POP DX
		POP DI
		POP AX
		POP BX
		POP SI
		POP BP

	    RETF 
	DNUM ENDP
	
	
	; 254               
	
	
	
	
     PRINTINT PROC FAR
	    PUSH BP
		MOV BP,SP
		PUSH AX
		PUSH SI
		PUSH DX
		PUSH BX
		PUSH CX
		
		MOV AX,[BP+6]
	 
	 
	 
	
   		XOR SI,SI
		XOR CX,CX
		MOV DX,AX
	
	LABEL1:
		CMP AL, 0
		JE LABEL2
		MOV BL, 10
		XOR AH,AH
		DIV BL
		MOV print_array[SI],AH;
		INC SI
    JMP LABEL1
         

	LABEL2 :
	    MOV CX,SI; SI = print_array dizisinin uzunluğunu göstermekte
		DEC SI   ; 
	LABEL3:
	    MOV DL,print_array[SI]
		DEC SI
		ADD DL, '0'
		MOV AH, 02H
		INT 21H
		LOOP LABEL3
		
		POP CX
		POP BX
		POP DX
		POP SI
		POP AX
		POP BP
    RETF 2
		PRINTINT ENDP
		
		
	
	 codesg ENDS
            END MAIN


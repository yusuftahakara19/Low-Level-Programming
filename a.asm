 datasg SEGMENT PARA 'data'
  n DW 10
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
 
 
 
 
 
	DNUM PROC FAR
	    PUSH BP
		MOV BP,SP
		PUSH AX ;n değerini tutacağız
		PUSH BX 
		PUSH DI
		
		MOV AX,[BP+6]
		
		CMP AX,0
		JE L0
		CMP AX,1
		JE L1
		CMP AX,2
		JE L1
		
		;D(n-1) bulunması
		DEC AX; AX = n-1
		PUSH AX
	    CALL FAR PTR DNUM
		POP BX ; BX = D(n-1)
		
		;D(D(n-1)) bulunması
		PUSH BX 
		CALL FAR PTR DNUM
		POP BX ; BX = D(D(n-1))
		
		DEC AX; AX= n-2
		PUSH AX
		CALL FAR PTR DNUM
		POP DI; DI = D(n-2)
		
		INC AX		; AX = n-1
		SUB AX,DI   ; AX = n-1-D(n-2)
        PUSH AX
        CALL FAR PTR DNUM
        POP AX ; AX = D(n-1-D(n-2))
        
        ADD AX,BX; AX =  D(D(n-1)) + D(n-1-D(n-2))
        MOV [BP+6],AX	
        JMP EXIT		
		
		

	L0: 
	    XOR AX,AX
	    MOV [BP+6],AX
	    JMP EXIT
    
	L1: MOV AX,1
	    MOV [BP+6],AX
	    JMP EXIT
		
		
	EXIT: 
	    POP DI
		POP BX
		POP AX
		POP BP
	    RETF 
	DNUM ENDP
	
	
	
	
	
	
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
			
			
			
			
			

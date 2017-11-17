
.x64
option literals:on
option frame:auto
option casemap:none
option stackbase:rbp
option win64:7

includelib kernel32.lib
ExitProcess PROTO :dword
printf      PROTO :ptr, :vararg

MyProc  PROTO dword :dword, :qword
MyProc2 PROTO :PTR
MyProc3 PROTO dword
MyProc4 PROTO
MyProc5 PROTO real4 :real4
MyProc6 PROTO byte :byte
MyProc7 PROTO dword :byte, :word, :dword, :qword, :real4, :qword
MyProc8 PROTO byte
MyProc9 PROTO real4 :byte, :word, :dword, :qword, :real4, :qword

.data

myVar  dd 11
myVar2 dq 21

.code

start:

	MyProc3()
	MyProc(10,20)
	MyProc(10,ADDR MyProc)
	MyProc2("this is a literal")

	.if( MyProc(10,20) == 30 )
	   xor eax,eax
	.endif

	.if( MyProc5(1.0) == FP4(2.0) )
	   xor eax,eax
	.endif

	.if ( MyProc6(7) == 7 )
	   xor eax,eax
	.endif

	MyProc(MyProc3(), 20)	
	MyProc(10, MyProc4())	
	MyProc(MyProc3(), MyProc4())
	MyProc(MyProc3(), MyProc2("stringy"))
	MyProc7( 10, 20, myVar, myVar2, 2.0, 30 )

	MyProc( MyProc( MyProc3(), 10 ), 20)	

	.if ( MyProc6( MyProc8() ) == 7 )
	   xor eax,eax
	.endif

	MyProc7( 10, 20, myVar, myVar2,	MyProc9( 10, 20, myVar, myVar2, 2.0, 30 ), 30 )

	MyProc7( 10, 
		 20, 
		 myVar, 
		 myVar2, 
		 2.0, 
		 30 )

	invoke ExitProcess,0

MyProc PROC dword FRAME aVar:DWORD, bVar:QWORD
   movsxd rax,aVar
   add rax,bVar
   ret
MyProc ENDP

MyProc2 PROC FRAME strPtr:PTR
   mov eax,10
   printf("a formatted string : %d \n", eax)
   printf(strPtr)
   ret
MyProc2 ENDP

MyProc3 PROC dword FRAME 
   mov eax,10
   ret
MyProc3 ENDP

MyProc4 PROC FRAME
   mov eax,20
   ret
MyProc4 ENDP

MyProc5 PROC real4 FRAME aVar:REAL4
   mov eax,1.0
   vmovd xmm1,eax
   vaddss xmm0,xmm0,xmm1
   ret
MyProc5 ENDP

MyProc6 PROC byte FRAME aVar:BYTE
   xor al,al
   add al,cl
   ret
MyProc6 ENDP

MyProc7 PROC dword FRAME aVar:byte, bVar:word, cVar:dword, dVar:qword, eVar:real4, fVar:qword
   mov eax,1
   ret
MyProc7 ENDP

MyProc8 PROC byte FRAME
   mov al,7
   ret
MyProc8 ENDP

MyProc9 PROC real4 FRAME aVar:byte, bVar:word, cVar:dword, dVar:qword, eVar:real4, fVar:qword
   LOADSS xmm0,2.5
   ret
MyProc9 ENDP

end start

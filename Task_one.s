	.file	"main.c"
	.intel_syntax noprefix
	.text
	.globl	max_length
	.section	.rodata
	.align 4
	.type	max_length, @object
	.size	max_length, 4
max_length:
	.long	10
	.globl	max_size
	.align 4
	.type	max_size, @object
	.size	max_size, 4
max_size:
	.long	214748
.LC0:
	.string	"You input a not number"
.LC1:
	.string	"You input too long number"
	.text
	.globl	inputNumber
	.type	inputNumber, @function
inputNumber:
	; пролог функции
	push	rbp
	mov	rbp, rsp
	
	push	rbx
	sub	rsp, 56
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -24[rbp], rax
	xor	eax, eax					; обнуление eax
	mov	rax, rsp
	mov	rbx, rax

	; переменная buf
	mov	eax, 10
	cdqe							; преобразование двойного слова в 8-ми байтовое
	sub	rax, 1
	mov	QWORD PTR -48[rbp], rax
	mov	eax, 10
	cdqe							; преобразование двойного слова в 8-ми байтовое
	mov	r8, rax
	mov	r9d, 0
	mov	eax, 10
	cdqe							; преобразование двойного слова в 8-ми байтовое
	mov	rsi, rax
	mov	edi, 0
	mov	eax, 10
	cdqe							; преобразование двойного слова в 8-ми байтовое
	mov	edx, 16
	sub	rdx, 1
	add	rax, rdx
	mov	esi, 16
	mov	edx, 0
	div	rsi
	imul	rax, rax, 16
	mov	rcx, rax
	and	rcx, -4096
	mov	rdx, rsp
	sub	rdx, rcx

.L2:								
	cmp	rsp, rdx
	je	.L3								; переход если равно
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	jmp	.L2
.L3:
	mov	rdx, rax
	and	edx, 4095
	sub	rsp, rdx
	mov	rdx, rax
	and	edx, 4095
	test	rdx, rdx					;проверяем число на знак
	je	.L4								; переход, если равно
	and	eax, 4095
	sub	rax, 8
	add	rax, rsp
	or	QWORD PTR [rax], 0
.L4:
	mov	rax, rsp
	add	rax, 0
	mov	QWORD PTR -40[rbp], rax
.L8:									            ;  цикл do while
	mov	rax, QWORD PTR -40[rbp]			; инициализация строки тем, что ввёл пользователь
	mov	rdi, rax
	mov	eax, 0							
	call	gets@PLT					         ; вызов функции gets

	mov	rax, QWORD PTR -40[rbp]
	mov	rdi, rax
	call	atol@PLT

	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 0		    	; сравнение 0-го элемента buf и 0
	jne	.L5								            ; (переход, если не равно) условный оператор if
	mov	rax, QWORD PTR -40[rbp]		  	; получение доступа к 0-му элементу
	movzx	eax, BYTE PTR [rax]		    	; копирует значение из buf в eax

	cmp	al, 48						          	; сравнение number и 0
	je	.L5								            ; (переход, если равно) если не равны, то переходишь дальше в else if

	lea	rax, .LC0[rip]				       	; узнать эффективный адресс
	mov	rdi, rax						          ; поместить в rax сообщение input a not number
	call	puts@PLT					          ; вывести сообщение на экран
	mov	BYTE PTR -49[rbp], 70			    ; поместить 'F' в is_correct

	jmp	.L6								            ; прыгнуть на проверу условия while
.L5:
	mov	rax, QWORD PTR -40[rbp]			  ; берём buf
	mov	rdi, rax
	call	strlen@PLT					        ; находим длину у buf

	cmp	rax, 10							          ; если длина > 10
	jbe	.L7								            ; переход по усиловию (меньше или равно) в else

	lea	rax, .LC1[rip]					      ; узнаём эффективный адресс сообщения
	mov	rdi, rax						          ; берём сообщение You input too long number.
	call	puts@PLT					          ; выводим сообщение не экран
	
	mov	BYTE PTR -49[rbp], 70				  ; поместить 'F' в is_correct
	jmp	.L6									          ; прыжок из условного оператора в проверку while 
.L7:										            ; else
	mov	BYTE PTR -49[rbp], 84				  ; поместить 'T' в is_correct
.L6:										            ; проверка цикла while
	cmp	BYTE PTR -49[rbp], 70				  ; сравнение значения с 'F'

	je	.L8									          ; переход если равно
	
	mov	rax, QWORD PTR -32[rbp]				; значение, которое надо вернуть
	mov	rsp, rbx

	mov	rdx, QWORD PTR -24[rbp]
	sub	rdx, QWORD PTR fs:40

	je	.L10								          ; переход если равно
	call	__stack_chk_fail@PLT

.L10:
	mov	rbx, QWORD PTR -8[rbp]				; возвращаем значение
	leave
	ret										            ; возврат в вызывающую подпрограмму
	
	.size	inputNumber, .-inputNumber
	.section	.rodata

.LC2:
	.string	"array[%d] = %ld, "
.LC3:
	.string	"\n"
	.text
	.globl	showArray
	.type	showArray, @function
showArray:
	; пролог функции
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32

	mov	QWORD PTR -24[rbp], rdi				; передача фактического параметра в формальный *array
	mov	QWORD PTR -32[rbp], rsi				; передача фактического параметра в формальный size
	mov	DWORD PTR -4[rbp], 0				  ; счётчик i
	jmp	.L12								          ; прыжок в цикл for
.L13:
	mov	eax, DWORD PTR -4[rbp]				; счётчик i поместили в eax
	cdqe									            ; преобразование двойного слова в 8-ми байтовое (i и size имеют разные размеры)
	
	lea	rdx, 0[0+rax*8]						    ; вычисление значения i
	mov	rax, QWORD PTR -24[rbp]				; получение адресса *array
	add	rax, rdx							        ; обращение к i-му элементу
	
	mov	rdx, QWORD PTR [rax]				  ; поместили в шаблон значение элемента
	mov	eax, DWORD PTR -4[rbp]				; поместили в шаблон значение i
	mov	esi, eax
	lea	rax, .LC2[rip]						    ; узнаём эффективный адрес сообщения
	mov	rdi, rax							        ; поместили сообщение в rdi

	mov	eax, 0
	call	printf@PLT						      ; вывели сообщение
	
	add	DWORD PTR -4[rbp], 1				  ; увелечение счётчика на 1
.L12:										            ; условие для цила for 
	mov	eax, DWORD PTR -4[rbp]				; взяли значение i
	cdqe									            ; преобразование двойного слова в 8-ми байтовое (i и size имеют разные размеры)
	cmp	QWORD PTR -32[rbp], rax				; сравнили i и size
	jg	.L13								          ; переход если больше				
	
	lea	rax, .LC3[rip]						    ; берём адрес сообщения
	mov	rdi, rax						        	; помещаем адрес в rdi
	call	puts@PLT						        ; печатаем сообщение
	
	nop										            ; задержка				
	leave									            ; выход из функции
	ret										            ; возврат в вызывающую подпрограмму
	
	.size	showArray, .-showArray
	.globl	countSize
	.type	countSize, @function
countSize:
	; пролог функции
	push	rbp
	mov	rbp, rsp


	mov	QWORD PTR -24[rbp], rdi				; *array
	mov	QWORD PTR -32[rbp], rsi				; Size

	mov	DWORD PTR -8[rbp], 0				  ; инициализация new_size нулём
	mov	DWORD PTR -4[rbp], 0				  ; инициализация i нулём
	
	jmp	.L15								          ; переход в цикл for
.L17:
	mov	eax, DWORD PTR -4[rbp]				; берём текущее значение i
	cdqe									            ; преобразуем двойное слово в 8-ми байтовое
	lea	rdx, 0[0+rax*8]						    ; вычисляем кол-во байт
	mov	rax, QWORD PTR -24[rbp]				; берём адрес array
	add	rax, rdx							        ; прибавляем нужное значение
	mov	rax, QWORD PTR [rax]				  ; берём нужный элемент
	
	test	rax, rax						        ; проверяем чило на знак
	jle	.L16								          ; переход если меньше или равно
	
	add	DWORD PTR -8[rbp], 1				  ; прибавляем к i единицу
.L16:
	add	DWORD PTR -4[rbp], 1				  ; прибавляем к new_size единицу
.L15:										; цикл for
	mov	eax, DWORD PTR -4[rbp]				; взяли i
	cdqe									            ; преобразование двойного слова в 8-ми байтовое (i и size имеют разные размеры)
	cmp	QWORD PTR -32[rbp], rax				; сравнили size и i
	jg	.L17								          ; переход если больше (знаковый)
	
	mov	eax, DWORD PTR -8[rbp]				; возвращаемое значение
	pop	rbp									          ; восстановление rbp
	ret										            ; вышли из функции в вызывающую подпрограмму
	
	.size	countSize, .-countSize
	.section	.rodata
.LC4:
	.string	"array[%d] ="
	.text
	.globl	inputArray
	.type	inputArray, @function
inputArray:									        ; ввод массива с клавиатуры
	; пролог функции
	push	rbp
	mov	rbp, rsp
	sub	rsp, 32

	mov	QWORD PTR -24[rbp], rdi				; *array
	mov	QWORD PTR -32[rbp], rsi				; size

	mov	DWORD PTR -12[rbp], 0				  ; инициализация i
	jmp	.L20								          ; переход на цикл for
.L21:
	mov	eax, DWORD PTR -12[rbp]				; берём значение i 
	mov	esi, eax
	lea	rax, .LC4[rip]						    ; взяли сообщение
	mov	rdi, rax
	mov	eax, 0
	call	printf@PLT						      ; напечатали сообщение

	mov	eax, 0
	call	inputNumber						      ; вызвали фукнкцию
	mov	QWORD PTR -8[rbp], rax				; получили значение из функции
	
	mov	eax, DWORD PTR -12[rbp]				; значение i 
	cdqe									            ; преобразование 
	lea	rdx, 0[0+rax*8]						    ; высчитываем нужный размер
	mov	rax, QWORD PTR -24[rbp]				; берём адресс array
	add	rdx, rax							        ; прибавляем нужное значение
	mov	rax, QWORD PTR -8[rbp]				; получаем необходимый элемент
	
	mov	QWORD PTR [rdx], rax				  ; присваиваеми текущему элементу buf

	add	DWORD PTR -12[rbp], 1				  ; увеличили счётчик i
.L20:										            ; условие для for
	mov	eax, DWORD PTR -12[rbp]			  ; берём i
	cdqe									            ; преобразование двойного слова в 8-ми байтовое
	cmp	QWORD PTR -32[rbp], rax				; сравнили i и size
	jg	.L21								          ; если условие верно, заходив в цикл
	
	nop										            ; задержка
	nop
	
	leave									            ; вышли из функции
	ret
	
	.size	inputArray, .-inputArray
	.globl	createNewArray
	.type	createNewArray, @function
createNewArray:

	; пролог функции
	push	rbp
	mov	rbp, rsp

	mov	QWORD PTR -24[rbp], rdi				; *array
	mov	QWORD PTR -32[rbp], rsi				; *new_array
	mov	QWORD PTR -40[rbp], rdx				; Size

	mov	DWORD PTR -8[rbp], 0				  ; инициализация i
	mov	DWORD PTR -4[rbp], 0				  ; инициализация j

	jmp	.L23								          ; переход к циклу for
.L25:										            ; тело цикла for
	mov	eax, DWORD PTR -8[rbp]				; помещаем i в eax
	cdqe									            ; преобразование
	
	; взятие элемента по индексу из array
	lea	rdx, 0[0+rax*8]						
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	mov	rax, QWORD PTR [rax]
	
	test	rax, rax						        ; проверка на знак числа
	jle	.L24								          ; если элемент <=0, то переходим к L24

	; взятие элемента по индексу из array
	mov	eax, DWORD PTR -8[rbp]
	cdqe
	lea	rdx, 0[0+rax*8]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx

	; взятие элемента по индексу из new_array
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	lea	rcx, 0[0+rdx*8]
	mov	rdx, QWORD PTR -32[rbp]
	add	rdx, rcx

	; присваивание элемента из array[i] в new_array[j]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rdx], rax

	add	DWORD PTR -4[rbp], 1				 ; увелечение счётчика j
.L24:
	add	DWORD PTR -8[rbp], 1				 ; увелечение счётчика i

.L23:										            ; цикл for
	mov	eax, DWORD PTR -8[rbp]				; перенос i в eax
	cdqe									            ; преобразование
	cmp	QWORD PTR -40[rbp], rax				; сравнение size и i 

	jg	.L25								          ; переход в тело цикла for						
	
	nop										            ; задержка
	nop
	pop	rbp
	ret										            ; выход из цикла
	
	.size	createNewArray, .-createNewArray
	.section	.rodata
.LC5:
	.string	"Input size of array A:"
	.align 8
.LC6:
	.string	"Size of array A = 0. Arrays A and B cannot be created."
.LC7:
	.string	"You input a negative number."
.LC8:
	.string	"N > max_size (214748)"
.LC9:
	.string	"N = %ld\n"
.LC10:
	.string	"Array A:"
.LC11:
	.string	"Array B:"
	.text
	.globl	main
	.type	main, @function
main:
	; пролог функции
	push	rbp
	mov	rbp, rsp


	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	sub	rsp, 104

	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -56[rbp], rax

	xor	eax, eax						       ; обнуление eax
	mov	rax, rsp
	mov	rbx, rax

	lea	rax, .LC5[rip]					    ; эффективный адрес сообщения Input size of array A:
	mov	rdi, rax						        ; помещаем сообщение в rdi
	mov	eax, 0							        ; выводим сообщение
	call	printf@PLT					      ; вызываем функцию

	mov	eax, 0
	call	inputNumber					      ; вызов функции ввода

	mov	QWORD PTR -104[rbp], rax    ; получение значения из функции

	cmp	QWORD PTR -104[rbp], 0			; сравнение 0 и N
	jne	.L27							          ; переход если не равно (в else if)
	
	lea	rax, .LC6[rip]					    ; берём адресс сообщения Size of array A = 0. Arrays A and B cannot be created.
	mov	rdi, rax						        ; копируем сообщение
	mov	eax, 0							
	
	call	printf@PLT					      ; выводим сообщение
	mov	eax, 0
	
	jmp	.L28							          ; переходим к завершению программы
.L27:									            ; if else
	cmp	QWORD PTR -104[rbp], 0			; сравниваем 0 и N
	jns	.L29							          ; если N > 0, то выполняем переход к .L29
	
	lea	rax, .LC7[rip]					    ; берём эффктивный адресс сообщения
	mov	rdi, rax						        ; копируем сообщение
	mov	eax, 0
	
	call	printf@PLT					      ; выводим сообщение
	mov	eax, 0
	
	jmp	.L28							          ; переходим к завершению программы
.L29:
	mov	eax, 214748						      ; помещаем значение в max_size
	cdqe								            ; преобразуем
	cmp	QWORD PTR -104[rbp], rax		; сравниваем N и max_size
	jle	.L30							          ; если N <= max_size, то переходим к L30
	
	lea	rax, .LC8[rip]					    ; берём эффективный адрес сообщения
	mov	rdi, rax						        ; копируем сообщение
	mov	eax, 0
	
	call	printf@PLT					      ; выводим сообщение
	mov	eax, 0
	
	jmp	.L28							          ; переходим к завершению программы
.L30:
	mov	rax, QWORD PTR -104[rbp]    ; копируем значение N в rax
	mov	rsi, rax						        ; из rax в rsi
	
	lea	rax, .LC9[rip]					    ; берём эффективный адрес сообщения
	mov	rdi, rax						        ; копируем сообщение в rdi
	mov	eax, 0
	
	call	printf@PLT					      ; выводим сообщение

	; выделение памяти под массив A
	mov	rax, QWORD PTR -104[rbp]     ; перенесли N в rax
	
	lea	rdx, -1[rax]
	mov	QWORD PTR -96[rbp], rdx

	mov	rdx, rax
	mov	QWORD PTR -128[rbp], rdx
	mov	QWORD PTR -120[rbp], 0

	mov	rdx, rax
	mov	QWORD PTR -144[rbp], rdx
	mov	QWORD PTR -136[rbp], 0

	lea	rdx, 0[0+rax*8]					      ; первый элемент массива
	mov	eax, 16
	sub	rax, 1
	add	rax, rdx
	mov	esi, 16
	mov	edx, 0
	div	rsi
	imul	rax, rax, 16
	mov	rcx, rax
	and	rcx, -4096
	mov	rdx, rsp
	sub	rdx, rcx
.L31:
	cmp	rsp, rdx
	je	.L32
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	jmp	.L31
.L32:
	mov	rdx, rax
	and	edx, 4095
	sub	rsp, rdx
	mov	rdx, rax
	and	edx, 4095
	test	rdx, rdx
	je	.L33
	and	eax, 4095
	sub	rax, 8
	add	rax, rsp
	or	QWORD PTR [rax], 0
.L33:
	mov	rax, rsp
	add	rax, 7
	shr	rax, 3
	sal	rax, 3

	; передача параметров A, N в inputArray
	mov	QWORD PTR -88[rbp], rax
	mov	rdx, QWORD PTR -104[rbp]				; N
	mov	rax, QWORD PTR -88[rbp]					; A
	mov	rsi, rdx
	mov	rdi, rax
	call	inputArray

	; вывод сообщения Array A:\n
	lea	rax, .LC10[rip]
	mov	rdi, rax
	call	puts@PLT

	; передача пареметров в showArray
	mov	rdx, QWORD PTR -104[rbp]				          ; N
	mov	rax, QWORD PTR -88[rbp]					          ; A
	mov	rsi, rdx
	mov	rdi, rax
	call	showArray

	; передача параметров в countSize
	mov	rdx, QWORD PTR -104[rbp]				          ; N 
	mov	rax, QWORD PTR -88[rbp]					          ; A 
	mov	rsi, rdx
	mov	rdi, rax
	call	countSize

	cdqe										                     ; преобразование
	mov	QWORD PTR -80[rbp], rax					         ; присваиваем значение из ф countSize в count_positive
	
	; инициализация массива B длинны count_positive
	mov	rax, QWORD PTR -80[rbp]					          ; count_positive
	
	lea	rdx, -1[rax]
	mov	QWORD PTR -72[rbp], rdx
	mov	rdx, rax
	mov	r14, rdx
	mov	r15d, 0
	mov	rdx, rax
	mov	r12, rdx
	mov	r13d, 0
	lea	rdx, 0[0+rax*8]							            ; первый элемент массива
	mov	eax, 16
	sub	rax, 1
	add	rax, rdx
	mov	esi, 16
	mov	edx, 0
	div	rsi
	imul	rax, rax, 16
	mov	rcx, rax
	and	rcx, -4096
	mov	rdx, rsp
	sub	rdx, rcx
.L34:
	cmp	rsp, rdx
	je	.L35
	sub	rsp, 4096
	or	QWORD PTR 4088[rsp], 0
	jmp	.L34
.L35:
	mov	rdx, rax
	and	edx, 4095
	sub	rsp, rdx
	mov	rdx, rax
	and	edx, 4095
	test	rdx, rdx
	je	.L36
	and	eax, 4095
	sub	rax, 8
	add	rax, rsp
	or	QWORD PTR [rax], 0
.L36:
	mov	rax, rsp
	add	rax, 7
	shr	rax, 3
	sal	rax, 3
	
	; передача параметров в фукнкцию
	mov	QWORD PTR -64[rbp], rax
	mov	rdx, QWORD PTR -104[rbp]				; N
	mov	rcx, QWORD PTR -64[rbp]					; B 
	mov	rax, QWORD PTR -88[rbp]					; A

	mov	rsi, rcx
	mov	rdi, rax
	call	createNewArray

	lea	rax, .LC11[rip]							; взятие адресса сообщения
	mov	rdi, rax
	call	puts@PLT							    ; вызов функции

	
	mov	rdx, QWORD PTR -80[rbp]			; count_positive	
	mov	rax, QWORD PTR -64[rbp]			; B

	; передача параметров в функцию
	mov	rsi, rdx
	mov	rdi, rax
	call	showArray							    ; вызов функции

	mov	eax, 0								    	; возврат кода 0
.L28:										        	; завершение программы
	mov	rsp, rbx
	mov	rdx, QWORD PTR -56[rbp]
	sub	rdx, QWORD PTR fs:40
	je	.L38
	call	__stack_chk_fail@PLT
.L38:
	lea	rsp, -40[rbp]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits

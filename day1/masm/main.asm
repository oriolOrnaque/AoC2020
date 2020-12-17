.386
.model flat, stdcall
option casemap :none

;; ASSEMBLING & LINKING
;; ml.exe main.asm /c
;; link /SUBSYSTEM:CONSOLE main.obj

;▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
;█▄ ▄█ ▄▄▀█▀▄▀█ ██ ██ █ ▄▀█ ▄▄█ ▄▄██
;██ ██ ██ █ █▀█ ██ ██ █ █ █ ▄▄█▄▄▀██
;█▀ ▀█▄██▄██▄██▄▄██▄▄▄█▄▄██▄▄▄█▄▄▄██
;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

includelib kernel32.lib

;▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
;██ ▄▄▀█▀▄▄▀█ ▄▄▀█ ▄▄█▄ ▄█ ▄▄▀█ ▄▄▀█▄ ▄█ ▄▄██
;██ ████ ██ █ ██ █▄▄▀██ ██ ▀▀ █ ██ ██ ██▄▄▀██
;██ ▀▀▄██▄▄██▄██▄█▄▄▄██▄██▄██▄█▄██▄██▄██▄▄▄██
;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

STD_OUT EQU -11

HEAP_ZERO_MEMORY EQU 8  ;; zero the allocated buffer

;;winnt.h
GENERIC_READ EQU 80000000h
GENERIC_WRITE EQU 40000000h
GENERIC_EXECUTE EQU 20000000h
GENERIC_ALL EQU 10000000h

FILE_SHARED_READ EQU 1h
FILE_OPEN_EXISTING EQU 3
FILE_ATTRIBUTE_NORMAL EQU 80h

;;handleapi.h
INVALID_HANDLE_VALUE EQU -1
;;fileapi.h
INVALID_FILE_SIZE EQU -1 ;;ffffffffh

;▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
;██ ▄▄ █ ▄▄▀█▀▄▄▀█▄ ▄█▀▄▄▀█▄ ▄█ ██ █▀▄▄▀█ ▄▄█ ▄▄██
;██ ▀▀ █ ▀▀▄█ ██ ██ ██ ██ ██ ██ ▀▀ █ ▀▀ █ ▄▄█▄▄▀██
;██ ████▄█▄▄██▄▄███▄███▄▄███▄██▀▀▀▄█ ████▄▄▄█▄▄▄██
;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;; === STD === ;;
GetStdHandle PROTO STDCALL, fd:DWORD
GetModuleHandleA PROTO STDCALL, module:PTR BYTE
ExitProcess PROTO STDCALL, code:DWORD

;; === HEAP === ;;
GetProcessHeap PROTO STDCALL
HeapAlloc PROTO STDCALL, heap:DWORD, \
						 flags:DWORD, \
						 bytes:DWORD
HeapFree PROTO STDCALL, heap:DWORD, \
						flags:DWORD, \
						mem:PTR BYTE

;; === FILES === ;;
CreateFileA PROTO STDCALL, filename:PTR BYTE, \
						   desired_access:DWORD, \
						   share_mode:DWORD, \
						   security_attributes:PTR DWORD, \
						   creation_disposition:DWORD, \
						   flags:DWORD, \
						   template:DWORD
CloseHandle PROTO STDCALL, handle:DWORD
GetFileSize PROTO STDCALL, handle:DWORD, \
						   file_size_highdword:PTR DWORD
WriteFile PROTO STDCALL, handle:DWORD, \
						 buffer:PTR BYTE, \
						 buffer_length:DWORD, \
						 written:PTR DWORD, \
						 overlapped:PTR BYTE
ReadFile PROTO STDCALL, handle:DWORD, \
						buffer:PTR BYTE, \
						buffer_length:DWORD, \
						bytes_read:PTR DWORD, \
						overlapped:PTR BYTE

;▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
;█ ▄▀█ ▄▄▀█▄ ▄█ ▄▄▀███ ▄▄█ ▄▄█▀▄▀█▄ ▄██▄██▀▄▄▀█ ▄▄▀██
;█ █ █ ▀▀ ██ ██ ▀▀ ███▄▄▀█ ▄▄█ █▀██ ███ ▄█ ██ █ ██ ██
;█▄▄██▄██▄██▄██▄██▄███▄▄▄█▄▄▄██▄███▄██▄▄▄██▄▄██▄██▄██
;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

.data

input_path db "../input", 0

;▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
;█ ▄▀█ ▄▄▀█▄ ▄█ ▄▄▀█▄ ███ ▄▄█ ▄▄█▀▄▀█▄ ▄██▄██▀▄▄▀█ ▄▄▀██
;█ █ █ ▀▀ ██ ██ ▀▀ █ ▄███▄▄▀█ ▄▄█ █▀██ ███ ▄█ ██ █ ██ ██
;█▄▄██▄██▄██▄██▄██▄█▀████▄▄▄█▄▄▄██▄███▄██▄▄▄██▄▄██▄██▄██
;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

.data?	;; unitialized data

heap dd ? ;; handle for the heap

file dd ? ;; handle for the file
file_size dd ? ;; size of the file
bytes_read dd ? ;; n bytes from the file read into buffer

buffer dd ? ;; ptr to a buffer with the file contents
buffer2 dd ? ;; ptr to an array of ints

;▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
;█▀▄▀█▀▄▄▀█ ▄▀█ ▄▄███ ▄▄█ ▄▄█▀▄▀█▄ ▄██▄██▀▄▄▀█ ▄▄▀██
;█ █▀█ ██ █ █ █ ▄▄███▄▄▀█ ▄▄█ █▀██ ███ ▄█ ██ █ ██ ██
;██▄███▄▄██▄▄██▄▄▄███▄▄▄█▄▄▄██▄███▄██▄▄▄██▄▄██▄██▄██
;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

.code

solve1 PROC, _entries:PTR DWORD, _n_ints:DWORD
	push eax
	push ebx
	push ecx
	push edx
	push edi

	mov ebx, _entries
	xor edi, edi
outer_loop_1:
	mov eax, 2020
	sub eax, [ebx]
	mov edx, 0
	mov ecx, _entries
	inner_loop:
		cmp eax, [ecx]
		je solve1_found
		add ecx, 4
		inc edx
		cmp edx, _n_ints
		je outer_loop_2
		jmp inner_loop
outer_loop_2:
	add ebx, 4
	inc edi
	cmp edi, _n_ints
	je solve1_end
	jmp outer_loop_1


solve1_found:
solve1_end:
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
solve1 ENDP

solve2 PROC, _entries:PTR DWORD, _n_ints:DWORD
	ret
solve2 ENDP

;;-----------------------------------------------------
;; procedure to count the number of chars in a string
;; the string should be null terminated but the procedure
;; will also stop counting on \r\n bytes
;; the result is returned in EAX
;;-----------------------------------------------------
strlen PROC, _string:PTR BYTE
	push esi
	push ebx
	xor eax, eax 		;; char counter
	mov esi, _string 	;; byte address
strlen_count_loop:
	mov bl, BYTE PTR [esi]
	cmp bl, 0 			;; null terminated string
	je strlen_count_end
	cmp bl, 0dh 		;; \r byte
	je strlen_count_end
	cmp bl, 0ah 		;; \n byte
	je strlen_count_end
	inc esi
	inc eax
	jmp strlen_count_loop
strlen_count_end:
	pop ebx
	pop esi
	ret
strlen ENDP

;;-----------------------------------------------------
;; procedure to convert a number represented as a string
;; into an integer. The parsing stop whenever the proc 
;; encounters a null char or a newline
;; the result is returned in EAX
;;-----------------------------------------------------
atoi PROC, _string:PTR BYTE
	push esi
	push ebx
	xor eax, eax 		;; stores result
	mov esi, _string 	;; byte address
atoi_loop:
	mov bl, BYTE PTR [esi]
	cmp bl, 0 			;; null terminated string
	je atoi_end
	cmp bl, 0dh 		;; \r byte
	je atoi_end
	cmp bl, 0ah 		;; \n byte
	je atoi_end
	imul eax, 10
	sub bl, 30h 		;; convert ascii digit to number
	add al, bl
	inc esi
	jmp atoi_loop
atoi_end:
	pop ebx
	pop esi
	ret
atoi ENDP

;;-----------------------------------------------------
;; procedure to count the number of newlines + EOF on
;; a buffer that represents the contents of a file
;; the register values are not saved nor cleaned
;; the result is returned in EAX
;;-----------------------------------------------------
count_lines PROC, _buffer:PTR BYTE, _buffer_size:DWORD
	push ebx
	push ecx
	push edx
	push edi
	mov edx, _buffer_size 	;; max iterations
	xor eax, eax 			;; reset counter
	mov ecx, _buffer 		;; base addr of buffer
	xor edi, edi 			;; clear buffer, index
start_counting:
	cmp edx, 0 				;; are there more bytes to read
	je end_counting 		;; we are finished counting
	mov bl, BYTE PTR [ecx + edi] 	;; read one more byte
	dec edx					;; one byte less to read
	inc edi 				;; increment the index
	cmp bl, 0Ah 			;; is a newline?
	jne start_counting 		;; loop
	inc eax 				;; newline found
	jmp start_counting 		;; loop
end_counting:
	inc eax 				;; + EOF
	pop edi
	pop edx
	pop ecx
	pop ebx
	ret
count_lines ENDP

main:
	;; setup the heap
	invoke GetProcessHeap
	cmp eax, 0
	je exit
	mov heap, eax

	;; open the input file
	invoke CreateFileA, addr input_path, GENERIC_READ, FILE_SHARED_READ, 0, FILE_OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je exit
	mov file, eax

	;; get file size to allocate enough bytes
	invoke GetFileSize, file, 0
	cmp eax, INVALID_FILE_SIZE
	je close_file
	mov file_size, eax

	;; allocate a buffer for the file contents
	invoke HeapAlloc, heap, HEAP_ZERO_MEMORY, file_size
	cmp eax, 0
	je close_file
	mov buffer, eax

	;; read the file contents into the buffer
	invoke ReadFile, file, buffer, file_size, addr bytes_read, 0
	cmp eax, 0
	je free_buffer

	;; allocate a buffer for an array of ints
	invoke count_lines, buffer, bytes_read
	mov ebx, 4 			;; 4 bytes per integer
	mul bx
	invoke HeapAlloc, heap, HEAP_ZERO_MEMORY, eax
	cmp eax, 0
	je free_buffer
	mov buffer2, eax

	;; populate the array of ints with the file contents
	invoke count_lines, buffer, bytes_read
	mov ecx, eax 	;; number of ints to convert
	mov edi, buffer
	mov esi, buffer2
	xor ebx, ebx
convert_to_int_loop:
	invoke atoi, edi
	mov [esi], eax
	inc ebx
	add esi, 4
	invoke strlen, edi
	add eax, 2
	add edi, eax
	dec ecx
	cmp ecx, 0
	jg convert_to_int_loop

	invoke solve1, buffer2, ebx
	invoke solve2, buffer2, ebx

free_buffer2:
	invoke HeapFree, heap, 0, buffer2
	cmp eax, 0
	je free_buffer

free_buffer:
	invoke HeapFree, heap, 0, buffer
	cmp eax, 0
	je close_file

close_file:
	invoke CloseHandle, file
	cmp eax, 0
	je exit

exit:
	invoke ExitProcess, 0
end main

.MODEL SMALL  

next_line macro 
    ;new line
    mov dl,0Ah
    mov ah,2
    int 21h
    
    ;start
    mov dl,0Dh
    int 21h 
endm 

find_max_macro macro max_arr
    ; Assume first element is max
        mov si,0
        mov ax, max_arr[si]
        mov max, ax 
   
        ; Find max in array
        mov al,user_n
        cmp al,1
        je final_end  
        mov ah,0
        mov cx, ax               ; remaining elements  
        sub cx,1  
           
                      
    find_loop:
        add si,2
        mov ax, max_arr[si]
        cmp ax, max
        jle skip
        mov max, ax
    skip:
        loop find_loop 
endm


        
 
.STACK 100H

.DATA

; declare variables here 

welcome db "                    Welcome to BMI and BMR calculator!!$" 


;max 
n db ?  
user_n db ?
bmi_arr dw n dup(0) 
num_of_user db "How many user's info do you want to calculate?$ "  
bmr_arr dw n dup(0) 
msg_max_bmi db "Maximum BMI recorded: $"   
msg_max_bmr db "Maximum BMR recorded: $"
digits_max db 5 dup(?)                   
max dw ?
min dw ?

msg_min_bmi db "Minimum BMI recorded: $" 
msg_min_bmr db "Minimum BMR recorded: $"

non_zero_found db ?


digits db 4 dup(0)      
digits_tdee db 5 dup(0)
;gender
enter_gender db "Select your gender:$"
male db "1. Male $" 
female db "2. Female$" 
gender db ?
g db "Gender: $" 
 

;age
enter_age db "Enter your Age(in years): $"
age dw ? 
age_arr db 3 dup(?)  
age_len dw ?

;weight
w db ?  
select_weight_unit db 'Select the unit for your weight: 1.Kilograms(kg)  2.Pound(lb) $'
select db 'Select: $'
enter_weight db "Enter your Weight: $"      
weight dw 0 
weight_arr db 3 dup(?) 
weight_len dw ? 

;height 
enter_height_unit db "Select the unit for your height: 1.Meters(m) 2.Centimeters(cm) 3.Inches(inch) $"   
height_unit db ?
enter_height db "Enter your Height: $"  
height dw ?  
height_arr db 3 dup(?) 
height_len dw 0

;activity
enter_activity db "Select your activity: 1.Sedentary 2.Light 3.Moderate 4.Very 5.Super $"
activity db ?
a db "Activity: $"


;calculation options
enter_cal db "Select what you want to calculate: 1.BMI 2.BMR$"
s db "Select: $"
selected_for_cal db ?  


;BMI
bmi dw ? 
show_bmi db "Your BMI: $"   
 
bmi_digits db 3 dup(?) 
 
 
 
under_weight_alert db "You are underweight.$" 
normal_weight_alert db "Good job! You have a normal weight.$"
over_weight_alert db "Warning: You are overweight.$"
obese_alert db "Caution: You are in the obese range.$" 





;BMI category
under_weight_1 db "1. Consider increasing calorie intake with nutrient-rich foods.$"
under_weight_2 db "2. Strength training and a balanced diet can help gain healthy weight.$"

normal_weight_1 db "1. Maintain a well-balanced diet and regular exercise routine$" 
normal_weight_2 db "2. Continue healthy habits to sustain optimal fitness.$"

over_weight_1 db "1. Consider incorporating more physical activity into daily life.$" 
over_weight_2 db "2. Monitor diet and focus on balanced nutrition.$"

obese_1 db "1. Seek medical advice for a suitable diet and exercise plan.$" 
obese_2 db "2. Make gradual lifestyle changes to improve overall health.$"

;BMR
bmr dw ? 
show_bmr db "Your BMR: $"  
tdee db 'Your TDEE: $' 
  

;TDEE Categorization 
tdee_value dw ?
tdee_category db 'TDEE Category: $' 
low_calorie db 'Very Low Calorie Needs $'
low_to_moderate db 'Low to Moderate Calorie Needs $'
average db 'Average Calorie Needs $'
high db 'High Calorie Needs $'
Very_high db 'Very High Calorie Needs $'

;invalid input
inv_input db "Invalid input! Do you want to re-enter your inputs?(y/n)$"

;flag
bmi_flag db 0
bmr_flag db 0 

ask_bmr db "Do you want to calculate BMR?(y/n)$"
ask_bmi db "Do you want to calculate BMI?(y/n)$" 





.CODE
MAIN PROC

; initialize DS

MOV AX,@DATA
MOV DS,AX
 
; enter your code here
try_again:
mov di,0 
;;rank
mov ah,9
lea dx,num_of_user
int 21h 
mov ah,1
int 21h
sub al,48 
mov n,al  
mov user_n,al
next_line     
next_line

;;;;;;gender selection 
mov ah,9
lea dx,welcome
int 21h 

;try_again: 
entire_loop:
next_line
next_line
  
mov ah,9
lea dx,enter_gender
int 21h

next_line

mov ah,9
lea dx,male
int 21h

next_line



mov ah,9
lea dx,female
int 21h 

next_line

mov ah,9
lea dx,g
int 21h

;input
mov ah,1
int 21h  
mov gender,al  ;;gender is in ascii

    

;;;;;;;;;;;;;;enter age 
next_line
next_line
 
mov ah,9
lea dx,enter_age
int 21h 

   
;input
mov cx,3
mov si,0
mov ah,1 
mov age_len,0
mov age,0 ;resetting to 0 for try again
input_age:
    int 21h
    cmp al,' '
    je stop_age_input 
    sub al,48
    mov age_arr[si],al 
    inc si 
    inc age_len
    loop input_age
     
stop_age_input:
    mov cx,age_len
    mov bl,1
    mov si,age_len 
    dec si ;as index 0-(len-1) 
    cal_age:
        mov ah,0
        mov al,age_arr[si] 
        mul bl
        add age,ax
        
        mov al,bl
        mov bl,10
        mul bl 
        mov bl,al 
        
        dec si  
        loop cal_age
          
     cmp age,150
     jg input_invalid 
     cmp age,0
     je input_invalid 
    
         

        
;;;;;;enter weight
next_line

mov ah,9
lea dx,select_weight_unit     
int 21h

next_line
mov ah,9
lea dx,select              ; weight unit selection: 1.kg 2.pound
int 21h

mov ah,1
int 21h 
sub al,48
mov w,al                   ;selected kg/pound stored in w (used for comparison later)

cmp al,2
jg input_invalid           ;if weight unit selection more than 2, invalid

next_line 
mov ah,9
lea dx,enter_weight
int 21h
  
;input
mov cx,3
mov si,0
mov ah,1
mov weight_len,0     ;length of weight(total no. of digits)
mov weight,0 ;resetting to 0 for try again 
input_weight:
    int 21h
    cmp al,' '   ;if space as input, then stop taking weight input
    je stop_weight_input 
    sub al,48               ;ascii 
    mov weight_arr[si],al   ;weight input digits stored in the weight_arr array
    inc si                  ;si incremented to move to next element of array
    inc weight_len          ; length of weight incremented
    loop input_weight
     
stop_weight_input: 
    mov cx,weight_len     ;loop runs length of weight times
    mov bl,1
    dec weight_len ;as index 0-(len-1) for si(array)
    mov si,weight_len 
    cal_weight:   ;a reverse loop is run through the weight_arr to calculate the weight from elements of the array
        mov al,weight_arr[si]  
        mul bl
        add weight,ax
                                 ;firstly, the last digit is multiplied by 1 and added to weight variable
        mov al,bl                ; previous digit then multiplied by 10 and added to weight
        mov bl,10                ; again the previous digit multiplied by 100 and so on
        mul bl 
        mov bl,al 
        
        dec si              ;decrement for reverse loop
        loop cal_weight 
        
    cmp weight,500        ;if weight greater than 500, invalid 
    jg input_invalid
    


; cl,weight ;to check 
mov cl,w      ;if weight unit selection is 2, that is pounds, convert it to kg else move to next part(height)
cmp cl,2
je pound_convert 
jmp jump_to_height

pound_convert:
mov dx,0
mov ax,weight    ;to convert from pound to kg, divide by 2
mov cx,2         ; weight(lb)/2 = weight(kg)
div cx
mov weight,ax    ;quotient stored in ax 



                

;;;;;;;;;;;;;;;;;;;;enter height 

jump_to_height:
next_line
next_line

mov ah,9
lea dx,enter_height_unit
int 21h
  
next_line

mov ah,9
lea dx,s
int 21h 

;input
mov ah,1
int 21h  
sub al,48
mov height_unit,al
 
cmp al,3
jg input_invalid

next_line

mov ah,9
lea dx,enter_height
int 21h 

  
;input
mov cx,3
mov si,0
mov ah,1 
mov height_len,0
mov height,0 ;resetting to 0 for try again
input_height:
    int 21h
    cmp al,' '
    je stop_height_input 
    sub al,48
    mov height_arr[si],al 
    inc si 
    inc height_len
    loop input_height
     
stop_height_input:
    mov cx,height_len
    mov bl,1
    mov si,height_len 
    dec si ;as index 0-(len-1) 
    cal_height:
        mov ah,0
        mov al,height_arr[si] 
        mul bl
        add height,ax
        
        mov al,bl
        mov bl,10
        mul bl 
        mov bl,al 
        
        dec si  
        loop cal_height
          
    cmp height_unit,2
    je cm_to_m
    cmp height_unit,3
    je inch_to_m 
    
    ;if unit==1:(meter)
    mov cl,1 
    jmp height_conversion 
    
    cm_to_m: 
        mov cl,100 
        jmp height_conversion
             
    inch_to_m: 
        mov cl,39
        jmp height_conversion
    
    height_conversion:        
        mov ax,height
        div cl ;al->result (ax/bl) 
         
        mov ah,0
        mov height,ax 
        
        cmp height,3
        jg input_invalid
     



activity_input:
;;;;select activity
next_line
next_line

mov ah,9
lea dx,enter_activity
int 21h

next_line

mov ah,9
lea dx,a
int 21h

;input
mov ah,1
int 21h           ;activity input 1/2/3/4/5 stored inactivity variable (used to calculate tdee)
mov activity,al


;;;;;select bmi or bmr

next_line 

next_line

mov ah,9
lea dx,enter_cal
int 21h

next_line

mov ah,9
lea dx,s
int 21h

;input
mov ah,1
int 21h 
sub al,48
mov selected_for_cal,al 

next_line

cmp selected_for_cal,1
je calculate_bmi
jne calculate_bmr ;;;;Sumaiya 


;;;;;BMI calculation

calculate_bmi: 
    mov bmi_flag,1

    ;h**2
    mov ax,height
    mov bx,height
    mul bx ;ax-> h**2
    mov bx,ax ;bx-> h**2 
    
      
    ;w/(h**2)
    mov dx,0h
    mov ax,weight
    
    div bx ;ax->bmi (ignoring float)
    mov bmi,ax  
    mov bmi_arr[di],ax ;storing for finding max
    
    mov ah,9
    lea dx,show_bmi
    int 21h
    
    ; Initialize registers 
    
    mov ax, bmi
    mov bx, 10          ; Divisor for decimal system
    lea si, bmi_digits      ; Pointer to store digits 

    divide_loop1:  
      mov dx,0 
      div bx              ; AX = AX / 10, DX = AX % 10
      mov [si], dl   ; Store digit
      add si,1              ; Increment digit counter
      cmp ax, 0           ; Check if quotient is zero
      jne divide_loop1     ; Repeat if quotient is not zero


     mov si,2 ;print starts with last value of arr
     mov cx,3
     print_digits1:
        mov dl, bmi_digits[si] 
        add dl,48  
        mov ah, 2
        int 21h
        sub si,1             
        loop print_digits1 
               
         
    next_line   
    
    ;;;;;bmi category
    cmp bmi,18
    jle under_weight
    jg check1
    
    under_weight:
     
        mov ah,9
        lea dx,under_weight_alert
        int 21h 
        
        next_line
     
        mov ah,9
        lea dx,under_weight_1
        int 21h 
        
        next_line
        
        mov ah,9
        lea dx,under_weight_2
        int 21h 
        
        cmp bmr_flag,0
        je asking_user_calulate_bmr
        
        jmp exit 
        
        
    check1:
        cmp bmi,24
        jle normal_weight
        jg  check2 
        
        normal_weight: 
        
            mov ah,9
            lea dx,normal_weight_alert
            int 21h 
            
            next_line 
            
            mov ah,9
            lea dx,normal_weight_1
            int 21h 
            
            next_line
            
            mov ah,9
            lea dx,normal_weight_2
            int 21h
            
            cmp bmr_flag,0
            je asking_user_calulate_bmr 
            
            jmp exit

            
        check2:
            cmp bmi,30
            jle over_weight
            jg obese  
            
            over_weight: 
                
                mov ah,9
                lea dx,over_weight_alert
                int 21h 
                
                next_line
            
                mov ah,9
                lea dx,over_weight_1
                int 21h
                
                next_line 
                
                mov ah,9
                lea dx,over_weight_2
                int 21h
                
                cmp bmr_flag,0
                je asking_user_calulate_bmr
                
                jmp exit
                
            obese:  
                
                mov ah,9
                lea dx,obese_alert
                int 21h 
                
                next_line
                
                mov ah,9
                lea dx,obese_1
                int 21h 
                
                next_line
                
                mov ah,9
                lea dx,obese_2
                int 21h 
                
                cmp bmr_flag,0
                je asking_user_calulate_bmr
                
                jmp exit
    


calculate_bmr:          ;bmr= (10xweight(kg))+(625xheight(m))-(5xage(yrs))+5 (male)
  ;sumaiya              ;bmr= (10xweight(kg))+(625xheight(m))-(5xage(yrs))-161 (female)
  mov bmr_flag,1
  ;weight*10 
  mov ax,weight
  mov bx,10
  mul bx  ;dx:ax (only need ax)   
  mov cx,ax
  
  ;height*625
  mov ax,height
  mov bx,625 
  mul bx ;for this we only need ax as the ans doesn't go over 4 hex digit
  mov bx,ax
  
  ;age*5
  mov ax,age
  mov dx,5
  mul dx ;dx:ax->5*age  (only need ax)
  
  mov bmr,cx
  add bmr,bx
  sub bmr,ax
  
  
  cmp gender,'1'
  je male_bmr
  cmp gender,'2'
  je female_bmr

male_bmr: 
    add bmr,5 
    mov cx,bmr
    jmp print_bmr
      
female_bmr: 
    sub bmr,161
    jmp print_bmr  
   
print_bmr:
    ; Store BMR in memory
    mov ax, bmr
    mov bmr_arr[di], ax
    next_line

    ; Display "Your BMR: "
    lea dx, show_bmr
    mov ah, 9
    int 21h

    ; Initialize registers 
    
    mov ax, bmr
    mov bx, 10          ; Divisor for decimal system
    lea si, digits      ; Pointer to store digits 
                                                       ;bmr is divided by 10 in each loop and the 
    divide_loop:                                       ;remainder is stored in digits array
      mov dx,0 
      div bx              ; AX = AX / 10, DX = AX % 10
      mov [si], dl   ; Store digit                        ;repeat until loop
      add si,1              ; Increment digit counter
      cmp ax, 0           ; Check if quotient is zero
      jne divide_loop     ; Repeat if quotient is not zero


   mov si,3
   mov cx,4
   print_digits:           ;reverse loop run through digits array to print the digits
     mov dl, digits[si]    ;reverse because the digits of bmr are stored in a reverse manner in the digits array
     add dl,48  
     mov ah, 2
     int 21h
     sub si,1             
     loop print_digits

    
    next_line
    
    lea dx, tdee
    mov ah,9
    int 21h
    
    mov ax,bmr
    mov cl,activity       ;tdee = bmr x activity factor
    sub cl,48 
    mov ch,0 
    mul cx 
    mov tdee_value,ax     ;stored in AX
    
    
    mov bx, 10          
    lea si, digits_tdee   ;loop run to store digits of tdee in digits_tdee array    
                          ;divide by 10 each time and remainder stored in array
    divide_loop2:  
      mov dx,0 
      div bx              ; AX = AX / 10, DX = AX % 10
      mov [si], dl   ; Store digit
      add si,1              ; Increment digit counter
      cmp ax, 0           ; Check if quotient is zero
      jne divide_loop2     ; Repeat if quotient is not zero


   mov si,4
   mov cx,5                ;reverse loop to print the digits from digits_tdee array
   print_digits2:
     mov dl, digits_tdee[si] 
     add dl,48  
     mov ah, 2
     int 21h
     sub si,1             
     loop print_digits2
    
    next_line  
    lea dx, tdee_category      ;tdee category
    mov ah,9
    int 21h
    
    cmp tdee_value,1800
    jl very_low
    jge option1
    
    
    very_low:
    lea dx,low_calorie    ;very low calorie needs
    mov ah,9
    int 21h
    cmp bmi_flag,0       ;if flag is zero, it means bmi has not been calculated yet
    je  asking_user_calulate_bmi
    jmp exit
    
    option1: 
       cmp tdee_value,2200
       jle low_to_moderate_calorie
       jg option2 
       
       low_to_moderate_calorie: 
       lea dx,low_to_moderate     ;low to moderate calorie needs
       mov ah,9
       int 21h 
       
       cmp bmi_flag,0
       je  asking_user_calulate_bmi
       jmp exit
       
    option2:
       cmp tdee_value,2600
       jle average_calorie
       jg option3
       
       average_calorie:
       lea dx,average             ;average calorie needs
       mov ah,9
       int 21h
       cmp bmi_flag,0
       je  asking_user_calulate_bmi
       jmp exit
       
    option3:
       cmp tdee_value,3000
       jle high_calorie
       jg very_high_calorie
       
       high_calorie:            ;high calorie needs
       lea dx,high
       mov ah,9
       int 21h
       
       cmp bmi_flag,0
       je  asking_user_calulate_bmi
       jmp exit
       
       very_high_calorie:
       lea dx, Very_high
       mov ah,9                 ;very high calorie needs
       int 21h 
       
       cmp bmi_flag,0
       je  asking_user_calulate_bmi
       jmp exit 
        
    
asking_user_calulate_bmr:
    next_line  
    next_line
    
    mov ah,9
    lea dx,ask_bmr
    int 21h 
    
    mov ah,1
    int 21h 
    
    cmp al,'y' 
    je calculate_bmr
    jne exit 
    
    
asking_user_calulate_bmi:
    next_line  
    next_line
    
    mov ah,9
    lea dx,ask_bmi
    int 21h 
    
    mov ah,1
    int 21h 
    
    cmp al,'y' 
    je calculate_bmi
    jne exit

    
    
    

input_invalid:
    ;;print input invalid 
    ;reset all varibales and ask user to do again
    next_line  
    next_line 
    
    ;reset everything for next user
    mov age,0
    mov height,0
    mov weight,0
    mov gender,0 
    mov bmr_flag,0
    mov bmi_flag,0
    
    mov ah,9
    lea dx,inv_input
    int 21h 
    
    mov ah,1
    int 21h 
    
    cmp al,'y' 
    next_line
    je try_again
    jne exit
    

        
     
exit:
    dec n  
    cmp n,0
    je end 
    ;reset everything for next user
    mov age,0
    mov height,0
    mov weight,0
    mov gender,0 
    mov bmr_flag,0
    mov bmi_flag,0
    next_line
    next_line
    add di,2
    jne entire_loop
    ;exit to DOS
   
    
    end: 
        next_line 
        next_line
        
        ;BMI MAX 
        find_max_macro bmi_arr
        ; Print message
        lea dx, msg_max_bmi
        mov ah, 09h
        int 21h  
        
        mov ax, max
        call print_proc 
        
        next_line  
      
        
        ;BMR MAX 
        ; Assume first element is max
        mov si,0
        mov ax, bmr_arr[si]
        mov max, ax 
   
        ; Find max in array
        mov al,user_n
        cmp al,1
        je final_end  
        mov ah,0
        mov cx, ax               ; remaining elements  
        sub cx,1  
           
                      
        find_loop2:
            add si,2
            mov ax, bmr_arr[si]
            cmp ax, max
            jle skip2
            mov max, ax
        skip2:
            loop find_loop2   
        
        ; Print message
        lea dx, msg_max_bmr
        mov ah, 09h
        int 21h
        
        mov ax, max    
        call print_proc
         
        next_line 
        
                           
                             
       ; Assume first element is min
        mov si, 0
        mov ax, bmi_arr[si]
        mov min, ax

        mov non_zero_found, 0     ; flag to detect non-zero

        ; Check if first value is non-zero
        cmp ax, 0
        je skip_first1
        mov non_zero_found, 1     ; set flag if non-zero
        skip_first1:
        
                ; Compare remaining values
                mov al, user_n
                cmp al, 1
                je final_end              ; only one value, already stored
        
                mov ah, 0
                mov cx, ax
                sub cx, 1                 ; subtract first already checked
        
        find_loop3:
                add si, 2                 ; move to next word
                mov ax, bmi_arr[si]
                cmp ax, 0
                je skip3                  ; skip zero values
        
                cmp non_zero_found, 0
                jne compare_min1
        
                ; First non-zero encountered
                mov min, ax
                mov non_zero_found, 1
                jmp skip3
        
        compare_min1:
                cmp ax, min
                jge skip3
                mov min, ax
        
        skip3:
                loop find_loop3
        
        ; If no non-zero found, set min = 0
        cmp non_zero_found, 1
        je print_min_bmi
        mov min, 0
        
        print_min_bmi:
        ; Print message
        lea dx, msg_min_bmi
        mov ah, 09h
        int 21h 
        
        mov ax, min
        call print_proc
        
        next_line  
        
        
        
        ; Assume first element is min
        mov si, 0
        mov ax, bmr_arr[si]
        mov min, ax

        mov non_zero_found, 0     ; flag to detect non-zero

        ; Check if first value is non-zero
        cmp ax, 0
        je skip_first
        mov non_zero_found, 1     ; set flag if non-zero
        skip_first:
        
                ; Compare remaining values
                mov al, user_n
                cmp al, 1
                je final_end              ; only one value, already stored
        
                mov ah, 0
                mov cx, ax
                sub cx, 1                 ; subtract first already checked
        
        find_loop4:
                add si, 2                 ; move to next word
                mov ax, bmr_arr[si]
                cmp ax, 0
                je skip4                  ; skip zero values
        
                cmp non_zero_found, 0
                jne compare_min
        
                ; First non-zero encountered
                mov min, ax
                mov non_zero_found, 1
                jmp skip4
        
        compare_min:
                cmp ax, min
                jge skip4
                mov min, ax
        
        skip4:
                loop find_loop4
        
                ; If no non-zero found, set min = 0
        cmp non_zero_found, 1
        je print_min
        mov min, 0
        
        
        print_min:
        ; Print message
        lea dx, msg_min_bmr
        mov ah, 09h
        int 21h 
        mov ax, min
        call print_proc




        
                
            
       
       
    
    
    
    
    final_end:
                  
    MOV AX,4C00H
    INT 21H 
    
    MAIN ENDP
    proc print_proc
    
        ; Convert max to ASCII digits
        mov si, 0               ; digit count
        convert_loop:
            mov dx, 0
            mov bx, 10
            div bx
            add dl,48
            mov digits_max[si], dl
            inc si
            cmp ax, 0
            jne convert_loop
        
            ; Print digits in reverse
        print_loop:
            dec si
            mov dl, digits_max[si]
            mov ah, 02h
            int 21h
            cmp si, 0
            jne print_loop
        ret 
        print_proc endp
            
    END MAIN













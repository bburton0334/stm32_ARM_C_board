 @ Data section - initialized values
.data

    .align 3    @ This alignment is critical - to access our "huge" value, it must
                @ be 64 bit aligned

    @@=============== CONSTANTS ================================================================================================

    A4_led_call_delay: .word 0          @ Delay for preforming accel led trigger
    A4_delay: .word 0                   @ Holds delay counter parameter of A4
    A4_updated_delay: .word 0           @ Holds an updated delay counter for A4
    A4_game_time: .word 0               @ Stores game_time parameter for A4
    A4_target: .word 0                  @ constant which will hold the target parameter for A4
    A4_curr_target: .word 0             @ constant which will hold the current LED for A4

    lab_ticks: .word 0                  
    lab_ticks_blinks: .word 0

    delay_time: .word 0                 @ Replacemnet for busy delay. Holds delay amount 
    tick_delay_call_delay: .word 0

    LEDaddress: .word 0x48001014        @ holds value which will trigger every led

    A5_refresh_status: .word 0             @ will hold a value if the watchdog should refresh for A5
    A5_timeout: .word 0
    A5_delay: .word 0
    A5_updated_delay: .word 0
    A5_watch_ticks: .word 0
    A5_on_or_off: .word 0

    @@==========================================================================================================================

    .equ ACC_I2C_ADDRESS, 0x32
    .equ X_H_A, 0x29
    .equ X_LO, 0x28
    .equ Y_H_A, 0x2B
    .equ DELAY, 0x4C4B40                @ Holds a quick delay amount for the use of busy_delay in A4
    .equ TICKS_TO_CALL, 0xF             @ holds the amount of ticks needed for portion of function to execute for A4
    .equ MIN_DELAY, 0x1                 @ holds minimum delay value for A4. Sets delay to this value if delay is 0
    .equ WIN_DELAY, 0x90F560            @ holds delay amount for the leds to flash if the user wins in A4
    .equ MAX_LED_A4, 0x8                @ holds the maximum led amount for the win loop for A4 (pre-subtraction)
    .equ WIN_LOOP_COUNTER_A4, 0x2       @ holds counter amount for a4_win loop in A4
    .equ NEG_VALUE, 0x-10               @ Holds negative 16, used for comparisons in led logic for A4
    .equ POS_VALUE, 0x10                @ holds positive 16, used for comparisons in led logic for A4
    .equ MS_SHFT_VAL_A4, 0x9            @ Holds shift amount needed (9) to scale the delay paramter in A4 into aprox. milliseconds
    .equ SEC_MUL_VAL_A4, 0x19           @ holds 25 which is the amount needed to scale game_time parameter into seconds for A4.

    .equ A5_REFRESH_FALSE, 0x1          @ holds 1, meaning refresh is false
    .equ A5_REFRESH_TRUE, 0x0           @ holds 0, meaning refresh is true
    .equ A5_OFF_STATUS, 0x0             @ holds 0, meaning leds off
    .equ A5_ON_STATUS, 0x1              @ holds 1, meaning leds on
    .equ A5_TICKS, 0x2                  @ holds amounf of ticks for _bb_a5_tick_handler
    .equ A5_TRIGGER_ON, 0xff00          @ holds value, that when OR operation is used, holds a value to trigger all leds on
    .equ A5_TRIGGER_OFF, 0x0            @ holds value that will trigger leds off

    .equ DEC_INC, 0x1                   @ holds a value of 1 to be used in decrementing or incrementing

    .equ LED_0, 0x0                     @ holds value for LED 0
    .equ LED_1, 0x1                     @ holds value for LED 1
    .equ LED_2, 0x2                     @ holds value for LED 2
    .equ LED_3, 0x3                     @ holds value for LED 3
    .equ LED_4, 0x4                     @ holds value for LED 4
    .equ LED_5, 0x5                     @ holds value for LED 5
    .equ LED_6, 0x6                     @ holds value for LED 6
    .equ LED_7, 0x7                     @ holds value for LED 7

    @@==========================================================================================================================

    huge: .octa 0xAABBCCDDDDCCBBAA
    big: .word 0xAAAABBBB
    num: .byte 0xAB

    str2: .asciz "Bonjour le Monde"
    count: .word 12345                  @ This is an initialized 32 bit value


    .code 16                            @ This directive selects the instruction set being generated.
                                        @ The value 16 selects Thumb, with the value 32 selecting ARM.

    .text                               @ Tell the assembler that the upcoming section is to be considered
                                        @ assembly language instructions - Code section (text -> ROM)

    .align 2                            @ Code alignment - 2^n alignment (n=2)
                                        @ This causes the assembler to use 4 byte alignment


    .syntax unified                     @ Sets the instruction set to the new unified ARM + THUMB
                                        @ instructions. The default is divided (separate instruction sets)

    .global bb_led_demo_a2              @ Make the symbol name for the function visible to the linker
    .global string_test
    .global bb_game_a3
    .global _bb_lab_tick
    .global _bb_lab_setup
    .global lab6_test
    .global test_tick
    .global _test_function
    .global bbTilt
    .global a4_game_time_logic
    .global a4_delay_logic
    .global lab8
    .global random_led_function
    .global _bbWatch
    .global _bb_a5_button_handler
    .global _bb_a5_tick_handler
    .global myTest

    .code 16                            @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func                         @ Specifies that the following symbol is the name of a THUMB
                                        @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type bb_led_demo_a2, %function     @ Declares that the symbol is a function (not strictly required)
    .type string_test, %function 
    .type bb_game_a3, %function 
    .type _bb_lab_tick, %function 
    .type _bb_lab_setup, %function
    .type lab6_test, %function
    .type test_tick, %function
    .type _test_function, %function
    .type bbTilt, %function
    .type a4_game_time_logic, %function
    .type a4_delay_logic, %function
    .type lab8, %function
    .type random_led_function, %function
    .type _bbWatch, %function
    .type _bb_a5_button_handler, %function
    .type __bb_a5_tick_handler, %function
    .type myTest, %function



@@=================== my test=============

myTest:

    push {r4-r9,lr}

    mov r4, r0      @ move delay value in r4
    mov r5, r1      @ move target value in r5
    ldr r6,=0x1EEAC @ load the constant value in r6
    mov r9, #0          @ holds counter

    myTestLoop:

        sub r6, r6, #1   @ count down the constant value in r6
            mov r0, r6

            sub_hun_thousand:
                ldr r1, =#100000
                cmp r0, r1
                IT GT
                subgt r0, r0, r1
                cmp r0, r1
                IT GT 
                bgt sub_hun_thousand 

            sub_ten_thousand:
                mov r1, #10000
                cmp r0, r1
                IT GT
                subgt r0, r0, r1
                cmp r0, r1
                IT GT
                bgt sub_ten_thousand

            sub_one_thousand:
                mov r1, #1000
                cmp r0, r1
                IT GT
                subgt r0,r0,r1
                cmp r0, r1
                IT GT
                bgt sub_one_thousand

            mov r7, r0 @ storing last 3 values

            sub_one_hundred:
                mov r1, #100
                cmp r0, r1
                IT GT
                subgt r0, r0, r1
                cmp r0, r1
                IT GT
                bgt sub_one_hundred

            sub_ten:
                mov r1, #10
                cmp r0, r1
                IT GT
                subgt r0, r0, r1
                cmp r0, r1
                IT GT
                bgt sub_ten

            mov r8, r0  @ saving last bit

            cmp r8, #7
            IT GT
            bgt is_invalid

            cmp r8, #0
            IT lt
            blt is_invalid

            cmp r8, r5
            ITTT EQ
            addeq r9, r9, #1
            moveq r0, r8
            bleq BSP_LED_Toggle

            cmp r8, r5
            ITT EQ
            moveq r0, r4
            bleq busy_delay

            cmp r8, r5
            ITT EQ
            moveq r0, r8
            bleq BSP_LED_Toggle

            cmp r8, r5
            ITT EQ
            moveq r0, r4
            bleq busy_delay

            is_invalid:
                cmp r6, #0       @ compare if reached 0
                IT EQ
                beq exit_func

                cmp r6, #0
                IT NE
                bne myTestLoop
    exit_func:

        mov r0, r9 @ moving counter into r0 as return value

    pop {r4-r9,lr}

bx lr



@@ ================================================================================


_bb_ascii_to_led:

    push {r4-r7,lr}

    mov r4, r0      @ move hexa value to r4
    mov r1, #0x30
    
    mov r0, #48
    sub r0, r4, r0


    

    pop {r4-r7,lr}
bx lr




@@==============================================================================================================================
@@=============== ASSIGNMENT 5 =================================================================================================



@ Function Declaration : int _bbWatch(int timeout, int delay)
@
@ Input: r0, r1 (r0 holds timeout, r1 holds delay)
@
@ Description:  This function looks at r1. It first loads the address of the A5_timeout constant into r2, so that
@               register 0 (timeout) value can be stored into the address of A5_timeout. This step is then repeated
@               for A5_delay (storing delay into address of A5_delay), A5_updated_delay (storing delay into address
@               of A5_updated_delay), A5_refresh_status (storing constant representing the watchdog should refresh
@               into address of A5_refresh_status), and A5_watch_ticks (storing constant representing the amount of
@               ticks the systick function should repreat for). r0 is ignored since it is used in the C file instead
@               to initialize the watchdog from there.
@
@ Returns: r0 (Address of A5_watch_ticks)
@
_bbWatch:

    push {lr}                               @ pushing link register onto the stack to preserve

        ldr r0, =A5_delay                   @ loading the address of A5_delay into r2
        str r1, [r0]                        @ storing r1 (delay parameter) into the address of r2 (A5_delay)

        ldr r0, =A5_updated_delay           @ loading the address of A5_updated delay into r2
        str r1, [r0]                        @ again storing r1 (delay parameter), but into the address of r2 (A5_updated_delay)

        ldr r0, =A5_refresh_status          @ loading the address of A5_refresh_status into r0
        mov r1, #A5_REFRESH_TRUE            @ moving A5_REFRESH_TRUE (0) into r1
        str r1, [r0]                        @ storing r1 (A5_REFRESH_TRUE) into the address of r0 (A5_refresh_status)

        ldr r0, =A5_watch_ticks             @ loading the address of A5_watch_ticks into r0
        mov r1, #A5_TICKS                   @ moving A5_TICKS (2) into r1
        str r1, [r0]                        @ storing r1 (A5_TICKS) into the address of r0 (A5_watch_ticks)

    pop {lr}                                @ popping preserved link register

bx lr                                       @ exiting function



@ Function Declaration : int _bb_a5_tick_handler(void)
@
@ Input: r0, r1, r2 (r0 holds timeout, r1 holds delay, r2 holds ------)
@
@ Description:  This function looks at mutiple constant values in order for this ticking function to function.
@               The function will constantly be reading the value held within the address of A5_watch_ticks. 
@               If the constant holds a value that is greater than or equal to 1, the rest of the function 
@               will the fall through. If the constant of A5_watch_ticks is less than 1, it will branch to
@               the exit label. The rest of the function then stores the default A5_ticks value back into
@               the constant, so the body of this function will execute forever. The function will then 
@               trigger the LEDs on or off (depending on if the LEDs are currently on, or currently off)
@               based on the delay value passed by the user (A5_delay). This function will finally refresh
@               the watchdog forever until the comparison to check if the A5_refresh_status is true, fails.
@               (If the button interupt occurs, the button interupt changes the A5_refresh_status to false).
@
@ Returns: r0 (scaled game_time)
@
_bb_a5_tick_handler:

    push {r4, lr}                           @ pushing values to preserve

    ldr r1, =A5_watch_ticks                 @ loading the address of A5_watch_ticks into regitser 1
    ldr r0, [r1]                            @ loading the values found within r1 (A5_watch_ticks) into r0

    subs r0, r0, #DEC_INC                   @ subtracting DEC_INC (1) from r0 and storing back into r0 with status flag
    blt _bbWatch_exit                       @ branching to exit label (_bbWatch_exit) if r0 (A5_watch_ticks) is less than #1

        mov r0, #A5_TICKS                   @ moving A5_TCIKS (2) into r0 (resetting the A5_watch_tick value) to run rest of function forever
        str r0, [r1]                        @ storing the value back into address of r1 (A5_watch_ticks) so function will continue forever

        ldr r1, =A5_updated_delay           @ loading the address of A5_updated_delay into r1
        ldr r0, [r1]                        @ loading the value found within the address of r1 into r0
        subs r0, r0, #DEC_INC               @ subtracting DEC_INC (1) from delay value (r0) and storing back into r0 with status flag
        str r0, [r1]                        @ storing the subtracted delay value (r0) and storing back into the address of r1 (A5_updated_delay)

        bgt _bbWatch_exit                   @ branching to exit label (_bbWatch_exit) if r0 is greater than 1

            ldr r1, =LEDaddress             @ Loading the GPIO address needed for LEDs
            ldr r1, [r1]                    @ Dereference r1 to get correct value
            ldrh r0, [r1]                   @ Get the current state of that GPIO (half word only)
            orr r0, r0, #A5_TRIGGER_ON      @ Using OR operation on A5_TRIGGER_ON (0xff00) to get value to trigger all leds and putting back in r0

            ldr r2, =A5_on_or_off           @ loading the address of A5_on_or_off into r2
            ldr r3, [r2]                    @ loading the value within the address of A5_on_or_off (r2) into r3

            cmp r3, #A5_OFF_STATUS          @ comparing on_or_off to zero (zero means leds are currently off)
            ITTE EQ                         @ ITTE block. Executes next 2 instructions if r3 (A5_on_or_off) is equal to 0. Last instruction if not equal
            strheq r0, [r1]                 @ storing half word that turns LEDs on back into memory of LEDaddress (r1)
            moveq r0, #A5_ON_STATUS         @ if leds are off, moving 1 (A5_ON_STATUS) into r0 (signify leds will be on in next loop)
            movne r0, #A5_OFF_STATUS        @ if r3 (A5_on_or_off) is not 0; leds are currently on (when function started). move 0 into r0, signify leds to be off

            cmp r3, #A5_ON_STATUS           @ comparing r3 (value of A5_on_or_tick) to 1
            ITT EQ                          @ ITT block. Executing the next 2 statements if r3 (value of A5_on_or_tick) is equal to 1 (cmp is successful)
            moveq r4, #A5_TRIGGER_OFF       @ Moving #0 into r4 (0 meaning set the leds off)
            strheq r4, [r1]                 @ storing half-word that turns leds off back into memory of LEDaddress (r1)

            str r0, [r2]                    @ storing the value of r0 (value which is either A5_ON_STATUS or A5_OFF_STATUS) into the address of r2 (A5_on_or_off)

            ldr r0, =A5_updated_delay       @ loading the address of A5_updated_delay into r0
            ldr r1, =A5_delay               @ loading the address of A5_delay into r0
            ldr r1, [r1]                    @ loading the value within the address of r1 (A5_delay) into r1
            str r1, [r0]                    @ storing the value of r1 (default delay value) into the address of r0 (A5_updated_delay)

            ldr r1, =A5_refresh_status      @ loading the address of A5_refresh_status into r1 
            ldr r0, [r1]                    @ loading the value within the address of A5_refresh_status (r1) into r0

            cmp r0, #A5_REFRESH_TRUE        @ comparing r0 (value of A5_refresh_status) to A5_REFRESH_TRUE (0)
            IT EQ                           @ IT block. Executes the next statements if r0 is equal to A5_REFRESH_TRUE (0)
            bleq mes_IWDGRefresh            @ branching with link to mes_ISDGRefresh function

    _bbWatch_exit:

    pop {r4, lr}                            @ popping preserved values off of the stack

bx lr                                       @ exiting function



@ Function Declaration : int _bbWatch(int timeout, int delay)
@
@ Input: r0, r1, r2 (r0 holds timeout, r1 holds delay, r2 holds ------)
@
@ Description:  This function is called within the button interupt handler (EXTI0_IRQHandler).
@               This function will load the value of A5_REFRESH_FALSE into the address of the
@               A5_refresh_status. This is done so the tick handler function knows to stop
@               refreshing the watchdog.
@
@ Returns: r0 (scaled game_time)
@
_bb_a5_button_handler:

    push {lr}                               @ pushing link register onto the stack to preserve

        ldr r1, =A5_refresh_status          @ loading the address of A5_refresh_status into r1
        mov r0, #A5_REFRESH_FALSE           @ moving A5_REFRESH_FALSE (1) into r0
        str r0, [r1]                        @ storing r0 (A5_REFRESH_FALSE) into the address of r1 (A5_refresh_status)

    pop {lr}                                @ popping link regitser off the stack to preserve

bx lr                                       @ exiting function



@@==============================================================================================================================
@@=============== LAB 8 ========================================================================================================

lab8:

    @ This code turns on only one light – can you make it turn them all on at once?

    ldr r1, =LEDaddress @ Load the GPIO address we need
    ldr r1, [r1] @ Dereference r1 to get the value we want
    ldrh r0, [r1] @ Get the current state of that GPIO (half word only)

    orr r2, r0, #0xff00
    @@ orr r0, r0, #0x0100 @ Use bitwise OR (ORR) to set the bit at 0x0100

    strh r2, [r1] @ Write the half word back to the memory address for the GPIO

        push {lr}
        mov r0, #0xffffff
        bl busy_delay
        pop {lr}

    ldr r1, =LEDaddress  @ Load the GPIO address we need
    ldr r1, [r1]         @ Dereference r1 to get the value we want
    ldrh r0, [r1]        @ Get the current state of that GPIO (half word only)

    mov r2, #0x0
    @orr r2, r0, #0x000f

    strh r2, [r1]        @ Write the half word back to the memory address for the GPIO

bx lr

@@==============================================================================================================================
@@=============== RANDOM LED LOOP ==============================================================================================

random_led_function:

    push {r4-r6, lr}                @ pushing values onto the stack in order to preserve

    mov r0, #1000
    bl mes_InitIWDG
    bl mes_IWDGStart

    loop_led_start:   

        mov r4, #WIN_LOOP_COUNTER_A4    @ moving #2 into register 1. holds the loop amount for win led blink
        ldr r5, =#WIN_DELAY             @ moving constant value for delay into r5

        rand_led_loop:

            mov r6, #MAX_LED_A4         @ moving MAX_LED_A4 (#8) into r0. The total led amount (pre-subtraction)

            rand_on_loop:
                    
                sub r6, r6, #1          @ subtracting 1 from r0, storing back into r1. r0 is current LED value

                mov r0, r6              @ moving r6 (led) into r0 to prepare for function call
                bl BSP_LED_Toggle       @ calling function to trigger LED on

                cmp r6, #0              @ comparing r0, current led, to zero
                bgt rand_on_loop        @ branching back to win_on_loop if current led  

            mov r0, r5                  @ moving delay value into r0 to prepare for function call
            bl busy_delay               @ calling delay function

            mov r6, #MAX_LED_A4         @ moving MAX_LED_A4 (#8, max led value) into register r6 to prepare for a4_win_off_loop

            rand_off_loop:

                sub r6, r6, #1          @ subtracting 1 from r6 (led value) 

                mov r0, r6              @ moving r6 (led) into r0 to prepare for function call
                bl BSP_LED_Toggle       @ calling function to trigger current LED

                cmp r6, #0              @ comparing r6, the current led value, to zero
                bgt rand_off_loop       @ branching back to a4_win_off_loop if r6 is greater than 0
                
            mov r0, r5                  @ moving delay value in r5 into r0 to prepare for function call
            bl busy_delay               @ calling delay function

            sub r4, r4, #1              @ subtracting 1 from r4 (loop counter for win blink). Storing back in r4
            cmp r4, #0                  @ comparing #0 to r4 (loop counter for win blink)
            bgt rand_led_loop           @ branching back to win_loop if r4, loop counter, is greater than 0
    
        ldr r1, =A5_refresh_status
        ldr r0, [r1]

        cmp r0, #0
        IT EQ
        bleq mes_IWDGRefresh              @------------------------- LAB 8 -------------------------------

        bal loop_led_start

    pop {r4-r6, lr}                 @ popping values off of the stack

bx lr

@@=============== RANDOM LED LOOP END ==========================================================================================
@@=============== ASSIGNMENT 4 =================================================================================================



@ Function Declaration : int bbTilt(int delay, int target, int game_time)
@
@ Input: r0, r1, r2 (r0 holds delay, r1 holds target, r2 holds game_time)
@
@ Description: This function looks at r0-r2. It first moves the parameters into r4, r5, and r6 respectively.
@              r0 is moved into r4, r1 is moved into r5, and r2 is moved into r6 in order to preserve values 
@              due to functions being called within the bbTilt function. The function then shifts the delay
@              value 9 times to the right in order to divide the value to scale to approximate miliseconds.
@              If the value after being scaled is less than or equal to zero, the delay will be set to MIN_DELAY
@              which is the minimum delay value to make the game playable, afterwords the scaled value is stored
@              within the constant A4_delay and A4_updated_delay to prepare for the game logic to start. r5, 
@              the target, is then loaded into the address of the constant A4_target to prepare for game logic.
@              The function then scales the game_time by mutiplying it by 25, then stores it back into the 
@              address of A4_game_time constant. 
@
@ Returns: r0 (scaled game_time)
@
bbTilt:

    push {r4-r6, lr}            @ pushing values onto stack to preserve

    mov r4, r0                  @ putting delay in r0, into r4
    mov r5, r1                  @ moving taret in r1, into r5
    mov r6, r2                  @ moving game_time in r2, into r6

    bl turn_off_leds            @ Calling function to turn off any leds if any are on

    ldr r1, =A4_delay           @ loading the address of A4_delay into r1

    lsr r4, r4, #MS_SHFT_VAL_A4 @ shifting to the right by 9 the value of delay in order to scale value to miliseconds
    cmp r4, #0                  @ comparing r4 (scaled delay) to 0. 0 is an invalid delay value.
    it le                       @ IT block which executes if r4 (delay) is equal to or less than 0 (0 is invalid)
    movle r4, #MIN_DELAY        @ moving MIN_DELAY (minimum delay amount) into r4 if r4 is invalid (0 or less than 0) 

    str r4, [r1]                @ storing the value of r4 (delay) into the address of r1 (A4_delay)
    ldr r1, =A4_updated_delay   @ loading the address of A4_updated_delay into r1
    str r4, [r1]                @ storing the value of r4 (delay) into the address of r1 (A4_updated_delay)

    ldr r1, =A4_target          @ loading the address of A4_target into r1
    str r5, [r1]                @ storing the value of r5 (target) into the address of r1 (A4_target)

    mov r1, #SEC_MUL_VAL_A4     @ moving multiple (25) into r0
    mul r0, r6, r1              @ multiplying the game_time value to get accurate conversion into seconds
    ldr r2, =A4_game_time       @ getting address of register 1
    str r0, [r2]                @ storing value of r1, converted game time, into the address of r2 (A4_game_time)

    pop {r4-r6, lr}             @ popping values off of the stack

bx lr                           @ exiting function



@ Function Declaration : int a4_game_time_logic(void)
@
@ Input: (no parameters)
@
@ Description:  This function looks at mutiple constant values in order for this ticking function to function.
@               The function will constantly be reading the value held within the address of A4_game_time untill
@               the constant holds a value that is greater than or equal to 1, once that happens, the rest of the
@               function will execute untill A4_game_time hits 0. The rest of the function will then check the
@               the value of A4_led_call_delay, if the value is greater than 1, it will jump to the exit label 
@               for the function. The rest of the function will execute once every 15 ticks (TICKS_TO_CALL). 
@               The function will compare the game_time to 0, if 0, the timer has run out and the player has
@               lost: branch to a4_loose (loose function). The function will then call a4_led_logic function
@               which will return the value of the current LED. It will then load that value into the address
@               of a4_curr_target. The function will then compare that value of the target led to the current
@               led and begin decrementing the delay parameter (A4_updated_delay) if the current led is equal
@               to the target led, if not equal, reset A4_updated_delay to the value of A4_delay. If the value
@               of A4_updated_delay equals 0, branch to a4_win function.
@
@ Returns: r0
@
a4_game_time_logic:

    push {r4-r7, lr}                        @ pushing values onto stack to preserve 

    ldr r1, =A4_game_time                   @ loading the address of A4_game_time into r1
    ldr r0, [r1]                            @ loading the value found in the r1 address into r0 
    subs r0, r0, #1                         @ subtracting 1 from r0 (A4_game_time) and storing back in r0 with status flag

    blt a4_game_time_exit                   @ branching to exit label if that value of r0 (A4_game_time), is less than 1

        str r0, [r1]                        @ storing the value of r0 (decremented game_time), back into the address of r1

        cmp r0, #0                          @ comparing the value of r0 (A4_game_time), to the value of 0
        it eq                               @ IT block which exicutes if values are equal
        bleq a4_loose                       @ branching with link to a4_loose if r0 is equal to 0 (timer has run out and user looses)

        ldr r1, =A4_led_call_delay          @ loading the address of A4_led_call_delay into r1
        ldr r0, [r1]                        @ loading the values found within r1 (A4_led_call_delay), into r0
        subs r0, r0, #1                     @ subtracting 1 from r0 and storing back into r0 with status flag
        str r0, [r1]                        @ storing the value of r0 back into the address of r1 (A4_led_call_delay)

        bgt a4_game_time_exit               @ branching to exit label if r0 is greater than 0

            bl a4_led_logic                 @ calling function which handels accelermotor and LED. Returns current LED value

            ldr r1, =A4_curr_target         @ Getting address of A4_curr_target and storing in r1
            str r0, [r1]                    @ Storing the return value (r0) of a4_led_logic (current led), into the address of r1 (A4_curr_target)
            
            ldr r1, =A4_target              @ getting address of A4_target and loading into r1
            ldr r0, [r1]                    @ storing the contents of in the address of (r1) A4_target into r0
            ldr r1, =A4_curr_target         @ getting address of A4_curr_target and loading into r1
            ldr r2, [r1]                    @ storing the contents of in the address of (r1) A4_curr_target into r2

            ldr r1, =A4_delay               @ loading the address of A4_delay into r1
            ldr r4, [r1]                    @ loading the value in the address of r1 (A4_delay) into r4
            ldr r5, =A4_updated_delay       @ loading the address of A4_updated_delay into r5
            ldr r3, [r5]                    @ loading the value in the address of r5 (A4_updated_delay) into r3

            cmp r2, r0                      @ comparing the current led (r2) to the larget led (r0)
            itte eq                         @ ITTE block which exicute the first 2 if r2 and r0 are equal, and exicutes the last if not equal
            subeq r3, r3, #1                @ if target led (r0) is equal to current led (r2), subtract 1 from A4_updated_delay (r3) and store back in r3
            streq r3, [r5]                  @ store the decremented delay value in the address of A4_updated_delay (r5) if target and current led is equal
            strne r4, [r5]                  @ if not equal, store the original delay value back in a4_updated_delay (r5)

            ldr r1, =A4_game_time           @ loading the address of A4_game_time into r1
            ldr r0, [r1]                    @ loading the values found in the address of r1 (A4_game_time) into r0

            ldr r6, =A4_target              @ loading the address of A4_target into r6
            ldr r7, [r6]                    @ loading the values found within the address of r6 (A4_target) into r7

            mov r2, #0                      @ move 0 into r2
            
            cmp r3, #0                      @ compare r3 (A4_updated_delay) to 0
            itt eq                          @ ITT block which exicuted if r3 and 0 are equal
            streq r2, [r1]                  @ storing r2 (0) into the address of r1 (A4_game_time) if r3 and 0 are equal. An r3 of 0 means that player has
            bleq a4_win                     @ held the board on the target for A4_delay period of time, meaning user wins. Branching to a4_win if values equal

            ldr r1, =A4_led_call_delay      @ loading the address of A4_led_call_delay into r1
            ldr r0, [r1]                    @ loading the contents within the address of r1 (A4_led_call_delay) into r0
            mov r0, #TICKS_TO_CALL          @ Moving the value of 15 (TICKS_TO_CALL) into r0
            str r0, [r1]                    @ storing r0 (15) into the address of r1 (A4_led_call_delay)

    a4_game_time_exit:                      @ exit label

    pop {r4-r7, lr}                         @ popping preserved values off of the stack

bx lr                                       @ exiting function

.size a4_game_time_logic, .-a4_game_time_logic



@ Function Declaration : a4_loose
@
@ Input: no parameters
@
@ Description:  This function looks at the constant of A4_target. The function will load the address of
@               A4_target into register 0, it will then store the value within the address of r1 into
@               into r0. A4_target contains the target led for A4. The function will then call the
@               function BSP_LED_Toggle in order to trigger the target led.
@
@ Returns: no returns
@
a4_loose:

    push {lr}               @ pushing the link register to preserve

    ldr r1, =A4_target      @ loading the address of A4_target into r1
    ldr r0, [r1]            @ loading the value within the address of r1 (A4_target) into r0
    bl BSP_LED_Toggle       @ calling function to toggle led

    pop {lr}                @ popping link register off the stack

bx lr                       @ exiting function



@ Function Declaration : a4_win
@
@ Input: no parameters
@
@ Description:  This function is used in order to blink all of the leds on the board twice, to signify
@               to the player that they have won the game. The function will store a counter into 
@               r4 which is used to check how many times the leds have blinked. The function will loop
@               through all of the leds and turn on each one, then delay, loop through all the leds and
@               turn off each one, then delay. It will repeat this twice in order to blink the lights
@               twice.
@
@ Returns: no returns
@
a4_win:

    push {r4-r6, lr}                @ pushing values onto the stack in order to preserve

    mov r4, #WIN_LOOP_COUNTER_A4    @ moving #2 into register 1. holds the loop amount for win led blink
    ldr r5, =#WIN_DELAY             @ moving constant value for delay into r5

    win_loop:

        mov r6, #MAX_LED_A4         @ moving MAX_LED_A4 (#8) into r0. The total led amount (pre-subtraction)

        a4_win_on_loop:
                
            sub r6, r6, #1          @ subtracting 1 from r0, storing back into r1. r0 is current LED value

            mov r0, r6              @ moving r6 (led) into r0 to prepare for function call
            bl BSP_LED_Toggle       @ calling function to trigger LED on

            cmp r6, #0              @ comparing r0, current led, to zero
            bgt a4_win_on_loop      @ branching back to win_on_loop if current led  

        mov r0, r5                  @ moving delay value into r0 to prepare for function call
        bl busy_delay               @ calling delay function

        mov r6, #MAX_LED_A4         @ moving MAX_LED_A4 (#8, max led value) into register r6 to prepare for a4_win_off_loop

        a4_win_off_loop:

            sub r6, r6, #1          @ subtracting 1 from r6 (led value) 

            mov r0, r6              @ moving r6 (led) into r0 to prepare for function call
            bl BSP_LED_Toggle       @ calling function to trigger current LED

            cmp r6, #0              @ comparing r6, the current led value, to zero
            bgt a4_win_off_loop     @ branching back to a4_win_off_loop if r6 is greater than 0
            
        mov r0, r5                  @ moving delay value in r5 into r0 to prepare for function call
        bl busy_delay               @ calling delay function

        sub r4, r4, #1              @ subtracting 1 from r4 (loop counter for win blink). Storing back in r4
        cmp r4, #0                  @ comparing #0 to r4 (loop counter for win blink)
        bgt win_loop                @ branching back to win_loop if r4, loop counter, is greater than 0

    a4_win_exit:

    pop {r4-r6, lr}                 @ popping values off of the stack

bx lr                               @ exiting function



@ Function Declaration : a4_led_logic
@
@ Input: no parameters
@
@ Description:  This function is used in order to trigger the correct LED when the user moves the board.
@               This function will load the I2C address into r1 and the X High value into r0 and call
@               the COMPASSACCELERO_IO_Read function which will return the current X value. Same function
@               will be called with Y High value in r0. The return value for X will be stored in r5 after
@               it has been converted to 32-bit, same will occur for Y return value (which will be stored
@               into r6). The function will then compare the X values to 16 and -16. It will branch to
@               the appropriate lable if X is greater than 16, less than -16, or inbetween those values.
@               The Y values will then be compared to -16 and 16. The approproate LED will be moved into
@               r0 after the comparison succseds. The function will then call BSP_LED_Toggle to trigger
@               the appropriate led within r0. It will then delay will the led on, then trigger the same
@               led off in order to give illusion that led is constantly on. The function will then 
@               return the triggered led value by moving it into r0.
@
@ Returns: r0 (the current LED value)
@
a4_led_logic:

    push {r4-r6, lr}                @ pushing values onto the stack to preserve

    mov r0, #ACC_I2C_ADDRESS        @ moving the I2C address into r0 to prepare for function call
    mov r1, #X_H_A                  @ moving the X High value into r1 to prepare for function call
    bl COMPASSACCELERO_IO_Read      @ calling function which will return the accelerometer value of X
    sxtb r5, r0                     @ convert r0, the X return value, into 32-bit and store in r5

    mov r0, #ACC_I2C_ADDRESS        @ moving I2C address into r0 to prepare for function call
    mov r1, #Y_H_A                  @ moving Y High values into r1 to prepare for function call
    bl COMPASSACCELERO_IO_Read      @ calling function which will return accelerometer value of Y
    sxtb r6, r0                     @ convert r0, the Y return value, into 32-bit and store in r6

    cmp r5, #POS_VALUE              @ comparing r5 (X value) with 16. (Acceletometer is from -64 to 64. 16 is 32 divided by 2)
    bgt is_positive                 @ branching to is_positive label if r5 is greater than 16.

    cmp r5, #NEG_VALUE              @ comparing r5 (X value) with -16. (Acceletometer is from -64 to 64. 16 is 32 divided by 2)
    blt is_negative                 @ branching to is_negative lable if r5 (X value), is less than -16.

    bal is_zero                     @ Always branching to is_zero (other comparisons with X failed)

    is_positive:        

        cmp r6, #POS_VALUE          @ comparing r6 (Y value) to 16. (Acceletometer is from -64 to 64. 16 is 32 divided by 2)
        itt gt                      @ ITT block which exicutes if r6 (Y) is greater than 16.
        movgt r0, #LED_6            @ moving #6 (corresponding LED) into r0 to prepare for function call
        bgt is_accel_end            @ branching to is_accel_end to exit comparisons since led is now set and ready.

        cmp r6, #NEG_VALUE          @ comparing r6 (Y value) to -16. (Acceletometer is from -64 to 64. 16 is 32 divided by 2)
        itt le                      @ ITT block which exicutes if r6 (Y) is less than -16.
        movle r0, #LED_2            @ moving #2 (corresponding LED) into r0 to prepare for function call if r6 is less than -16
        ble is_accel_end            @ branching to is_accel_end to exit comparisons since led is now set and ready.

        mov r0, #LED_4              @ moving 4 (corresponding LED) into r0 (other comparisons failed, meaning r6 (Y) is between 16 and -16)
        bal is_accel_end            @ always branching to is_accel_end to leave comparisons since led is set and ready.

    is_negative:

        cmp r6, #POS_VALUE          @ comparing r6 (Y value) to 16. (Acceletometer is from -64 to 64. 16 is 32 divided by 2)
        itt gt                      @ ITT block which executes if r6 (Y) is greater than 16.
        movgt r0, #LED_5            @ moving 5 (corresponding LED) into r0 to prepare for function call if r6 (Y) is greater than 16
        bgt is_accel_end            @ branching to is_accel_end if r6 (Y) is greater than 16 in order to exit comparisons since led is set and ready.

        cmp r6, #NEG_VALUE          @ comparing r6 (Y value) to -16. (Acceletometer is from -64 to 64. 16 is 32 divided by 2)
        itt le                      @ ITT block which executes if r6 (Y) is less than or equal to -16.
        movle r0, #LED_1            @ moving 1 into r0 (corresponding LED) into r0 to prepare for function call if r6 (Y) is greater than 16
        ble is_accel_end            @ branching to is_accel_end to exit comparisons since led is set and ready

        mov r0, #LED_3              @ moving 3 (corresponding LED) into r0 (other comparisons failed, meaning r6 (Y) is between 16 and -16)
        bal is_accel_end            @ always branching to is_accel_end to leave comparisons since led is set and ready.

    is_zero:

        cmp r6, #0                  @ comparing r6 (Y value) to 0. (Acceletometer is from -64 to 64. Greater than 0 is quadrant 1 and 2, meaning South led)
        itt gt                      @ ITT block which executes if r6 (Y) is greater than 0.
        movgt r0, #LED_7            @ moving 7 (corresponding LED) into r0 if r6 (Y) is greater than 0
        bgt is_accel_end            @ branching to is_accel_end to exit comparisons since led is set and ready.

        cmp r6, #0                  @ comparing r6 (Y value) to 0. (Acceletometer is from -64 to 64. Less than 0 is quadrant 3 and 4, meaning North led)
        itt le                      @ ITT block which executes if r6 (Y) is less than or equal to 0.
        movle r0, #LED_0                @ moving 0 (corresponding LED) into r0 if r6 (Y) is less than or equal to 0.
        ble is_accel_end            @ branching to is_accel_end to exit comparisons since led is set and ready.

    is_accel_end:

    mov r4, r0                      @ moving r0 (current LED) into r4 to preserve 

    bl BSP_LED_Toggle               @ Calling function to trigger on LED light (r0 is already set to LED)

    ldr r0, =DELAY                  @ loading the value of DELAY into r0 to prepare for function call
    bl busy_delay                   @ calling function to delay in order to give illusion led is constantly on

    mov r0, r4                      @ moving r4 (preserved LED) into r0 to prepare for function call
    bl BSP_LED_Toggle               @ calling function to trigger LED off

    mov r0, r4                      @ moving r4 (preserved LED) into r0 in order to return value back to calling function

    pop {r4-r6, lr}                 @ popping preserved values off of the stack 

bx lr                               @ exiting function

.size a4_led_logic, .-a4_led_logic



@ Function Declaration : turn_off_leds
@
@ Input: no parameters
@
@ Description:  This function is used in order to toggle off all of the leds on the board if any are on.
@               The function will loop through the leds by decrementing the value by one and looping back
@               to the off_loop lable where the call to trigger off the function is. Once r4, the register
@               holding the leds is, hits zero, the comparison will fail and the function will fall through
@               and exit, meaning all leds were toggled off if any were on previously.
@
@ Returns: no returns
@
turn_off_leds:

    push {r4, lr}          @ pushing values onto stack to preserve

    mov r4, #MAX_LED_A4    @ loading into r4 #8, number of leds pre-subtraction

    off_loop:

        sub r4, r4, #1     @ subtracting 1 from r0, storing back into r1. r0 is current LED value
        mov r0, r4
        bl BSP_LED_Off     @ calling function to trigger LED on
        cmp r4, #0         @ comparing r0, current led, to zero
        bgt off_loop       @ branching back to win_on_loop if current led  

    pop {r4, lr}           @ popping values off of the stack

bx lr                      @ exiting function




@@=============== ASSIGNMENT 4 END ==============================================================================================
@@=========================================================== Lab 7 =============================================================

test_tick:

    ldr r1, =lab_ticks          @ getting address of register 1
    str r0, [r1]                @ storing value of r3, converted game time, into lab_ticks

bx lr

_bb_lab_setup:

    push {lr}

    ldr r1, =A4_game_time
    ldr r0, [r1]
    subs r0, r0, #1

    ble game_time_exit

        str r0, [r1]
        ldr r1, =A4_led_call_delay
        ldr r0, [r1]
        subs r0, r0, #1
        str r0, [r1]

        bgt game_time_exit

            bl a4_led_logic                 @ calling function which handels accelermotor and LED. Returns current LED value

            ldr r1, =A4_curr_target         @ Getting address of constant and storing in r1
            str r0, [r1]                    @ Storing the return value (r0) of a4_led_logic (current led), into the address of r1 (A4_curr_target)
            @@-------------------------------------------------------------------------------------------------------------------------------------------------------
            
            ldr r1, =A4_target          @ getting address of A4_target and storing in r0
            ldr r0, [r1]                @ storing the contents of in the address of (r1) A4_target into r0
            ldr r1, =A4_curr_target     @ getting address of A4_curr_target and storing in r0
            ldr r2, [r1]                @ storing the contents of in the address of (r1) A4_curr_target into r2

            ldr r1, =A4_delay
            ldr r4, [r1]
            ldr r5, =A4_updated_delay
            ldr r3, [r5]

                cmp r2, r0                  @ comparing the current led (r2) to the larget led (r0)
                itte eq                     @ if equal than, than, else
                subeq r3, r3, #1            @ if the target led (r0) is equal to the current led (r2), subtract 1 from A4_updated_delay (r3) and store it back in r3
                streq r3, [r5]              @ store the decremented delay value in the address of A4_updated_delay (r5) if target and current led is equal
                strne r4, [r5]              @ if not equal, store the original delay value back in a4_updated_delay (r5)

            ldr r1, =A4_game_time
            ldr r0, [r1]

            push {r1-r3, lr}
            cmp r0, #1
            it eq
            bleq a4_loose
            pop {r1-r3, lr}

            cmp r3, #0
            it eq
            bleq a4_win

            @@-------------------------------------------------------------------------------------------------------------------------------------------------------
            ldr r1, =A4_led_call_delay
            ldr r0, [r1]
            mov r0, #1
            str r0, [r1]

    game_time_exit:

    mov r0, r3

    pop {lr}

bx lr

    .size _bb_lab_setup, .-_bb_lab_setup

_bb_lab_tick:

    push {lr}

    ldr r1, =lab_ticks
    ldr r0, [r1]

    subs r0, r0, #1

    ble _bb_lab_exit

        str r0, [r1]
        ldr r1, =lab_ticks_blinks
        ldr r0, [r1]
        subs r0, r0, #1
        str r0, [r1]

        bgt _bb_lab_exit

            @mov r0, #0
            @bl BSP_LED_Toggle

            ldr r1, =lab_ticks_blinks
            ldr r0, [r1]
            mov r0, #1
            str r0, [r1]

    _bb_lab_exit:

    pop {lr}

    bx lr

@@========================================================== Lab 7 END ===========================================================

_test_function:
     
        push {r4-r6, lr}

        @@-------

        
    @ldr r1, =lab_ticks
    @ldr r0, [r1]
    @subs r0, r0, #1

    @ble loop_lab_exit

        @@--------

        mov r0, #ACC_I2C_ADDRESS
        mov r1, #X_H_A
        bl COMPASSACCELERO_IO_Read
        sxtb r5, r0                     @ r5 holds 32-bit value of X

        mov r0, #ACC_I2C_ADDRESS
        mov r1, #Y_H_A
        bl COMPASSACCELERO_IO_Read
        sxtb r6, r0                     @ r6 holds 32-bit value of Y

        @------------------------------------NEW 4:30 VERSION--------------------------------------

        cmp r5, #16
        bgt test_is_positive

        cmp r5, #-16
        blt test_is_negative

        bal test_is_zero

        test_is_positive:

            cmp r6, #16
            itt gt
            movgt r0, #6
            bgt test_is_accel_end

            cmp r6, #-16
            itt le
            movle r0, #2
            ble test_is_accel_end

            mov r0, #4
            bal test_is_accel_end

        test_is_negative:

            cmp r6, #16
            itt gt
            movgt r0, #5
            bgt test_is_accel_end

            cmp r6, #-16
            itt le
            movle r0, #1
            ble test_is_accel_end

            mov r0, #3
            bal test_is_accel_end

        test_is_zero:

            cmp r6, #0
            itt gt
            movgt r0, #7
            bgt test_is_accel_end

            cmp r6, #0
            itt le
            movle r0, #0
            ble test_is_accel_end

        test_is_accel_end:

        mov r4, r0
        bl BSP_LED_Toggle

        ldr r0, =DELAY
        bl busy_delay

        mov r0, r4
        bl BSP_LED_Toggle

        mov r0, r4
        @loop_lab_exit:

        pop {r4-r6, lr}

bx lr

       .size _test_function, .-_test_function

tilt_win_or_loose:

    push {r0-r4, lr}                    @ pushing values onto stack to preserve for later
    @sub r3, r4, #48                     @ subtracting 48 from r4 (current led value) to get proper ascii int

    mov r3, r0 @putting led in thing

    cmp r3, r2                          @ comparing r3 (current led) to r2 (target led)
    bne tilt_game_loose                   @ branching to bb_game_loose if r3 and r2 are not equal
    mov r1, #2                          @ moving #2 into register 1. holds the loop amount for win led blink
    @mov r3, #7000                      @ moving delay mutiple into r3.
    @mul r4, r0, r3                      @ mutiplying 7000 by delay in r0 to get scaled delay amount.
    mov r4, #0xffffff

    tilt_game_win:

        mov r0, #8                      @ moving #8 into r0. The total led amount (pre-subtraction)

        tilt_win_on_loop:
            
            sub r0, r0, #1              @ subtracting 1 from r0, storing back into r1. r0 is current LED value
            push {r0, r1}                @ pushing values to prepare for function call
            bl BSP_LED_Toggle           @ calling function to trigger LED on
            pop {r0, r1}                @ popping preserved values off the stack
            cmp r0, #0                  @ comparing r0, current led, to zero
            bgt tilt_win_on_loop         @ branching back to win_on_loop if current led  

        push {r0, r1}                   @ pushing values onto stack to preserve
        mov r0, r4                      @ moving delay value into r0 to prepare for function call
        bl busy_delay                   @ calling delay function
        pop {r0, r1}                    @ popping values off of stack
        mov r0, #8                      @ moving #8 (max led value) into register 0 to prepare for win_off_loop

        tilt_win_off_loop:

            sub r0, r0, #1              @ subtracting 1 from r0 (led value) 
            push {r0, r1}               @ pushing values to prepare for function call
            bl BSP_LED_Toggle           @ calling function to trigger current LED
            pop {r0, r1}                @ popping values off of the stack
            cmp r0, #0                  @ comparing r0, current led value, to zero
            bgt tilt_win_off_loop            @ branching back to win_off_loop if r0 is greater than 0
        
        push {r0, r1}                   @ pushing values to prepare for function call
        mov r0, r4                      @ moving delay value into r0 to prepare for function call
        bl busy_delay                   @ calling delay function
        pop {r0, r1}                    @ popping preserved values off of the stack
        sub r1, r1, #1                  @ subtracting 1 from r2 (loop counter for win blink). Storing back in r2
        cmp r1, #0                      @ comparing #0 to r2 (loop counter for win blink)
        bgt tilt_game_win                 @ branching back to bb_game_win if r2, loop counter, is greater than 0
        b tilt_win_or_loose_exit     @ loop over. Branching to bb_game_win_or_loose_exit

    tilt_game_loose:

        mov r0, r2                      @ moving r2, target LED, into r0 to prepare for function call
        bl BSP_LED_Toggle               @ calling function to trigger target LED

    tilt_win_or_loose_exit:

    pop {r0-r4, lr}                     @ popping originally pushed values off the stack
    bx lr                               @ branching back to link register address

@@---------------------------------------------------------------------------------------------------------

@@-----------------------------------------------Lab 6-----------------------------------------------------

lab6_test:
        push {r4-r6, lr}

        mov r0, #ACC_I2C_ADDRESS
        mov r1, #X_H_A
        bl COMPASSACCELERO_IO_Read
        sxtb r5, r0                     @ r5 holds 32-bit value of X

        mov r0, #ACC_I2C_ADDRESS
        mov r1, #Y_H_A
        bl COMPASSACCELERO_IO_Read
        sxtb r6, r0                     @ r6 holds 32-bit value of Y

        @------------------------------------NEW 4:30 VERSION--------------------------------------

        cmp r5, #16
        bgt lab6_is_positive

        cmp r5, #-16
        blt lab6_is_negative

        bal lab6_is_zero

        lab6_is_positive:

            cmp r6, #16
            itt gt
            movgt r0, #6
            bgt lab6_is_accel_end

            cmp r6, #-16
            itt le
            movle r0, #2
            ble lab6_is_accel_end

            mov r0, #4
            bal lab6_is_accel_end

        lab6_is_negative:

            cmp r6, #16
            itt gt
            movgt r0, #5
            bgt lab6_is_accel_end

            cmp r6, #-16
            itt le
            movle r0, #1
            ble lab6_is_accel_end

            mov r0, #3
            bal lab6_is_accel_end

        lab6_is_zero:

            cmp r6, #0
            itt gt
            movgt r0, #7
            bgt lab6_is_accel_end

            cmp r6, #0
            itt le
            movle r0, #0
            ble lab6_is_accel_end

        lab6_is_accel_end:

        @------------------------------------------------------------------------------------------

        mov r4, r0

        @------------------------------------------------------------------------------------------

        @add r0, r0, #32
        @lsr r4, r0, #3

        @lsr r4, r0, #5
        @mov r0, r4
        bl BSP_LED_Toggle

        ldr r0, =DELAY
        bl busy_delay

        mov r0, r4
        bl BSP_LED_Toggle

        pop {r4-r6, lr}
        bx lr

        .size lab6_test, .-lab6_test



@@----------------------------------------------Lab 6 End--------------------------------------------------

@@--------------------------------------------Assignment 3-------------------------------------------------

@ Function Declaration : int bb_game_a3(int usrDelay, char* pattern, int win, Button_TypeDef Button)
@
@ Input: r0, r1, r2, r3 (r0 holds delay, r1 holds pattern, r2 holds target, r3 holds BUTTON_USER)
@
@ Description: This function looks at r0-r3. It increments through r3, the pattern, and blinks the
@              led accordingly. After the led turns off and delays, it checks if button has been
@              pressed (r5) and branches to function if so. The leds will blink untill the pattern
@              hits null, at that point, the bb_game_reapeat_loop will loop forever until the
@              button has been pressed.
@
@ Returns: r0
@
bb_game_a3:

    push {lr}                           @ pushing link regitser onto stack to preserve

    bb_game_repeat_loop:

        push {r0-r3}                    @ r0-r3 contain parameters, pushing values to preserve
        ldrb r4, [r1], #1               @ increments through r1, where the pattern is located
                                        @ and storing the incremented pattern in r4

        bb_led_loop:

            push {r0-r3}                @ pushing values onto the stack to prepare for function call
            mov r0, r4                  @ moving r3 (current led value) into r0 to prepare for function call
            sub r0, r0, #48             @ subtracking 48 from the current pattern value in order to
                                        @ get the accurate ascii value which contains the LED value
            bl BSP_LED_Toggle           @ calling function to trigger led
            pop {r0-r3}                 @ popping values off of the stack  
            push {r0-r3}                @ pushing values onto stack to prepare for function call
            mov r2, #7000               @ moving 7000 into r2. r2 contains the mutiple to scale delay
            mul r0, r0, r2              @ mutiplying the delay value by r2(7000) to get aprox delay
                                        @ and storing value within r0 to prepare for function call
            bl busy_delay               @ calling the delay function
            pop {r0-r3}                 @ popping the values off of the stack
            push {r0-r3}                @ pushing values to prepare for function call
            mov r0, r3                  @ moving r3 (BUTTON_USER) into r0 to prepare for function call
            bl BSP_PB_GetState          @ calling function to check if button is currently pressed
            mov r5, r0                  @ moving the return value of the button state in r0, into r5
                                        @ to store for a comparison later 
            pop {r0-r3}                 @ popping values off of the stack
            push {r0-r3}                @ pushing values onto the stack to prepare for function call
            mov r0, r4                  @ moving r4 (current led value) into r0 to prepare for function call
            sub r0, r0, #48             @ subtracking 48 in order to get accurate ascii value
            bl BSP_LED_Toggle           @ calling function to trigger led off
            pop {r0-r3}                 @ popping values off of the stack  
            push {r0-r3}                @ pushing values onto stack to prepare for function call
            mov r2, #7000               @ moving 7000 into r2. r2 contains the mutiple to scale delay
            mul r0, r0, r2              @ mutiplying the delay value by r2(7000) to get aprox delay
                                        @ and storing value within r0 to prepare for function call
            bl busy_delay               @ calling the delay function
            pop {r0-r3}                 @ popping values off of the stack
            cmp r5, #1                  @ comparing r5 (button state) to #1 (#1 represents if button pressed)
            beq bb_game_exit            @ branching to bb_exit_loop if r5 and #1 are equal. (button pressed)
            ldrb r4, [r1], #1           @ increments r1, where the pattern is located, by #1. Stores in r4.
            cmp r4, #0x0                @ comparing r4 (current pattern value) to 0x0, null.
            bne bb_led_loop             @ branching to bb_loop if r3 is not equal to null (string has not ended)

        pop {r0-r3}                     @ popping original parameters off of the stack
        bal bb_game_repeat_loop         @ always branching to bb_game_repeat loop (looping pattern forever)

    bb_game_exit:

        push {r0-r3}                    @ pushing values to prepare for function call
        bl bb_game_win_or_loose         @ calling function to show win or loose led pattern
        pop {r0-r3}                     @ popping values off the stack
        pop {r0-r3, lr}                 @ popping original parameters off of the stack

    bx lr                               @ exiting function

    .size bb_game_a3, .-bb_game_a3  

@ Function Declaration : bb_game_win_or_loose
@
@ Input: r0, r1, r2, r3, r4 (r0 holds delay, r1 holds pattern, r2 holds target, r3 holds BUTTON_USER,
@        r4 holds current led value)
@
@ Description: Function looks at r4 (current led value), and compares to target led (r2). Will branch
@              to bb_game_loose is values are not equal. bb_game_loose will then light up target led.
@              if comparison determines that r3 and r2 are equal, it will fall into bb_game_win lable.
@              It will then light up all leds, delay, turn off, then loop that cycle once more. After,
@              it will branch to bb_game_win_or_loose_exit to exit out of the function.
@
@ Returns: r0
@
bb_game_win_or_loose:

    push {r0-r3, lr}                    @ pushing values onto stack to preserve for later
    sub r3, r4, #48                     @ subtracting 48 from r4 (current led value) to get proper ascii int
    cmp r3, r2                          @ comparing r3 (current led) to r2 (target led)
    bne bb_game_loose                   @ branching to bb_game_loose if r3 and r2 are not equal
    mov r1, #2                          @ moving #2 into register 1. holds the loop amount for win led blink
    mov r3, #7000                       @ moving delay mutiple into r3.
    mul r4, r0, r3                      @ mutiplying 7000 by delay in r0 to get scaled delay amount.

    bb_game_win:

        mov r0, #8                      @ moving #8 into r0. The total led amount (pre-subtraction)

        win_on_loop:
            
            sub r0, r0, #1              @ subtracting 1 from r0, storing back into r1. r0 is current LED value
            push {r0, r1}                @ pushing values to prepare for function call
            bl BSP_LED_Toggle           @ calling function to trigger LED on
            pop {r0, r1}                @ popping preserved values off the stack
            cmp r0, #0                  @ comparing r0, current led, to zero
            bgt win_on_loop             @ branching back to win_on_loop if current led  

        push {r0, r1}                   @ pushing values onto stack to preserve
        mov r0, r4                      @ moving delay value into r0 to prepare for function call
        bl busy_delay                   @ calling delay function
        pop {r0, r1}                    @ popping values off of stack
        mov r0, #8                      @ moving #8 (max led value) into register 0 to prepare for win_off_loop

        win_off_loop:

            sub r0, r0, #1              @ subtracting 1 from r0 (led value) 
            push {r0, r1}               @ pushing values to prepare for function call
            bl BSP_LED_Toggle           @ calling function to trigger current LED
            pop {r0, r1}                @ popping values off of the stack
            cmp r0, #0                  @ comparing r0, current led value, to zero
            bgt win_off_loop            @ branching back to win_off_loop if r0 is greater than 0
        
        push {r0, r1}                   @ pushing values to prepare for function call
        mov r0, r4                      @ moving delay value into r0 to prepare for function call
        bl busy_delay                   @ calling delay function
        pop {r0, r1}                    @ popping preserved values off of the stack
        sub r1, r1, #1                  @ subtracting 1 from r2 (loop counter for win blink). Storing back in r2
        cmp r1, #0                      @ comparing #0 to r2 (loop counter for win blink)
        bgt bb_game_win                 @ branching back to bb_game_win if r2, loop counter, is greater than 0
        b bb_game_win_or_loose_exit     @ loop over. Branching to bb_game_win_or_loose_exit

    bb_game_loose:

        mov r0, r2                      @ moving r2, target LED, into r0 to prepare for function call
        bl BSP_LED_Toggle               @ calling function to trigger target LED

    bb_game_win_or_loose_exit:

    pop {r0-r3, lr}                     @ popping originally pushed values off the stack
    bx lr                               @ branching back to link register address

@@--------------------------------------------Assignment 3 End----------------------------------------------

@@-------------------------------------------------Lab 5----------------------------------------------------

@ Function Declaration : int string_test(char* dest)
@
@ Input: r0, r1 (i.e. r0 holds count, r1 holds delay)
@ Returns: r0
@
@ Here is the actual function
string_test:

    push {lr}

    @ everything in loop and exit loop work as intended - triggers all led within string and exits when null is found
    @ i just neeed to modify to add delay based on first parameter, then, the whole button thing.
    loop:

        ldrb r1, [r0], #1           @ putting this here causes 0x0 t0 continue through loop

        cmp r1, #0x0

        beq exit_loop

        push {r0, r1, lr}

        mov r0, r1

        sub r0, r0, #48

        bl BSP_LED_Toggle

        pop {r0, r1, lr}

        @ldrb r1, [r0], #1                    

        cmp r1, #0x0

        bne loop

    exit_loop:

        pop {lr}

        mov r0, r1

    bx lr

    .size string_test, .-string_test  @@ - symbol size (not req)

@@-----------------------------------------------Lab 5 End--------------------------------------------------

@@--------------------------------------------Assignment 2-------------------------------------------------

@ Function Declaration : int bb_led_demo_a2(int count, int delay)
@
@ Input: r0, r1 (i.e. r0 holds count, r1 holds delay)
@ Returns: r0
@

@ Here is the actual function
bb_led_demo_a2:

    @ldr r0, =num
    @ldr r0, =big
    @ldr r0, =huge
    @ldr r2, =num
    @ldrb r0, [r2]
    @ldr r2, =big
    @ldr r0, [r2]
    @ldr r2, =huge
    @ldrd r0, r1, [r2]


    mov r2, r1                      @ moving contents of r1 into r2 to prepare for function call
    mov r3, r0                      @ moving contents of r0 into r3 to prepare for function call
    push {r0-r2, lr}                @ Put aside registers we want to restore later
    mov r0, r2                      @ placing the r2 (delay value) into r0
    add r3, r3, #1                  @ adding 1 to the total count amount to adjust for subs loop
    bl repeat_loop                  @ calling loop function
    pop {r0-r2, lr}                 @ popping saved values off the stack

    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr)

    @ PREV: .size add_test, .-add_test
    .size bb_led_demo_a2, .-bb_led_demo_a2  @@ - symbol size (not req)

@ Function Declaration : repeat_loop
@
@ Input: r2, r3 (i.e. r2 holds delay value, r3 holds count)
@ Returns: r0
@

@ Here is the actual function
repeat_loop:

    mov r1, #8              @ putting value of 8 (Max led value) into register 1

    subs r3, r3, #1         @ loop which deducts 1 from the total count amount each time untill 0

    bgt led_loop            @ branch to led_loop function aslong as count amount is greater than or equal to 1

    pop {lr}                @ popping lr value off the stack to return to bb_led_demo_a2

    pop {lr}

    bx lr                   @ returning to lr value

led_loop:


    subs r1, r1, #1         @ loop which deducts 1 from the total led values each time untill 0

    bgt heavy_loop          @ branch to heavy_loop as long as led value is greater than or equal to 1

    b repeat_loop           @ branching back to repeat_loop after all leds have been toggled

heavy_loop:

    mov r10, r3             @ moving the contents of r3 into r10 to retreive later

    mov r4, #0              @ setting value of r0 to 0 incase a value already exists

    push {lr}               @ pushing lr value onto the stack

    bl busy_delay           @ branch to delay function to cause delay in led toggle

    mov r4, r1              @ moving contents of r1 (led value) into r4 to retrive later

    mov r0, r1              @ moving contents of r1 (led value) into r0 to prepare for next function call
    
    push {lr}               @ pushing lr value onto the stack

    bl BSP_LED_Toggle       @ calling BSP_LED_Toggle to trigger the led 

    mov r1, r4              @ putting back r4 value back into r1 to prepare for another loop

    mov r0, r2              @ putting back r2 value back into r0 to prepare for another loop

    mov r3, r10             @ putting value of counts stored in r10 back into r3

    b led_loop              @ branch back to led_loop

@@--------------------------------------------Assignment 2 End----------------------------------------------

@@-------------------------------------------Busy Delay Function--------------------------------------------

@ Function Declaration : int busy_delay(int cycles)
@
@ Input: r0 (i.e. r0 holds number of cycles to delay)
@ Returns: r0
@

@ Here is the actual function
busy_delay:

    push {r4}

    mov r4, r0

delay_loop:

    subs r4, r4, #1

    bgt delay_loop

    mov r0, #0              @ Return zero (always successful)

    pop {r4}

    bx lr                   @ Return (Branch eXchange) to the address in the link register (lr)

@@-----------------------------------------Busy Delay Function End------------------------------------------


@ Assembly file ended by single .end directive on its own line
.end

Things past the end directive are not processed, as you can see here.
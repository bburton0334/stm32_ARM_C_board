/*
* C to assembler menu hook
*
*/

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "stm32f3xx_hal.h"
#include "stm32f3_discovery.h"
#include "stm32f3_discovery_accelerometer.h"
#include "stm32f3_discovery_gyroscope.h"

#include "common.h"
#include "watchdog.h"

//============= test =============================

int myTest(int delay, int led);

void _myTest(int action)
{

    uint32_t delay;
    int delay_status;

    delay_status = fetch_uint32_arg(&delay);
    if (delay_status) {
        delay = 0xffffff;
    }

    uint32_t led;
    int led_status;

    led_status = fetch_uint32_arg(&led);
    if (led_status) {
        led = 5;
    }

    printf("myTest returned: %d\n", myTest(delay, led) );
}


ADD_CMD("myTest", _myTest,"Test the led button watchdog function")


//==============================================================================================================================
//=============== ASSIGNMENT 5 =================================================================================================

// function defenition for assembly file
int _bbWatch(int timeout, int delay);

//
// FUNCTION         : bb_watch
// DESCRIPTION      :
//      This function checks the the user input in the minicom. It takes
//      2 parameters from the user: timeout, and delay. If the user
//      does not provide parameters, default parameters will be set.
//
// PARAMETERS       : int action
// RETURNS          : none
//
void bb_watch(int action)
{
    uint32_t timeout;
    int timeout_status;

    timeout_status = fetch_uint32_arg(&timeout);
    if (timeout_status) {
        timeout = 1000;
    }

    uint32_t delay;
    int delay_status;

    delay_status = fetch_uint32_arg(&delay);
    if (delay_status) {
        delay = 500;
    }

    mes_InitIWDG(timeout);
    mes_IWDGStart();

    if(action==CMD_SHORT_HELP) return;

    if(action==CMD_LONG_HELP) {
        printf("bbWatch\n\n" "This command tests the led button watchdog function\n");
        return;
    }

    printf("_bbWatch returned: %d\n", _bbWatch(timeout, delay) );
}

ADD_CMD("bbWatch", bb_watch,"Test the led button watchdog function")


//==============================================================================================================================
//=============== LAB 8 WATCHDOG ===============================================================================================


// int watchdog(int rand);

void bb_watchdog(int action)
{
    uint32_t rand;
    int rand_status;

    rand_status = fetch_uint32_arg(&rand);
    if (rand_status) {
        rand = 0;
    }

    mes_InitIWDG(rand);
    mes_IWDGStart();
    mes_IWDGRefresh();

   //printf("watchdog returned: %d\n", watchdog(rand) );
}

ADD_CMD("watchdog", bb_watchdog,"Test watchdog")


//==============================================================================================================================
//=============== LAB 8 PIN ====================================================================================================


int lab8(int rand);

void bb_lab_8(int action)
{
    uint32_t rand;
    int rand_status;

    rand_status = fetch_uint32_arg(&rand);
    if (rand_status) {
        rand = 0;
    }

    printf("lab8 returned: %d\n", lab8(rand) );
}

ADD_CMD("lab8", bb_lab_8,"Test Lab 8 (pins and led)")


//==============================================================================================================================
//=============== RANDOM LED FUNCTION ==========================================================================================


int random_led_function(int rand);

void bb_random_led_function(int action)
{
    uint32_t rand;
    int rand_status;

    rand_status = fetch_uint32_arg(&rand);
    if (rand_status) {
        rand = 0;
    }

    printf("random_led_function returned: %d\n", random_led_function(rand) );
}

ADD_CMD("randled", bb_random_led_function,"Test random_led_function")


//==============================================================================================================================
//=============== ASSIGNMENT 4 =================================================================================================



// function defenition for assembly file
int bbTilt (int delay, int target, int game_time);

//
// FUNCTION         : bb_tilt_game
// DESCRIPTION      :
//      This function checks the the user input in the minicom. It takes
//      3 parameters from the user: delay, target, and game_time. If the
//      the user does not provide parameters, default parameters will
//      be set.
// PARAMETERS       : int action
// RETURNS          : none
//
void bb_tilt_game(int action)
{
    uint32_t delay;
    int delay_status;

    delay_status = fetch_uint32_arg(&delay);
    if (delay_status) {
        delay = 500;
    }

    uint32_t target;
    int target_status;

    target_status = fetch_uint32_arg(&target);
    if (target_status){
        target = 0;
    }

    uint32_t game_time;
    int game_time_status;

    game_time_status = fetch_uint32_arg(&game_time);
    if (game_time_status){
        game_time = 10;
    }

    if(action==CMD_SHORT_HELP) return;

    if(action==CMD_LONG_HELP) {
        printf("bbTilt game\n\n" "This command tests the led tilt game function\n");
        return;
    }


     printf("bbTilt returned: %d\n", bbTilt(delay, target, game_time) );
}

ADD_CMD("bbTilt", bb_tilt_game,"Test the led tilt game")



//=============== ASSIGNMENT 4 END ==============================================================================================

//------------------------------------LAB 7-----------------------------------------

int _bb_lab_setup(int ticks, int ticksToBlinks);
//int a4_game_time_logic(int ticks, int ticksToBlinks);

void _bb_lab7(int action)
{
    uint32_t ticks;
    int ticks_status;

    ticks_status = fetch_uint32_arg(&ticks);
    if (ticks_status) {
        ticks = 25;
    }

    uint32_t ticksToBlinks;
    int ticksToBlinks_status;

    ticksToBlinks_status = fetch_uint32_arg(&ticksToBlinks);
    if (ticksToBlinks_status){
        ticksToBlinks = 500;
    }

    printf("_bb_lab_setup returned: %d\n", _bb_lab_setup(ticks, ticksToBlinks) );
}

ADD_CMD("lab7setup", _bb_lab7,"Test lab 7 setup")

int test_tick(int test);

void testTick(int action)
{
    uint32_t test;
    int test_status;

    test_status = fetch_uint32_arg(&test);
    if (test_status) {
        test = 5000;
    }

    printf("test_tick returned: %d\n", test_tick(test) );

    //printf("_bb_lab_tick returned: %d\n", _bb_lab_tick(test) );
    //_bb_lab_tick();
}

ADD_CMD("tick", testTick,"Test the Tick")


//----------------------------------END LAB 7---------------------------------------

//------------------------------------LAB 6-----------------------------------------

int lab6_test(int coordinate);  //L-6

void lab6(int action)
{ 
    if(action==CMD_SHORT_HELP) return;
    if(action==CMD_LONG_HELP) 
    {
        printf("lab6 Test\n\n"
        "This command tests new lab6 function\n"
        );
        return;
    }
    
    uint32_t input;
    int fetch_status1;

    fetch_status1 = fetch_uint32_arg(&input);

    if(fetch_status1) 
    {
        // Use a default value
        input = 0;
    }

    //for (int i = 0;i<50;i++)
    //{
        printf("lab6_test (accelerometer test) returned: %d\n", lab6_test(input));
    //}
    
}
ADD_CMD("Lab6",lab6, "tests lab-6")


//----------------------------------END LAB 6---------------------------------------

//--------------------------
//      Assignment 3
//--------------------------

// function defenition for assembly file
int bb_game_a3(int usrDelay, char* pattern, int win, Button_TypeDef Button);

//
// FUNCTION         : _bb_A3
// DESCRIPTION      :
//      This function checks the the user input in the minicom. It takes
//      3 parameters from the user: usrDelay, pattern, and win. If the
//      the user does not provide parameters, default parameters will
//      be set. Button is always a default parameter. Function will
//      return the value of r0.
// PARAMETERS       : int action
// RETURNS          : none
//
void _bb_A3(int action)
{
    uint32_t usrDelay;
    int usrDelay_status;

    usrDelay_status = fetch_uint32_arg(&usrDelay);
    if (usrDelay_status) {
        usrDelay = 500;
    }

    int fetch_status;
    char *pattern;

    fetch_status = fetch_string_arg(&pattern);
    if(fetch_status) {
        pattern = "43567011";
    }

    uint32_t win;
    int win_status;

    win_status = fetch_uint32_arg(&win);
    if (win_status) {
        win = 5;
    }

    printf("bb_game_a3 returned: %d\n", bb_game_a3(usrDelay, pattern, win, BUTTON_USER) );
}

ADD_CMD("bbGame", _bb_A3,"Test the new led game function")

//--------------------------
//      End of Assign 3
//--------------------------

//-----------------
//      lab 5
//-----------------

int string_test(char *dest);    // was *p

void _lab_5(int action)
{
    int fetch_status;
    char *dest;

    fetch_status = fetch_string_arg(&dest);
    if(fetch_status) {
        dest = "hello";
    }

    printf("string_test returned: %d\n", string_test(dest) );
}

ADD_CMD("lab5", _lab_5,"Test the new led demo function")

//--------------------
//      lab 5 end
//--------------------

int bb_led_demo_a2(int count, int delay);

void _bb_A2(int action)
{
    uint32_t count;
    int count_status;

    count_status = fetch_uint32_arg(&count);
    if (count_status) {
        count = 1;
    }

    uint32_t delay;
    int delay_status;

    delay_status = fetch_uint32_arg(&delay);
    if (delay_status) {
        delay = 0xffffff;
    }

    // original here and below
    if(action==CMD_SHORT_HELP) return;

    if(action==CMD_LONG_HELP) {
        printf("Addition Test\n\n" "This command tests new addition function\n");
        return;
    }

    printf("bb_led_demo_a2 returned: %d\n", bb_led_demo_a2(count, delay) );
}

ADD_CMD("leddemo", _bb_A2,"Test the new led demo function")



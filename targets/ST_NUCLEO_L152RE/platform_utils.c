/*
 * platform_utils.c
 *
 * All rights reserved.
 *
 *  Created on: 17-10-2013
 *      Author: Karol Lasończyk
 */

#include "platform_utils.h"

#include "ch.h"
#include "hal.h"

/*
 * UART driver configuration structure.
 */
static UARTConfig uart_cfg_1 = {
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  115200,
  0,
  USART_CR2_LINEN,
  0
};

/**
 * @brief Init function executed in first lines of tests. Started properly Chibios and ARM
 */
void init(void)
{
	/*
	 * System initializations.
	 * - HAL initialization, this also initializes the configured device drivers
	 *   and performs the board-specific initializations.
	 * - Kernel initialization, the main() function becomes a thread and the
	 *   RTOS is active.
	 */
	halInit();
	chSysInit();

        start_count_time();
        chThdSleepMilliseconds(1000);
        stop_count_time();

        /*
         * Initializes a uart driver.
         */
        uartStart(&UARTD2, &uart_cfg_1);

        /*
         * Activates the serial driver 2 using the driver default configuration.
         * PA2(TX) and PA3(RX) are routed to USART2.
         */
        palSetPadMode(GPIOA, 2, PAL_MODE_ALTERNATE(4));
        palSetPadMode(GPIOA, 3, PAL_MODE_ALTERNATE(4));

        /*
         * Stopping and restarting the USB in order to test the stop procedure. The
         * following lines are not usually required.
         */
        info("-------------------ARM system SDK------------------");
        info("CPU frequency %f MHz", STM32_SYSCLK/1000000.0);
        info("TIM frequency %f MHz", STM32_TIMCLK2/1000000.0);
        info("---------------------------------------------------");
        info("-----------------Timer second test-----------------");
        info("Start timer and wait 1 sec");
        start_count_time();
        chThdSleepMilliseconds(1000);
        stop_count_time();
        info("Timer result 1sec = %u us", get_us());
        info("---------------------------------------------------");

#ifdef NUCLEO_SECOND_TEST
        while(1){
            info("Start timer and wait 1 sec");
            start_count_time();
            chThdSleepMilliseconds(1000);
            stop_count_time();
            info("Timer result 1sec = %u us", get_us());
        }
#endif
}

void inf_loop(void){
    while(1){
        chThdSleepSeconds(1);
    }
}


/**
 * @brief start counting time
 */
void start_count_time(void)
{
}

/**
 * @brief stop counting time
 */
void stop_count_time(void)
{
}
/**
 * @brief Function returns elapsed time (stop-start) in µs
 * @return time in µs
 */
uint32_t get_us(void)
{
    uint32_t result = 0;
    return RTC2US(STM32_TIMCLK2, result);
}

uint32_t get_ticks(void)
{
    uint32_t result = 0;
    return result;
}

/**
 * @brief Function required to properly using format library
 * @param c char
 * @return
 */
int putchar(int c)
{
    uartStartSend(&UARTD2, 1, (void*) &c);
    chThdSleepMicroseconds(1);
    return 1;
}

void sdk_delay_ms(uint32_t ms)
{
	chThdSleepMilliseconds(ms);
}


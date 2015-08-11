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
#include "usb.h"

// addresses of registers
volatile uint32_t *DWT_CONTROL = (uint32_t *)0xE0001000;
volatile uint32_t *DWT_CYCCNT = (uint32_t *)0xE0001004;
volatile uint32_t *DEMCR = (uint32_t *)0xE000EDFC;


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

        /* Timer configuration.*/
        *DEMCR = *DEMCR | 0x01000000;
        rccEnableTIM5(FALSE);
        rccResetTIM5();
        TIM5->CR1  = 0;                          /* Initially stopped.       */

        TIM5->CR2  = 0;
        TIM5->PSC  = 0;                          /* Prescaler value.         */
        TIM5->SR   = 0;                          /* Clear pending IRQs.      */
        TIM5->DIER = 0;
        TIM5->SMCR = 0;

        TIM5->CNT  = 0;                          /* Initially stopped.       */

        start_count_time();
        chThdSleepMilliseconds(1000);
        stop_count_time();

        /*
         * Initializes a serial-over-USB CDC driver.
         */
        sduObjectInit(&SDU1);
        sduStart(&SDU1, &serusbcfg);

        /*
         * Activates the USB driver and then the USB bus pull-up on D+.
         * Note, a delay is inserted in order to not have to disconnect the cable
         * after a reset.
         */
        usbDisconnectBus(serusbcfg.usbp);
        chThdSleepMilliseconds(250);
        usbStart(serusbcfg.usbp, &usbcfg);
        usbConnectBus(serusbcfg.usbp);

        /*
         * Stopping and restarting the USB in order to test the stop procedure. The
         * following lines are not usually required.
         */
        chThdSleepMilliseconds(3000);
	info("---------------ECDSA ECDH Test Suite---------------");
        info("CPU frequency %f MHz", STM32_SYSCLK/1000000.0);
        info("TIMER frequency %f MHz", STM32_TIMCLK1/1000000.0);
	info("---------------------------------------------------");
        info("-----------------Timer second test-----------------");
        info("Start timer and wait 1 sec");
        start_count_time();
        chThdSleepMilliseconds(1000);
        stop_count_time();
        info("Timer result 1sec = %u us", get_us());
        info("---------------------------------------------------");
}

void inf_loop(void){
    chThdSleepMilliseconds(1000);
    usbDisconnectBus(serusbcfg.usbp);
    while(1){
        chThdSleepSeconds(1);
    }
}

/**
 * @brief start counting time
 */
void start_count_time(void)
{
    TIM5->CNT  = 0;
    TIM5->CR1 = TIM_CR1_CEN;
    *DWT_CYCCNT = 0;
    *DWT_CONTROL = *DWT_CONTROL | 1 ;

}

/**
 * @brief stop counting time
 */
void stop_count_time(void)
{
    TIM5->CR1 = 0;
    *DWT_CONTROL &= 0xFE;
}
/**
 * @brief Function returns elapsed time (stop-start) in µs
 * @return time in µs
 */
uint32_t get_us(void)
{
    return RTC2US(STM32_SYSCLK, *DWT_CYCCNT);
    //return RTC2US(STM32_TIMCLK1, TIM5->CNT);
}

uint32_t get_ticks(void)
{
    return *DWT_CYCCNT;
}

/**
 * @brief Function required to properly using format library
 * @param c char
 * @return
 */
int fm_putchar(int c)
{
    chSequentialStreamPut(&SDU1, (uint8_t)c);
    return 1;
}

void sdk_delay_ms(uint32_t ms)
{
	chThdSleepMilliseconds(ms);
}

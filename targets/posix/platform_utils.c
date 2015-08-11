/*
 * platform_utils.c
 *
 * All rights reserved.
 *
 *  Created on: 17-10-2013
 *      Author: Karol Lasończyk
 */

#include "platform_utils.h"

#include <sys/time.h>
#include <stdio.h>

struct timeval start, stop;

/**
 * @brief Init function executed in first lines of tests
 */
void init(void)
{

}

void inf_loop(void)
{

}
/**
 * @brief start counting time
 */
void start_count_time(void)
{
	gettimeofday(&start, NULL );
}
/**
 * @brief stop counting time
 */
void stop_count_time(void)
{
	gettimeofday(&stop, NULL );
}
/**
 * @brief Function returns elapsed time (stop-start) in µs
 * @return time in µs
 */
uint32_t get_us(void)
{
	int diff = (stop.tv_usec + 1000000 * stop.tv_sec) - (start.tv_usec + 1000000 * start.tv_sec);
	return diff;
}

uint32_t get_ticks(void)
{
    return 0;
}

/**
 * @brief Function required to properly using format library
 * @param c char
 * @return
 */
int putchar(int c)
{
	return putchar(c);
}

void sdk_delay_ms(uint32_t ms)
{
	usleep(ms * 1000);
}

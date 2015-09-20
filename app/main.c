#include "ch.h"
#include "hal.h"
#include "platform_utils.h"

/*
 * Application entry point.
 */
int main(void) {

	uint8_t i=0;
	init();

	while (true) {
		info("%i", i++);
		chThdSleepMilliseconds(100);
	}
}

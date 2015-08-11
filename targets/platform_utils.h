#ifndef PLATFORM_UTILS_H_
#define PLATFORM_UTILS_H_

#include <stdint.h>

//Platform dependent code
#include <assert.h>
#include <stdlib.h>

//Platform independent code

#include "format.h"
#include "printf.h"

#ifndef PRINT_INFO_DISABLE

#define error(_format, ...) printf("\r\nERROR: %s [%d] :" # _format, __FILE__,__LINE__, ##__VA_ARGS__)
#define warn(_format, ...)  printf("\r\nWARN: %s [%d] :" #  _format, __FILE__,__LINE__, ##__VA_ARGS__)
#define info(_format, ...)  printf("\r\nINFO: %s [%d] :" # _format, __FILE__,__LINE__, ##__VA_ARGS__)
#define debug(_format, ...) printf("\r\nDEBUG: %s [%d] :"# _format, __FILE__,__LINE__, ##__VA_ARGS__)

#else
#define error(_format, ...)
#define warn(_format, ...)
#define info(_format, ...)
#define debug(_format, ...)
#endif

#define UNUSED(x)   (void)(x);

void init(void);
void inf_loop(void);

void start_count_time(void);
void stop_count_time(void);
uint32_t get_us(void);
uint32_t get_ticks(void);

void sdk_delay_ms(uint32_t ms);

#endif

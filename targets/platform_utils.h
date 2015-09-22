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

static char *__error_label __attribute__ ((unused)) = "ERROR";
static char *__warn_label  __attribute__ ((unused)) = "WARN";
static char *__info_label  __attribute__ ((unused)) = "INFO";
static char *__debug_label __attribute__ ((unused)) = "DEBUG";

#define error(_format, ...) printf("\r\n%5s: %s [%d] :"# _format, __error_label, __FILE__,__LINE__, ##__VA_ARGS__)
#define warn(_format, ...)  printf("\r\n%5s: %s [%d] :"# _format, __warn_label,  __FILE__,__LINE__, ##__VA_ARGS__)
#define info(_format, ...)  printf("\r\n%5s: %s [%d] :"# _format, __info_label,  __FILE__,__LINE__, ##__VA_ARGS__)
#define debug(_format, ...) printf("\r\n%5s: %s [%d] :"# _format, __debug_label, __FILE__,__LINE__, ##__VA_ARGS__)

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

#endif

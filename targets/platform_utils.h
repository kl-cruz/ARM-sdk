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
#define ERROR_LABEL 1
#define WARN_LABEL 2
#define INFO_LABEL 3
#define DEBUG_LABEL 4

static char *__print_labels[] = {
	"ERROR",
	"WARN",
	"INFO",
	"DEBUG",
};

#define error(_format, ...) printf("\r\n%s: %s [%d] :" # _format, __print_labels[ERROR_LABEL], __FILE__,__LINE__, ##__VA_ARGS__)
#define warn(_format, ...)  printf("\r\%s: %s [%d] :" #  _format, __print_labels[WARN_LABEL], __FILE__,__LINE__, ##__VA_ARGS__)
#define info(_format, ...)  printf("\r\n%s: %s [%d] :" # _format, __print_labels[INFO_LABEL], __FILE__,__LINE__, ##__VA_ARGS__)
#define debug(_format, ...) printf("\r\n%s: %s [%d] :"# _format, __print_labels[DEBUG_LABEL], __FILE__,__LINE__, ##__VA_ARGS__)

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

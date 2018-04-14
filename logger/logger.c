#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <errno.h>
#include "logger.h"

static int logger_mode = LOGGER_VERBOSE;

int nb_errors = 0;

void logger_set_mode(const int mode) {
	if (mode < LOGGER_SILENT || LOGGER_VERBOSE < mode) {
		log_error("LOGGER ERROR: Incorrect mode\n");
		exit(EXIT_FAILURE);
	}
	logger_mode = mode;
}

int logger_get_nb_errors() {
	return nb_errors;
}

void log_error(const char * message, ...) {
	nb_errors++;
	if(logger_mode == LOGGER_VERBOSE) {
		va_list args;
		va_start(args, message);
		printf("%s[ERROR]%s ", COLOR_RED, RESET);
		vprintf(message, args);
		va_end(args);
		printf("\n");
	}
}

void log_error_with_line_number(const int line_number, const char * message, ...) {
	nb_errors++;
	if(logger_mode == LOGGER_VERBOSE) {
		va_list args;
		va_start(args, message);
		printf("%s[ERROR]%s ", COLOR_RED, RESET);
		vprintf(message, args);
		va_end(args);
		printf("\n\tat line %d\n", line_number);
	}
}

void log_info(const char * message, ...) {
	if(logger_mode == LOGGER_VERBOSE) {
		va_list args;
		va_start(args, message);
		printf("%s[INFO]%s ", COLOR_BLUE, RESET);
		vprintf(message, args);
		va_end(args);
		printf("\n");
	}
}

void log_info_with_line_number(const int line_number, const char * message, ...) {
	if(logger_mode == LOGGER_VERBOSE) {
		va_list args;
		va_start(args, message);
		printf("%s[INFO]%s ", COLOR_BLUE, RESET);
		vprintf(message, args);
		va_end(args);
		printf("\n\tat line %d\n", line_number);
	}
}
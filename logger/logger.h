#ifndef PROGSYS_LOGGER_H
#define PROGSYS_LOGGER_H

#define LOGGER_SILENT 0
#define  LOGGER_VERBOSE 1

#define COLOR_RED   "\x1B[31m"
#define COLOR_GREEN "\x1B[32m"
#define COLOR_BLUE  "\x1B[36m"
#define RESET        "\033[0m"

void logger_set_mode(const int mode);

int logger_get_nb_errors();

void log_error(const char *message, ...);

void log_error_with_line_number(const int line_number, const char *message, ...);

void log_info(const char *message, ...);

void log_info_with_line_number(const int line_number, const char *message, ...);

void log_print(const char * message, ...);

#endif
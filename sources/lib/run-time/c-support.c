#include <stdbool.h>
#include <stdlib.h>

void *call_dylan_function(void *function, size_t arg_count, ...)
{
  return NULL;
}

void *dylan_keyboard_break_handler = NULL;

bool dylan_keyboard_interruptQ = false;
bool Prunning_under_dylan_debuggerQ = false;

void* get_current_thread_handle()
{
  return NULL;
}

void *class_allocation_break(char *string, void *class, int count, int size)
{
  return NULL;
}

void *dylan_callin_internal(void *arg_base, size_t s)
{
  return NULL;
}


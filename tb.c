#include <stdlib.h>
#include <vpi_user.h>

int state = 0;
int in1[] = {0, 1, 0, 1};
int in2[] = {0, 0, 1, 1};
int should_be[] = {0, 1, 1, 0};


int check(char *data) {

  vpiHandle systfref, args_iter, argh; 
  struct t_vpi_value argval; 
  int value; 

  systfref = vpi_handle(vpiSysTfCall, NULL); 
  args_iter = vpi_iterate(vpiArgument, systfref); 

  argh = vpi_scan(args_iter); 
  argval.format = vpiIntVal; 
  vpi_get_value(argh, &argval); 
  value = argval.value.integer; 

  vpi_printf("%d %d %d", in1[state], in2[state], value);
  if (value == should_be[state])
	vpi_printf(" : OK\n");
  else
	vpi_printf(" : FAIL\n");

  state++;

  return 0;
}

void init_usertfs() {
  s_vpi_systf_data task_data_s;
  s_vpi_systf_data task_data_s1;

  p_vpi_systf_data task_data_p1 = &task_data_s1;
  p_vpi_systf_data task_data_p = &task_data_s;

  task_data_p1->type = vpiIntFunc;
  task_data_p1->tfname = "$check";
  task_data_p1->calltf = check;
  task_data_p1->compiletf = 0;


  vpi_register_systf(task_data_p1);
}

// Зарегистрировать новую системную процедуру
void (*vlog_startup_routines[ ] ) () = {
   init_usertfs,
   0  // Последним элементом должен быть 0 
};


#include <stdio.h>
#include <stdlib.h>

#define IN_TIME(time, from, to) (\
    ( ( (from) < (to) ) && ( (from) <= (time) && (time) < (to) ) ) || \
    ( ( (from) == (to) ) && ( (from) == (time) ) ) || \
    ( ( (from) > (to) ) && ( (from) <= (time) || (time) < (to) ) ) \
)

void abort(void);
#define TEST(msg, cond) { if ( !(cond) ) { fprintf(stderr,  msg "\n"); abort();  } }

int main()
{

  TEST("before start time should not be in time.", !IN_TIME(5, 6, 20));
  TEST("start time should be in time.", IN_TIME(6, 6, 20));
  TEST("before end time should be in time.", IN_TIME(19, 6, 20));
  TEST("end time should not be in time.", !IN_TIME(20, 6, 20));

  TEST("before start time should not be in time (reverse)", !IN_TIME(19, 20, 6));
  TEST("start time should be in time ( reverse )", IN_TIME(20, 20, 6));
  TEST("before end time should be in time ( reverse )", IN_TIME(5, 20, 6));
  TEST("end time should noo be in time ( reverse ).", !IN_TIME(6, 20, 6));

  TEST("in case start time and end time.", IN_TIME(5, 5, 5));
  TEST("in case start time and end time.", !IN_TIME(4, 5, 5));

  printf("success!! all test passed!!\n");
  return 0;
}


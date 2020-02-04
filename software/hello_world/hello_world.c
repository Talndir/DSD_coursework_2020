#include <stdlib.h>
#include <sys/alt_stdio.h>
#include <sys/alt_alarm.h>
#include <sys/times.h>
#include <alt_types.h>
#include <system.h>
#include <stdio.h>
#include <unistd.h>
#include <math.h>

#define TEST 1

#if TEST == 1

// Test case 1
#define STEP 5
#define N 52

#elif TEST == 2

// Test case 2
#define STEP (1/8.0)
#define N 2041

#else

//Test case 3, default
#define STEP (1/1024.0)
#define N 261121

#endif

// Generates the vector x and stores it in the memory
void generateVector(float *x, int start, int length)
{
	float v = start * STEP;
	for (unsigned int i = 0; i < length; ++i)
	{
		x[i] = v;
		v += STEP;
	}
}

float sumVector(float *x, int length)
{
	float sum = 0.f;
	for (unsigned int i = 0; i < length; ++i)
	{
		sum += x[i] * (0.5f + x[i] * cos((x[i] / 128.f) - 1.f));
	}

	return sum;
}

long unsigned runOnce()
{
	float x[N];
	clock_t exec_t1, exec_t2;
	generateVector(x, 0, N);
	exec_t1 = times(NULL); 	// Get time before starting
	float y = sumVector(x, N);
	exec_t2 = times(NULL); 	// Get time after finishing

	long unsigned time = exec_t2 - exec_t1;
	printf(" proc time = %lu ms\n", time);
	printf(" Result = %f\n", y);
	return time;
}

int main()
{
	printf("Task 2!\n");

	// Run 10 times
	long unsigned sum = 0;
	for (unsigned int i = 0; i < 10; ++i)
		sum += runOnce();
	sum /= 10;
	printf("Average time: %lu\n", sum);

	return 0;
}

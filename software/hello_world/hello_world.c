#include <stdlib.h>
#include <sys/alt_stdio.h>
#include <sys/alt_alarm.h>
#include <sys/times.h>
#include <alt_types.h>
#include <system.h>
#include <stdio.h>
#include <unistd.h>
#include <math.h>
#include <tgmath.h>
#include <altera_avalon_performance_counter.h>

#define FUNC(A,B) __builtin_custom_fnpi(0x1,(A),(B))
#define PERFORMANCE_COUNTER_0_BASE 0x801020

#define TEST 3

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
	PERF_BEGIN(PERFORMANCE_COUNTER_0_BASE, 1);
	float y = FUNC(x, length);
	PERF_END(PERFORMANCE_COUNTER_0_BASE, 1);
	return y;
}

long unsigned runOnce(float *x)
{
	clock_t exec_t1, exec_t2;
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
	PERF_RESET(PERFORMANCE_COUNTER_0_BASE);

	printf("Task 8!\n");
	printf("Test %u\n", TEST);
#ifdef LOOKUP
	initLookup();
#endif
	float x[N];
	generateVector(x, 0, N);

	// Run 10 times
	PERF_START_MEASURING(PERFORMANCE_COUNTER_0_BASE);
	long unsigned sum = 0;
	for (unsigned int i = 0; i < 5; ++i)
		sum += runOnce(x);
	sum /= 5;
	printf("Average time: %lums\n", sum);
	PERF_STOP_MEASURING(PERFORMANCE_COUNTER_0_BASE);

	perf_print_formatted_report(
			(void *)PERFORMANCE_COUNTER_0_BASE,
			alt_get_cpu_freq(),
			1,
			" FUNC");

	return 0;
}

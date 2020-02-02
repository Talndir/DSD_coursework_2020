#include <stdlib.h>
#include <sys/alt_stdio.h>
#include <sys/alt_alarm.h>
#include <sys/times.h>
#include <alt_types.h>
#include <system.h>
#include <stdio.h>
#include <unistd.h>

#define TEST 3
#define ARR_SIZE 256

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
#define N 26112//1

#endif

// Generates the vector x and stores it in the memory
void generateVector(float x[ARR_SIZE], int start, int length)
{
	float v = start * STEP;
	for (unsigned int i = 0; i < length; ++i)
	{
		x[i] = v;
		v += STEP;
	}
}

float sumVector(float x[ARR_SIZE], int length)
{
	float sum = 0.f;
	for (unsigned int i = 0; i < length; ++i)
	{
		sum += x[i] * (x[i] + 1.f);
	}

	return sum;
}

long unsigned runOnce()
{
	float x[ARR_SIZE];
	long unsigned time = 0;
	clock_t exec_t1, exec_t2;

	float y = 0.f;
	int pos = 0;
	while (N - pos > ARR_SIZE)
	{
		generateVector(x, pos, ARR_SIZE);
		exec_t1 = times(NULL); 	// Get time before starting
		y += sumVector(x, ARR_SIZE);
		exec_t2 = times(NULL); 	// Get time after finishing
		time += exec_t2 - exec_t1;
		pos += ARR_SIZE;
	}
	if (pos != N)
	{
		generateVector(x, pos, N - pos);
		exec_t1 = times(NULL); 	// Get time before starting
		y += sumVector(x, N - pos);
		exec_t2 = times(NULL); 	// Get time after finishing
		time += exec_t2 - exec_t1;
	}

	printf(" proc time = %lu ms\n", time);

	int n = 0;
	while (y > 10e9)
	{
		y /= 2.f;
		++n;
	}
	while (y < 10e8)
	{
		y *= 2.f;
		--n;
	}

	printf(" Result (divided by 2^%d) = %d\n", n, (int)y);
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

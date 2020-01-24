#include <stdlib.h>
#include <sys/alt_stdio.h>
#include <sys/alt_alarm.h>
#include <sys/times.h>
#include <alt_types.h>
#include <system.h>
#include <stdio.h>
#include <unistd.h>

#define TEST 2

#if TEST == 1

// Test case 1
#define STEP 5
#define N 52

#elif TEST == 2

// Test case 2
#define STEP 1/8.0
#define N 2041

#else

//Test case 3, default
#define STEP 1/1024.0
#define N 5000 //261121

#endif

// Generates the vector x and stores it in the memory
void generateVector(float x[N])
{
	float v = 0;
	for (unsigned int i = 0; i < N; ++i)
	{
		x[i] = v;
		v += STEP;
	}
}

float sumVector(float x[N])
{
	float sum = 0.f;
	for (unsigned int i = 0; i < N; ++i)
		sum += x[i] * (x[i] + 1.f);

	return sum;
}

int main()
{
	//printf("Task 2!\n");

	// Define input vector
	float x[N];

	// Returned result
	float y;
	generateVector(x);

	// The following is used for timing
	clock_t exec_t1, exec_t2;
	exec_t1 = times(NULL); 	// Get system time before starting the process

	// The code that you want to time goes here
	y = sumVector(x);
	// till here

	exec_t2 = times(NULL); 	// Get system time after finishing the process
	//printf(" proc time = %lu ms\n", exec_t2 - exec_t1);

	unsigned int n = 0;
	while (y > 10e9)
	{
		y /= 2.f;
		++n;
	}
	//printf(" Result (divided by 2^%u) = %d\n", n, (int)y);
	//alt_putstr("hi");

	return 0;
}

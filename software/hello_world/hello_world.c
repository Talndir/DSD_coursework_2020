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

// NORMAL, LOOKUP or TAYLOR
#define NORMAL

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

#ifdef LOOKUP

#define TABLE_SIZE 8192
#define PI 3.14159265359f
#define HALF_PI 1.57079632679f
#define TWO_PI 6.28318530718f

float lookupTable[TABLE_SIZE];

void initLookup()
{
	for (unsigned int i = 0; i < TABLE_SIZE; ++i)
		lookupTable[i] = cos(HALF_PI * (float)i / (float)TABLE_SIZE);
}

float cosine(float x)
{
	x = fmod(fabs(x), TWO_PI);
	if (x > PI)
		x = PI - x;
	if (x < HALF_PI)
		return lookupTable[(int)(x * (float)TABLE_SIZE / HALF_PI)];
	else
		return -lookupTable[(int)((HALF_PI - x) * (float)TABLE_SIZE / HALF_PI)];
}

#endif

#ifdef TAYLOR

#define TWO_PI 6.28318530718f
#define PI_BY_FOUR 0.78539816339f
#define HALF_SQRT_TWO 0.70710678118f

float cosine(float x)
{
	x = fmod(fabs(x), TWO_PI) - PI_BY_FOUR;
	float x2 = x * x;
	float x3 = x2 * x;
	float x4 = x3 * x;
	float x5 = x4 * x;

	float sum = HALF_SQRT_TWO;
	sum -= x * HALF_SQRT_TWO;
	sum -= x2 * 0.5 * HALF_SQRT_TWO;
	sum += x3 * (1.f / 6.f) * HALF_SQRT_TWO;
	sum += x4 * (1.f / 24.f) * HALF_SQRT_TWO;
	sum -= x5 * (1.f / 120.f) * HALF_SQRT_TWO;

	return sum;
}

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
	float c;
	for (unsigned int i = 0; i < length; ++i)
	{
#ifdef NORMAL
		c = cos((x[i] / 128.f) - 1.f);
#else
		c = cosine((x[i] / 128.f) - 1.f);
#endif
		sum += x[i] * (0.5f + x[i] * c);
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
	printf("Task 5!\n");
	printf("Test %u\n", TEST);
#ifdef LOOKUP
	initLookup();
#endif
	// Run 10 times
	long unsigned sum = 0;
	for (unsigned int i = 0; i < 5; ++i)
		sum += runOnce();
	sum /= 5;
	printf("Average time: %lums\n", sum);

	return 0;
}

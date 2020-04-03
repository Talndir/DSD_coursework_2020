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

#define FP_ADD(A,B) __builtin_custom_fnff(0x0,(A),(B))
#define FP_MULT(A,B) __builtin_custom_fnff(0x1,(A),(B))
#define COS(A,B) __builtin_custom_fnfi(0x2,(A),(B))

#define TEST 2

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
	float c;
	for (unsigned int i = 0; i < length; ++i)
	{
		c = COS((x[i] / 128.f) - 1.f, 32);
		sum += FP_MULT(x[i], FP_ADD(0.5f, FP_MULT(x[i], c)));
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

void monteCarlo()
{
	printf("Monte Carlo\n");
	srand((unsigned)times(NULL));

	double errors[10000];

	for (unsigned int n = 1; n <= 32; ++n)
	{
		double sum = 0.f;
		for (unsigned int i = 0; i < 10000; ++i)
		{
			float r = (float)rand() / (float)(RAND_MAX);
			r = (r * 2.f) - 1.f;	// In [-1, 1];
			if (r == 1.f)
				continue;	// 1 is not allowed

			double c = COS(r, n);
			double e = fabs(c - cos(r));
			errors[i] = e;
			sum += e * e;
		}

		double mse = sum / 10000;
		double stdev = 0.f;
		for (unsigned int i = 0; i < 10000; ++i)
			stdev += (errors[i] - mse) * (errors[i] - mse);
		stdev = sqrt(stdev) / 100;
		stdev = 1.96f * stdev / 100;
		printf("n = %u, MSE = %.17g, CI = MSE +- %.17g\n", n, mse, stdev);
	}
}

void runTest()
{
	printf("Test %u\n", TEST);

	// Run 5 times
	long unsigned sum = 0;
	for (unsigned int i = 0; i < 5; ++i)
		sum += runOnce();
	sum /= 5;
	printf("Average time: %lums\n", sum);
}

int main()
{
	printf("Task 7!\n");
	monteCarlo();
	return 0;
}

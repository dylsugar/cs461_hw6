#include <stdio.h>
#include <stdlib.h>
typedef unsigned long u64;

extern void swtch(void **old, void *new);

void * stackptr_main;
void * stackptr_worker;

void coworker(void)
{
	printf("worker 1\n");
	swtch(&stackptr_worker, stackptr_main);
	printf("worker 2\n");
	swtch(&stackptr_worker, stackptr_main);
}

int main(void)
{
	u64 * co_stack = malloc(8192);
	u64 * ptr = co_stack + 1000;
	ptr[6] = (u64)coworker;

	printf("main 1\n");
	swtch(&stackptr_main, (void *)ptr);
	printf("main 2\n");
	swtch(&stackptr_main, stackptr_worker);
	printf("main exit\n");
	
	return 0;
}


#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define buffer_size 1024

extern void multiplication();


char* random_number(){
	static char bit_array[buffer_size];
	int number_size = rand() % buffer_size;
	int i;
	for(i = 0; i < number_size; i++){
		bit_array[i] = (rand() % 2) +  '0';
	}
	bit_array[i] = 0;

	return bit_array;
}

void generate_random_file(char* filename){
	char* generated_number = random_number();
	FILE* fd;
	fd = fopen(filename, "w");
	fprintf(fd, "%s", generated_number);
	fclose(fd);
}

int main(int argc, const char* argv[]){
	time_t tt;
	int seed = time(&tt);
	srand(seed);
char choice = 1;
	printf("1. Uruchom program\n"
//		"2. Generuj losowe dane\n"
			"0. Wyjscie\n");


	do{
	scanf("%c", &choice);
		switch(choice){
			case '1':
				multiplication();
				break;
/*				
			case '2':
				generate_random_file("in1_binary");
				generate_random_file("in2_binary");
*/
			default:
				break;
		}
	}
	while (choice != '0');

	return 0;
}


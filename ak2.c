#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern void multiplication();

int size = 0;
int reading_counter = 0;

static struct timeval tm1;

static inline void start()
{
    gettimeofday(&tm1, NULL);
}

static inline int stop()
{
    struct timeval tm2;
    gettimeofday(&tm2, NULL);

    unsigned long long t = 1000 * (tm2.tv_sec - tm1.tv_sec) + (tm2.tv_usec - tm1.tv_usec);
   	return (int) t;
}

void create_random(char* fileName,int num_of_bits) {
	int k=0;
	int rand_bit;
	char buff[num_of_bits];
	FILE* file = fopen(fileName, "w+");
	for (k=0; k<num_of_bits; ++k){
		buff[k]=(char) (rand() % 2)+48;
	}
	fprintf(file, buff);
	fclose(file);
}
int multiply(int num1[], int num2[]) {
//    for (int k = 0; k < size; ++k) {
//        printf("%d", num1[k]);
//    }

    int* bit_result = malloc(size * 2 * sizeof(int));
    for (int k = 0; k <= size * 2; ++k) {
        bit_result[k]=0;
    }

    int i = 0;
    int j = 0;
    for (i = size - 1; i >= 0; --i) {

        if (num2[i] == 1) {
			int bit = size - 1;

			for (j = i + size; j > i; --j) {
				bit_result[j] = bit_result[j] + num1[bit];

				if(bit_result[j] > 1) {
					bit_result[j] = bit_result[j] - 2;
					bit_result[j - 1] = bit_result[j - 1] + 1;
				}

				bit = bit-1;
			}
		}
    }
	//printf("wynik: ");
	//for (int k = 0 ; k < size * 2; ++k) {
		//printf("%d", bit_result[k]);
	//}
	printf("\n");
	if(bit_result = NULL)
	{
		return 0;
	} else {
		free(bit_result);
	}
    return 0;
}

int* readFile(char* fileName)
{
    FILE* file = fopen(fileName, "r");
    int* code; 
    size_t n = 0;
    int c;

    if (file == NULL)
        return NULL;

    code = malloc(10000*sizeof(int));

    while ((c = fgetc(file)) != EOF) {
        if((int) c != 10 && ((int) c == 48 || (int) c == 49)) { 
            code[n] = (int) c - 48;
            n++;
        }
    }

    size = n;
//    printf("\n znaki %li \n", n);
    fclose(file);
    return code;
}


int main(int argc, const char* argv[]) {
	char choice = '1';
	int* binary_file1;
	int* binary_file2;
	int ile_bitow=0;
	int ile_razy=0;
	srand(time(0));
	do {
	printf("\n1. Uruchom program asm\n"
			"2. Uruchom program c\n"
			"3. Wczytaj plik (dla programu c)\n"
			"4. Test - generuje losowe pliki\n"
			"0. Wyjscie\n");

	choice = getchar();
	getchar();

		switch(choice) {
			case '1': {
				multiplication();
				break;
			}

			case '2': {
//				printfdd("\nw%ld\n pierwszy: %d\n", sizeof(binary_file2), binary_file2[0]);
				int result = multiply(binary_file1, binary_file2);
				printf("\n");

				break;
			}

			case '3': {
				binary_file1 = readFile("in2_binary");
				binary_file2 = readFile("in1_binary");
				
				break;
		  		}
			case '4': {
				printf("Ile bitów: ");
				scanf("%d", &ile_bitow);
				printf("Ile powtorzen: ");
				scanf("%d", &ile_razy);
				int wyniki[ile_razy];
				for(int i=0; i<ile_razy;++i)
				{
					create_random("in1_binary",ile_bitow);
					create_random("in2_binary",ile_bitow);
					binary_file1 = readFile("in2_binary");
					binary_file2 = readFile("in1_binary");
					start();
					int result = multiply(binary_file1, binary_file2);
					wyniki[i]=stop();
					printf("%d\n", wyniki[i]);
				}
				break;
				}
			default:
				break;
		}
	}
	while (choice != '0');

	return 0;
}

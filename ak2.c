#include <stdio.h>
#include <stdlib.h>

extern void multiplication();

int size = 0;

int* multiply(int num1[], int num2[]) {
//    for (int k = 0; k < size; ++k) {
//        printf("%d", num1[k]);
//    }

    int* bit_result = malloc(size * 2);
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

    return bit_result;
}

int* readFile(char* fileName)
{
    FILE* file = fopen(fileName, "r");
    int* code; 
    size_t n = 0;
    int c;

    if (file == NULL)
        return NULL;

    code = malloc(1000);

    while ((c = fgetc(file)) != EOF) {
        if((int) c != 10) { 
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
	char choice = 1;
	do {
	printf("\n1. Uruchom program asm\n"
			"2. Uruchom program c\n"
			"0. Wyjscie\n");

	scanf("%c", &choice);

		switch(choice) {
			case '1': {
				multiplication();
				break;
			}

			case '2': {
				int* binary_file1 = readFile("in2_binary");
				int* binary_file2 = readFile("in1_binary");
//				printfdd("\nw%ld\n pierwszy: %d\n", sizeof(binary_file2), binary_file2[0]);
				int* result = multiply(binary_file1,binary_file2);

				printf("wynik: ");
				for (int k = 0 ; k < size * 2; ++k) {
					printf("%d", result[k]);
				}
				printf("\n");

				break;
			}

			default:
				break;
		}
	}
	while (choice != '0');

	return 0;
}

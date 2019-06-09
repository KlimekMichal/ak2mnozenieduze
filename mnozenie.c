#include <stdio.h>
#include <stdlib.h>

#define buffer_size 10
extern int size = 0;

int * random_number(){
	static int bit_array[buffer_size];
	int number_size = buffer_size;
	int i;
	for(i = 0; i < buffer_size; i++){
		bit_array[i] = rand() % 2;
	}
	//bit_array[i] = 0;

	return bit_array;
}

int *readFile(char *fileName)
{
    FILE *file = fopen(fileName, "r");
    int *code;
    size_t n = 0;
    int c;

    if (file == NULL)
        return NULL; //could not open file

    code = malloc(1000);

    while ((c = fgetc(file)) != EOF)
    {
	if((int) c != 10)
		{
        	code[n] = (int) c -48;
			n=n+1;
		}
    }

    // don't forget to terminate with the null character
    //code[n] = '\0';        
	size = n;
	printf("\n znaki %d \n", n);
	fclose(file);
    return code;
}


int * random_number1(){
	static int bit_array1[buffer_size];
	int number_size1 = buffer_size;
	int i;
	for(i = 0; i < buffer_size; i++){
		bit_array1[i] = rand() % 2;
	}
	//bit_array[i] = 0;

	return bit_array1;
}

int * multiply(int rand1[], int rand2[]){
	int k;
	for (k=0;k<size;++k)
	{
		printf("%d",rand1[k]);
	}
	

	 int* bit_result = malloc(size*2);
	
	for (k=0;k<=size*2;++k)
	{
		bit_result[k]=0;
	}
	int i=0;
	int j=0;
	for (i = size-1; i>=0; --i)
		{
			if(rand2[i]==1)
				{
					int bit = size-1;
					for (j = i+size; j>i;--j)
						{
							bit_result[j] = bit_result[j]+rand1[bit];
							if(bit_result[j]>1)
								{
									bit_result[j]=bit_result[j]-2;
									bit_result[j-1]=bit_result[j-1]+1;
								}
							bit = bit-1;
							//printf("\n iteracja: %d, bit: %d, wartosc: %d", i,j,bit_result[j-1]);
						}
				}
			
		}
	//printf("\n kurwa: %d \n", bit_result[44]);
	//printf("kurwa2");
	return bit_result;
}


int main(int argc, const char* argv[]){
int k = 0;
int *bit_keeper1;
bit_keeper1 = random_number();
int *bit_keeper2;
bit_keeper2 = random_number1();

int *bit_file1 = readFile("in2_binary");
int *bit_file2 = readFile("in1_binary");
printf("\nw%ld\n pierwszy: %d\n", sizeof(bit_file2), bit_file2[0]);
int* bit_resulting = multiply(bit_file1,bit_file2);

printf("wynik: ");
for (k=0;k<size*2;++k)
	{
		printf("%d",bit_resulting[k]);
	}
}

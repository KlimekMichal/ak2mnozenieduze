#include <stdio.h>

extern void multiplication();

int main(int argc, const char* argv[]){
char choice;
	printf("1. Uruchom program\n"
			"0. Wyjscie\n");

	scanf("%c", &choice);

	switch(choice){
		case '1':
			multiplication();
			break;
		default:
			break;
	}
	return 0;
}

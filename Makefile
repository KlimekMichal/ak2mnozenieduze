all: otwieranie ak2

otwieranie: otwieranie.o
	ld -o otwieranie otwieranie.o

otwieranie.o: otwieranie.s
	as -gstabs -o otwieranie.o otwieranie.s

ak2: ak2.c otwieranie_decymalne.s
	gcc otwieranie_decymalne.s ak2.c -o ak2 -g -no-pie

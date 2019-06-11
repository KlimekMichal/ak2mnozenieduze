all: ak2

ak2: ak2.c otwieranie_decymalne.s
	gcc otwieranie_decymalne.s ak2.c -o ak2 -g -no-pie

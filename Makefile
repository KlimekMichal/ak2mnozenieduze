all: ak2

ak2: ak2.c otwieranie_decymalne.s timer.s
	gcc otwieranie_decymalne.s timer.s ak2.c -o ak2 -g -no-pie

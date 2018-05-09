function mafonction(int valeur) {
	int mo = valeur;
	print(mo + 2);
}

function main() {
	int i, j, k, r;
	i = 3;
	j = 4;
	k = 8;
	print(i);							// Doit afficher 3
	r = (i+j)*(i+k/j);
	print(r);							// Doit afficher 35
	mafonction(i); 						// Doit afficher 5
	if(2 < 3) {
		i = 2;
	} else {
		i = 72;
	}
	while(i > 0) {						// Doit afficher 2, puis 1
		print(i);
		i = i - 1;
	}
	print(40 * 13 / 30); 				// Doit afficher 17

	// Ce bloc ne doit rien n'afficher
	int a = 0;
	int b = 5;
	while(a) {
		a = a + 1;
		print(a);
		if (2) {
			while (b) {
				print(b);
			}
		} else {
			print(b+1);
		}
	}
}

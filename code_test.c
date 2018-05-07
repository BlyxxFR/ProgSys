function mafonction(int valeur) {
	int mo = valeur;
	print(mo + 2);
}

function main() {
	int i, j, k, r;
	i = 3;
	j = 4;
	k = 8;
	print(i);	// Affiche 3
	r = (i+j)*(i+k/j);
	print(r);	// Affiche 35
	mafonction(i); // Affiche 5
	if(2 < 3) {
		i = 2;
	} else {
		i = 72;
	}
	while(i > 0) {
		print(i);
		i = i - 1;
	}
	print(40 * 13 / 30); // Affiche 17
}

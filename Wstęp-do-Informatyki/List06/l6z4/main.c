#include <stdio.h>
#include <stdlib.h>

// Nie do ko�ca pot�gowanie bo dla 0 zwracamy 0
int pow(int a, int b) {
    if(a==0) {
        return 0;
    }
    int output=1;
    for(int i=0; i<b; i++) {
        output*=a;
    }
    return output;
}

// k - ilo�� cyfr znacz�cych
int wartosc(int a[], int k) {
    int w = 0;
    for(int i=0; i<=k; i++) {
        w = w + pow(2*a[i], k-i);
    }
    return w;
}

int main() {
    int a[4] = {1,0,1,0};
    int x = wartosc(a, 3);
    printf("%d", x);
}

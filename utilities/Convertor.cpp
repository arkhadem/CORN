#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vector>
#include <cmath>
using namespace std;

void print_binary(float num, int M, int I){
    int IntegerPart, MantissaPart;
    int One;
    IntegerPart = (int)(num);
    One = 1 << M;
    MantissaPart = (int)((num - (float)IntegerPart) * (float)One);
    One = (1 << (I - 1));
    for (int j = 0; j < I; j++) {
        printf("%d", ((IntegerPart & One) == 0) ? 0 : 1);
        One = One >> 1;
    }
    One = (1 << (M - 1));
    for (int j = 0; j < M; j++) {
        printf("%d", ((MantissaPart & One) == 0) ? 0 : 1);
        One = One >> 1;
    }
}

int main(){
    vector<float> nums;
    float num;
    int M, I;
    scanf("%d %d\n", &I, &M);
    while(scanf("%f\n", &num) == 1){
        printf("%f: ", num);
        print_binary(num, M, I);
        printf("\n");
        nums.push_back(num);
    }
    printf("1d:\n");
    for (int i = 0; i < nums.size(); i++) {
        print_binary(nums[i], M, I);
    }
}

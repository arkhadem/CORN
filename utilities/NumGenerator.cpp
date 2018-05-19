#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vector>
#include <time.h>
#include <cmath>
#include <iostream>
using namespace std;

int main(){
    int N, K, I, M, A;
    vector< vector<float> > Weights;
    vector<float> Inputs;
    printf("N(number of Nuerons): ");
    scanf("%d", &N);
    printf("K(number of Inputs): ");
    scanf("%d", &K);
    printf("I(number of Integer digits in NN): ");
    scanf("%d", &I);
    printf("M(number of Mantissa digits in NN): ");
    scanf("%d", &M);
    printf("A(number of Approximation digits in NN): ");
    scanf("%d", &A);
    FILE* fp_out;
    fp_out = fopen ("in.txt", "w+");
    srand((unsigned int)time(NULL));
    Weights.resize(N);
    Inputs.resize(K);
    for (int i = 0; i < K; i++){
        Inputs[i] = (float)rand()/(float)(RAND_MAX * 4.0);
    }
    for (int i = 0; i < N; i++){
        Weights[i].resize(K);
        for (int j = 0; j < K; j++){
            Weights[i][j] = (float)rand()/(float)(RAND_MAX * 4.0);
        }
    }
    fprintf(fp_out, "info:\n");
    fprintf(fp_out, "%d %d %d %d %d\n", N, K, I, M, A);
    fprintf(fp_out, "input:\n");
    for (int i = 0; i < K; i++){
        fprintf(fp_out, "%f ", Inputs[i]);
    }
    fprintf(fp_out, "\n");
    fprintf(fp_out, "weight:\n");
    for (int i = 0; i < N; i++){
        for (int j = 0; j < K; j++){
            fprintf(fp_out, "%f ", Weights[i][j]);
        }
        fprintf(fp_out, "\n");
    }
    return 0;
}

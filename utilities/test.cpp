#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <vector>
#include <cmath>
using namespace std;

void print_binary(FILE* fp_out, float num, int M, int I, bool toWrite){
    int IntegerPart, MantissaPart;
    int One;
    IntegerPart = (int)(num);
    One = 1 << M;
    MantissaPart = (int)((num - (float)IntegerPart) * (float)One);
    One = (1 << (I - 1));
    if(toWrite == true)
        fprintf(fp_out, "\"");
    for (int j = 0; j < I; j++) {
        fprintf(fp_out, "%d", ((IntegerPart & One) == 0) ? 0 : 1);
        One = One >> 1;
    }
    One = (1 << (M - 1));
    for (int j = 0; j < M; j++) {
        fprintf(fp_out, "%d", ((MantissaPart & One) == 0) ? 0 : 1);
        One = One >> 1;
    }
    if(toWrite == true)
        fprintf(fp_out, "\"");
}

int main(){
    int N, K, I, M, A, numOfReadObj;
    float num;
    char firstStr[20];
    vector< vector<float> > Weights;
    vector< vector<float> > WRT;
    vector<float> Inputs;
    FILE* fp_in;
    FILE* fp_out;
    fp_out = fopen ("out.txt", "w+");
    fp_in = fopen ("in.txt", "r");
    numOfReadObj = fscanf(fp_in, "%s\n%d %d %d %d %d\n", firstStr, &N, &K, &I, &M, &A);
    if(strcmp(firstStr, "info:") != 0 | numOfReadObj != 6){
        printf("Illegal format. Please Enter Information First:\ninfo: N K I M A\n");
    }else{
        printf("Information Inserted!\n");
    }
    numOfReadObj = fscanf(fp_in, "%s\n", firstStr);
    if(strcmp(firstStr, "input:") == 0 && numOfReadObj == 1){
        fprintf(fp_out, "input:\n");
        for (int i = 0; i < K; i++) {
            numOfReadObj = fscanf(fp_in, "%f ", &num);
            Inputs.push_back(num);
            print_binary(fp_out, num, M, I, true);
            fprintf(fp_out, " ");
        }
        fprintf(fp_out, "\n");
        printf("Inputs are Read\n");
    }else{
        printf("Error! Illegal flag\n");
        return -1;
    }
    numOfReadObj = fscanf(fp_in, "%s\n", firstStr);
    if(strcmp(firstStr, "weight:") == 0 && numOfReadObj == 1){
        fprintf(fp_out, "weight:\nSIGNAL ROM : array_rom_type:= (\n");
        for (int i = 0; i < N; i++) {
            fprintf(fp_out, "\t(");
            vector<float> tmp;
            for (int j = 0; j < K; j++) {
                numOfReadObj = fscanf(fp_in, "%f ", &num);
                tmp.push_back(num);
                print_binary(fp_out, num, M, I, true);
                if(j != K - 1)
                    fprintf(fp_out, ", ");
            }
            fprintf(fp_out, ")");
            if(i != N - 1)
                fprintf(fp_out, ",");
            fprintf(fp_out, "\n");
            Weights.push_back(tmp);
            fscanf(fp_in, "\n");
        }
        fprintf(fp_out, ");\n");

        fprintf(fp_out, "weights 1d:\n");
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < K; j++) {
                print_binary(fp_out, Weights[i][j], M, I, false);
            }
            fscanf(fp_in, "\n");
        }
        fprintf(fp_out, "\n");
    }else{
        printf("Error! Illegal flag\n");
        return -1;
    }

    printf("Outputs Without Approximation:\n");
    for (int i = 0; i < N; i++) {
        float sum = 0;
        for (int j = 0; j < K; j++) {
            sum += Inputs[j] * Weights[i][j];
        }
        printf("Net: %f, ", sum);
        fprintf(fp_out, "Net = %f : ", sum);
        print_binary(fp_out, sum, M, I, true);
        sum = tanh(sum);
        printf("Output: %f\n", sum);
        fprintf(fp_out, ", Out = %f: ", sum);
        print_binary(fp_out, sum, M, I, true);
        fprintf(fp_out, "\n");
    }
    fprintf(fp_out, "\n");
    printf("\n");
    WRT.resize(N);
    for (int i = 0; i < N; i++) {
        WRT[i].resize(K, 0);
    }
    for (int i = 0; i < K; i++) {
        for (int j = 0; j < N; j++) {
            if(WRT[j][i] == 0){
                WRT[j][i] = 1 << j;
                for (int X = j + 1; X < N; X++) {
                    if(WRT[X][i] == 0){
                        if((((int)((Weights[j][i] - (int)Weights[j][i]) * pow(2, A))) ^ ((int)((Weights[X][i] - (int)Weights[X][i]) * pow(2, A)))) <= ((int)pow(2, (-1 * A)) << A)){
                            WRT[X][i] = 1 << j;
                            Weights[X][i] = Weights[j][i];
                        }
                    }
                }
            }
        }
    }
    fprintf(fp_out, "WRT:\nSIGNAL ROM : array_rom_type:= (\n");
    for (int i = 0; i < N; i++) {
        fprintf(fp_out, "\t(");
        for (int j = 0; j < K; j++) {
            print_binary(fp_out, WRT[i][j], 0, N, true);
            if(j != K - 1)
                fprintf(fp_out, ", ");
        }
        fprintf(fp_out, ")");
        if(i != N - 1)
            fprintf(fp_out, ",");
        fprintf(fp_out, "\n");
    }
    fprintf(fp_out, ");\n");
    fprintf(fp_out, "WRT_1D:\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < K; j++) {
            print_binary(fp_out, WRT[i][j], 0, N, false);
        }
    }
    fprintf(fp_out, "\n");
    printf("Outputs with Approximation:\n");
    for (int i = 0; i < N; i++) {
        float sum = 0;
        for (int j = 0; j < K; j++) {
            sum += Inputs[j] * Weights[i][j];
        }
        printf("Net: %f, ", sum);
        fprintf(fp_out, "Net = %f : ", sum);
        print_binary(fp_out, sum, M, I, true);
        sum = tanh(sum);
        printf("Output: %f\n", sum);
        fprintf(fp_out, ", Out = %f: ", sum);
        print_binary(fp_out, sum, M, I, true);
        fprintf(fp_out, "\n");
    }
    fprintf(fp_out, "\n");
    printf("\n");
    fclose(fp_out);
    fclose(fp_in);
    printf("Done\n");
}

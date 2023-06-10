/*
     How to run code
        1. Make sure you are inside the directory of the file
        2. run command "make"
        3. run command "./imageprocessing"
*/
#include <stdio.h>
#include <stdint.h>

#include "kernel.cu"

int main() {
    
    cudaError_t cuda_ret;

    // Initialize host variables ----------------------------------------------

    printf("\nSetting up the problem...\n"); fflush(stdout);
    

    // Allocate device variables ----------------------------------------------

    printf("Allocating device variables...\n"); fflush(stdout);



    cudaDeviceSynchronize();

    // Copy host variables to device ------------------------------------------

    printf("Copying data from host to device...\n"); fflush(stdout);



    cudaDeviceSynchronize();

    // Launch kernel ----------------------------------------------------------

    printf("Launching kernel...\n"); fflush(stdout);
    
    

    // Copy device variables from host ----------------------------------------

    printf("Copying data from device to host...\n"); fflush(stdout);
    


    cudaDeviceSynchronize();
    
    // Free memory ------------------------------------------------------------



    return 0;
}

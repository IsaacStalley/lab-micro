#include <pic14/pic12f683.h>

#define TIME 100 // Delay time
#define LFSR_SEED 0b01010101  // Initial seed for the LFSR algo

unsigned char lfsr = LFSR_SEED;  // Global variable to store LFSR state

void delay (unsigned int time){
    for(unsigned int i= 0; i < time; i++)
        for(unsigned int j= 0; j < 1000; j++);
}

unsigned char lfsrGenerate() {
    if (lfsr & 0x01) {
        lfsr = (lfsr >> 1) ^ 0x91;  // XOR feedback polynomial
    } else {
        lfsr >>= 1;
    }
    return lfsr;
}

void main() {
    // Initialize the microcontroller
    TRISIO = 0b00100000;  // Set GP5 as input
    
    while (1) {

        // Check if the button is pressed
        if (GP5) {
            // Generate a random number between 1 and 6 using LFSR
            unsigned char numLeds = (lfsrGenerate() % 6) + 1;

            if (numLeds % 2 != 0){
                if (numLeds == 6){
                    GP2 = 0x01;
                }
                GP0 = 0x01;
            }
            if (numLeds > 1){
                GP1 = 0x01;
            }
            if (numLeds > 3){
                GP4 = 0x01;
            }

            delay(TIME);
            // Wait for the button to be released
            while (GP5);

            // Turn off the LED
            GP0 = 0x00;
            GP1 = 0x00;
            GP2 = 0x00;
            GP3 = 0x00;
        }
    }
}
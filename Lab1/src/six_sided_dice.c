#include <pic14 /pic12f683 . h>

#define TIME 100 // Delay time
#define LFSR_SEED 0b01010101  // Initial seed for the LFSR algo

unsigned char lfsr = LFSR_SEED;  // Global variable to store LFSR state
typedef unsigned int word;
word __at 0x2007 __CONFIG = (_BODEN_OFF );

void delay (unsigned int time){

    for(unsigned int i= 0; i < time; i++)
        for(unsigned int j= 0; j < 2000; j++);
}

unsigned char lfsrGenerate() {
    if (lfsr & 0x01) {
        lfsr = (lfsr >> 1) ^ 0xB8;  // XOR feedback polynomial
    } else {
        lfsr >>= 1;
    }
    return lfsr;
}

void main() {
    
    // Initialize the microcontroller
    TRISIO5 = 1;  // Set GP5 as input
    TRISIO0 = 0;  // Set GP0 as output
    TRISIO1 = 0;  // Set GP1 as output
    TRISIO2 = 0;  // Set GP1 as output
    TRISIO3 = 0;  // Set GP1 as output
    
    while (1) {
        // Check if the button is pressed
        if (GP5 == 0) {
            // Generate a random number between 1 and 6 using LFSR
            unsigned char numLeds = (lfsrGenerate() % 6) + 1;

            if (numLeds % 2 != 0){
                if (numLeds > 1){
                    GP2 = 1;
                }
                GP0 = 1;
            }
            if (numLeds > 1){
                GP1 = 1;
            }
            if (numLeds > 3){
                GP3 = 1;
            }

            delay(TIME);
            // Wait for the button to be released
            while (GP5 == 0);

            // Turn off the LED
            GP0 = 0;
            GP1 = 0;
            GP2 = 0;
            GP3 = 0;
        }
    }
}
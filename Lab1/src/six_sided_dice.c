#include <pic14/pic12f683.h>

#define TIME 100 // Delay time
#define LFSR_SEED 0x55  // Initial seed for the LFSR algo
#define LFSR_XOR 0xB8

unsigned char lfsr = LFSR_SEED;  // Global variable to store LFSR state
typedef unsigned int word;
word __at(0x2007) __CONFIG = (_WDT_OFF, _WDTE_OFF, _PWRTE_OFF, _MCLRE_OFF);

void delay (unsigned int time){
    for(unsigned int i= 0; i < time; i++)
        for(unsigned int j= 0; j < 1000; j++);
}

unsigned char lfsrGenerate() {
    if (lfsr & 0x01) {
        lfsr = (lfsr >> 1) ^ LFSR_XOR;  // XOR feedback polynomial
    } else {
        lfsr >>= 1;
    }
    return lfsr;
}

void main() {
    // Initialize the microcontroller
    TRISIO = 0b00100000;  // Set GP5 as input
    GPIO = 0x00;
    
    while (1) {

        // Check if the button is pressed
        if (GP5) {
            // Generate a random number between 1 and 6 using LFSR
            unsigned char numLeds = (lfsrGenerate() % 6) + 1;

            //unsigned int numLeds = lfsr;
            unsigned char temp = 0;

            if (numLeds % 2){
                temp |= (0b00001);
            }
            if (numLeds > 1){
                temp |= (0b00010);
            }
            if (numLeds > 3){
                temp |= (0b10000);
            }
            if (numLeds == 6){
                temp |= (0b00101);
            }

            GPIO = temp;

            delay(TIME);
            // Wait for the button to be released
            while (GP5);

            // Turn off the LED
            GPIO = 0x00;
        }
    }
}
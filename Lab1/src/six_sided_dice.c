#include <pic14/pic12f683.h>

#define TIME 200 // Delay time
#define LFSR_MASK 0xACEE // Mask used in lfsr algo

typedef unsigned int uint;
typedef unsigned char uchar;
uint __at(0x2007) __CONFIG = (_WDT_OFF, _WDTE_OFF, _PWRTE_OFF, _MCLRE_OFF);

uint lfsr = 0x6789;  // Global variable to store LFSR state

// Time delay function, real time based on cpu clock
void delay (uint time){
    for(uint i= 0; i < time; i++)
        for(uint j= 0; j < 1000; j++);
}

// Lfsr shift function for lfsr algo, returns lsb of lfsr and shifts
uint lfsrShift(){
    uint lsb = lfsr & 1; // Get the least significant bit
    // Apply XOR feedback
    lfsr >>= 1;
    if (lsb){
        lfsr ^= LFSR_MASK;
    }
    return lsb;
}

// Random number function, returns a 32bit random number using lfsr
uchar rand(){
    uint random_number = 0;
    // Get 32 random bit from lfsrShift and OR them together
    for (uint i = 0; i < 32; i++) {
        uchar random_bit = lfsrShift();
        random_number |= (random_bit << i);
    }
    return random_number;
}

void main() {
    // Initialize the microcontroller
    TRISIO = 0b00100000;  // Set GP5 as input
    GPIO = 0x00; // Set all IO pins to 0
    
    while (1) {
        // Check if the button is pressed
        if (GP5) {
            // Generate a random number between 1 and 6 using LFSR
            uint numLeds = (rand() % 6) + 1;
            uchar pinMask = 0x00; // Mask for turning on IO pins

            if (numLeds % 2){  // If random number is 1,3,5
                pinMask |= (0b00001); 
            }
            if (numLeds > 1){ // If random number is 2,3,4,5,6
                pinMask |= (0b00010);
            }
            if (numLeds > 3){ // If random number is 4,5,6
                pinMask |= (0b10000);
            }
            if (numLeds == 6){ // If random number is 6
                pinMask |= (0b00101);
            }

            GPIO = pinMask; // Turn on IO pins powering leds 

            delay(TIME); // Minimum time the leds will stay on
            // Wait for the button to be released
            while (GP5);

            GPIO = 0x00; // Turn off the LED
        }
    }
}
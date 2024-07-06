#include <msp430.h> 


/*v1*
 * main.c
 */
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    int R5_SW=0, R6_LED=0;
//  ^read input, ^ read output
        P1OUT = 0b00000000;     //mov.b    #00000000b,&P1OUT        turn off all leds
        P1DIR = 0b11111111;     //mov.b    #11111111b,&P1DIR        set all port 1.0-1.9 to outputs (LEDs)
        P2DIR = 0b00000000;     //mov.b    #00000000b,&P2DIR        set all port 2.0-2.9 to inputs  (Switches)
        P2REN = 0xFF;           //enable all resistors on port 2    P2OUT now uses it's secondary function (so P2OUT does NOT affect outputs)
        P2OUT = 0xFF;           //make them all of them pull ups

        while (1)
        {
            //read the states of the switches
            R5_SW = P2IN;       //mov.b    &P2IN, R5            Store input pattern in R5_SW

            //checking P2.0 for read mode
            if (!(R5_SW & BIT0))   //Check if P2.0 is 1 (which means switch 2.0 is on)
              {
                R6_LED = R5_SW & (BIT3 | BIT4 | BIT5);  // mask the pattern bits    Read display pattern
                P1OUT = R6_LED;                         // display the pattern
              }

            //else, it is the rotate and display mode
            else    //It is in rotate mode
              {
                //The following code (3 lines) only toggles the pattern of the 8 LEDs
                //This is to show you got all your switches and LEDs working properly
                //Modify the code so that the last pattern (3 bits) read during the
                //reading mode is now rotating on the 8 LEDs left to right base on P2.1

                if (!(R5_SW & BIT1))   //if 2.1 is HIGHlow
                    R6_LED = (R6_LED >> 1) | (R6_LED << 7); //Rotate RIGHT, in C
                }
                else
                {
                   R6_LED = (R6_LED << 1)  | (R6_LED) >> 7; //Rotate LEFT, in C
                }
                    R6_LED &= 0xFF;     //mask any excessive bits   Make sure to keep the value 8-bit
                    P1OUT = R6_LED;     //pattern out - display it

              }

                if (!(R5_SW & BIT2))  //If 2.2 is HIGH (down), pattern is slow
                {
                    __delay_cycles(80000);    //slow
                }
                else  //Else it is fast
                {
                    __delay_cycles(400000); //fast
                }


         } //end while








    return 0;
}

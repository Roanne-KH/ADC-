/*
 * File:   main.c
 * Author: Roanne
 *
 * Created on May 11, 2020, 4:50 AM
 */

#define F_CPU 16000000UL

// Built-in headers
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// User-defined Headers
#include "Config.h"
#include "DIO.h"
#include "lcd.h"


#define BUTTON2        2
#define LED            3
#define Buzzer         3

#define portA           1
#define portB           2
#define portC           3
#define portD           4

//#define stepValue      48828125?

char message[] = "Welcome";
char str1[] = "Volt = ";
char str2[] = " mV";
char cl[] = "    ";// 4 Spaces equal to numbers of  numbers of mV ,It is used when we want to hide the  unwanted zeros on the left.


void LM35Kit_ADC_init() {
    ADMUX = 0x01 ;   //Channel 0(5 bits)&,VREF (2BIT) ,ADLDRA IS RIGHT (1BIT)
    ADCSRA |= (1 << ADEN) | (1 << ADIE) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);
    // Enable ADC  , TRIGGER ENABLE  ,ENABLE interrupt  ,choose freq Divider
}



void startConv() {
    ADCSRA |= (1 << ADSC);
}
//Read Data right adjusted:
int getADCdata() {
    int data = 0;
    data = ADCL;// ADHL IS 1-byte register stored in 4 byte variable
    data |= (ADCH << 8); //ADCH is stored in the 2nd byte of data 

    return data;
}
// Read Data left adjusted:
int getADCdataL() {
    int data = 0; 
    data = (ADCH << 2);// SHIFT TO LEFT BY 2 , so that there are 2 zeros in the first 2 positions negelected in ADCL , SO THAT THE REST OF NUMBER HAS it's own weight.
    return data;
}


ISR(ADC_vect) {
   
     // ADC LCD_String_xy FUNCTION TRIAL_3
      // -----------------------------------------
      
     char buffer[20];
    int noOfSteps = getADCdata();


    // convert steps to mV
    int data = (5 * noOfSteps) / 1.024;

    // Display on LCD  
     itoa(data, buffer, 10);
       
     LCD_String_xy(0,7,cl);
     _delay_ms(20);
     LCD_String_xy(0, 7, buffer);
       _delay_ms(500);
     startConv();

  }


void INT0_init() {
    MCUCR |= (1 << ISC01) | (1 << ISC00); // Rising Edge
    GICR |= (1 << INT0);
}


int main(void) {

    
   // ADC_KIT_LM35_Task:
    LCD_Init();
    LM35Kit_ADC_init();
    sei();
    LCD_String_xy(0, 0, str1);
    LCD_String_xy(0, 11, str2);
    startConv();
    while (1) {



    }
}


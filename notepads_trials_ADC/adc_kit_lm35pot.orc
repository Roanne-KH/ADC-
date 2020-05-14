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

//TRIAL_5 FINAL :Autotriggering Mode
/*void Auto_ADC_init() {
    ADMUX = 0x00 ; //Channel 0(5 bits)&,VREF (2BIT) ,ADLDRA IS RIGHT (1BIT)
   // SFIOR |= (1<<ADTS1);// SELECTING INT0 Flag to auto_startconversion
    //ADCSRA |= (1 << ADEN) | (1<<ADATE)|(1 << ADIE) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);
    // Enable ADC  , TRIGGER ENABLE  ,ENABLE interrupt  ,choose freq Divider
}*/
/*//THIS IS FOR ALL TRIALS TO TRIAL_4:
void ADC_init() {
    ADMUX = 0x00 ;   //Channel 0(5 bits)&,VREF (2BIT) ,ADLDRA IS RIGHT (1BIT)
    ADCSRA |= (1 << ADEN) | (1 << ADIE) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);
    // Enable ADC  , TRIGGER ENABLE  ,ENABLE interrupt  ,choose freq Divider
}*/
void LM35Kit_ADC_init() {
    ADMUX = 0x01 ;   //Channel 0(5 bits)&,VREF (2BIT) ,ADLDRA IS RIGHT (1BIT)
    ADCSRA |= (1 << ADEN) | (1 << ADIE) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);
    // Enable ADC  , TRIGGER ENABLE  ,ENABLE interrupt  ,choose freq Divider
}

void selectChannel(unsigned int channelNo) { // 0~7
    if (channelNo < 8) { // 00000001| 00000000
        ADMUX &= ~(7 << 0); // 00000111  11111000
        ADMUX |= channelNo;
    } else {
        //# warning ""
    }
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
// this will be executed by triggering the INT0 , the flag will be set
ISR(INT0_vect){ //It must be one start Conversion for channel 1
    static int i = 1 ;
 
    if(i){
        startConv();
         i = 0;
    }
}// the INT0 flag will be CLEARED
// THIS WILL BE EXECUTED ONLY ONCE , BUT the flag will be set every time the  INT0 IS TRIGGERED , AND THIS WILL TRIGGER START_CONVERSION

ISR(ADC_vect) {
    /*FINAL AUTOTRIGGER:
     //------------------
   static int switcher = 0;
    char buffer[20];
    int noOfSteps = getADCdata();


    // convert steps to mV
    int data = (5 * noOfSteps) / 1.024;

    // Display on LCD  
     itoa(data, buffer, 10);
    
     
     
    if (switcher) {
        LCD_String_xy(1, 7, cl);
        LCD_String_xy(1, 7, buffer);
        selectChannel(0);
        switcher = 0;
    } else {
        LCD_String_xy(0, 7, cl);
        LCD_String_xy(0, 7, buffer);
        selectChannel(1);
        switcher = 1;
    }
    //    Restart Conversion every ISR
   //    startConv();
  */   
  /* // ADC start_conversion AUTOMATICALLY TRIAL_4
     // -------------------------------------------  
  static int switcher = 0;
    char buffer[20];
    int noOfSteps = getADCdata();


    // convert steps to mV
    int data = (5 * noOfSteps) / 1.024;

    // Display on LCD  
     itoa(data, buffer, 10);
    
     
     
    if (switcher) {
        LCD_String_xy(1, 7, cl);
        LCD_String_xy(1, 7, buffer);
        selectChannel(0);
        switcher = 0;
    } else {
        LCD_String_xy(0, 7, cl);
        LCD_String_xy(0, 7, buffer);
        selectChannel(1);
        switcher = 1;
    }

    _delay_ms(1000);
     startConv();
     
    */
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

  
     /*
    //ADC CHANNEL0  TRIAL_2 : Display different
    //------------------------------------------
 *   char buffer[20];
    int noOfSteps = getADCdata();
    // convert steps to mV
    int data = (5 * noOfSteps) / 1.024;
    // Display on LCD : Volt = 4955 mV
    itoa(data, buffer,10);
    LCD_String(str1);
    LCD_String(buffer);
    LCD_String(str2);
*/    
    /*
    // ADC CHANNEL0  1st trial 
    //--------------------------
    char buffer[20];
    int data = getADCdata()*4.8; // convert number of steps to volt , 4.8 mV ---> number of steps* (5/1024)  
    //DISPLAY 2 REGISTERS ADCL & ADCH ON port C & D
    setPORTC((char) data);
    setPORTD( data>>8);
    _delay_ms(500);
    // Converting integer to string to display result on LCD.
    itoa(data,buffer,10);
    LCD_Clear();
    LCD_String(buffer);     
    startConv();
      */ 
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
    //PORTCas(OUT);
   // PORTDas(OUT);
   /*When an edge or logic change on the INT0 pin triggers an interrupt request, INTF1 becomes set (one). If the I-bit in
SREG and the INT1 bit in GICR are set (one), the MCU will jump to the corresponding Interrupt Vector. The flag is
cleared when the interrupt routine is executed.When the flag is set , it triggers a <<start Conversion>> automatically,However, 
    * the InterruptFlag must be cleared in order to trigger a new conversion at the next interrupt event.
    */
/*    INT0_init();
    LCD_Init();
    Auto_ADC_init(); // Sensor on ADC0
    


    sei();
    LCD_String_xy(0, 0, str1);
    LCD_String_xy(0, 13, str2);
    LCD_String_xy(1, 0, str1);
    LCD_String_xy(1, 13, str2);
  
    startConv();//It must be one start Conversion for channel 0
  */  
  /*//TRial_4
   //------------------ 
    LCD_Init();
    ADC_init(); // Sensor on ADC0
    sei();
    LCD_String_xy(0, 0, str1);
    LCD_String_xy(0, 13, str2);
    LCD_String_xy(1, 0, str1);
    LCD_String_xy(1, 13, str2);
  
    startConv();*/
   
    // TRIAL_3
    /*
    LCD_Init();
    ADC_init();
    sei();
    LCD_String_xy(0, 0, str1);
    LCD_String_xy(0, 11, str2);
    startConv();
    */
    while (1) {



    }
}


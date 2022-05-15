/*
 * i2c_lcd.c
 *
 * 
 * Author : vigne
 */ 

//#include <avr/io.h>
//#include <util/twi.h>			//--- Give Status of I2C Bus will operation
//#define F_CPU	100000UL
#include <delay.h>
#include <mega8.h>
#include "twi_i2c.h"
#include "twi_lcd.h"
// 1 Wire Bus interface functions
#include <1wire.h>

// DS1820 Temperature Sensor functions
#include <ds18b20.h>
#include <stdio.h>

float temp =0;

void main(void)
{
    // Port C initialization
//// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
//DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
//// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
//PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

    twi_init();                                    //--- TWI Initialize
//    twi_lcd_init();                                //--- TWI LCD Initialize
//    twi_lcd_msg("RF433");                        //--- Send a String to LCD
    /* Replace with your application code */                               

    w1_init();     
    ds18b20_init(NULL, 0 , 0 ,DS18B20_10BIT_RES )  ;
    while (1) 
    {   
      temp = ds18b20_temperature(NULL)  ;   
      
        
 //       printf("Nhiet do: %f\r\n", temp);
  //     twi_lcd_cmd(0xC0);                        //--- Select 2nd Row    
   //   twi_lcd_msg("nhiet do: 7 *C \r\n");            //--- Send a String to LCD 
//        twi_lcd_num(temp)  ;
 //        usart_msg("uart:");  
        
        if(PINB.0 == 0)    
        {   
//        twi_lcd_num(temp)
//         temp = ds18b20_temperature(NULL)  ; 
         usart_msg("uart:"); 
//            usart_tx('a');  
//            usart_tx('1'); 
//            usart_tx('4');
            printf("%f\r\n", temp); 
        }
    }
}

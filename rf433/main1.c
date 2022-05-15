/*
 * i2c_lcd.c
 *
 * 
 * Author : vigne
 */ 

//#include <avr/io.h>
//#include <util/twi.h>			//--- Give Status of I2C Bus will operation
#define F_CPU	8000000UL
#include <delay.h>
#include "src/i2c_lcd/twi_lcd.h"
#include <mega8.h>


void main(void)
{
	twi_init();									//--- TWI Initialize
	twi_lcd_init();								//--- TWI LCD Initialize
	twi_lcd_msg("VICKY");						//--- Send a String to LCD
    /* Replace with your application code */
    while (1) 
    {
		twi_lcd_cmd(0xC0);						//--- Select 2nd Row
		twi_lcd_msg("CODE_N_LOGIC");			//--- Send a String to LCD
    }
}


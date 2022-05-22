/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 5/3/2022
Author  : 
Company : 
Comments: 


Chip type               : ATmega8L
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/
#include "twi_i2c.h"
#include "twi_lcd.h"
#include <mega8.h>
#include <stdio.h>
// 1 Wire Bus interface functions
#include <1wire.h>
#include <interrupt.h>
// DS1820 Temperature Sensor functions
#include <ds18b20.h>

// Declare your global variables here

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

// USART Receiver buffer
#define RX_BUFFER_SIZE 5//64
char rx_buffer[RX_BUFFER_SIZE];
unsigned char rx_wr_index=0,rx_rd_index=0;
unsigned char rx_counter=0;

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
    usart_msg("INT: "); 

if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;     
   printf("Buff1-buff2= %x - %x  - %x - %x - %x\r\n", rx_buffer[0], rx_buffer[1],  rx_buffer[2],  rx_buffer[3], rx_buffer[4]);    
   printf ("rx_wr_index= %x \r\n", rx_wr_index);
   if (rx_wr_index == RX_BUFFER_SIZE)
	{ 	
		rx_wr_index=0;
		printf("clear rx_wr_index interrup \r\n");
		}
   if (++rx_counter == RX_BUFFER_SIZE)
    {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif



void main(void)
{
float temp = 0;
  // Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

    twi_init();                                    //--- TWI Initialize
    twi_lcd_init();                                //--- TWI LCD Initialize
    twi_lcd_msg("RF433");                        //--- Send a String to LCD
    /* Replace with your application code */                               

    w1_init();     
   ds18b20_init(NULL, 0 , 0 ,DS18B20_10BIT_RES )  ; 
     sei(); //cho phep ngat toan cuc
//    twi_lcd_cmd(0xC0);    
//    twi_lcd_msg("nhiet do: \r\n"); 
    while (1) 
    {   
     // printf("hien thi so a \r\n");               
//     twi_lcd_cmd(0xC0);   
//        temp = ds18b20_temperature(NULL)  ;
//        twi_lcd_msg("nhiet do: \r\n"); 
//        printf(" %f", temp);  
//        delay_ms(500); 
     if((rx_buffer[0] == 'a'))// && (rx_buffer[1] == '*'))    
        {  
        twi_lcd_cmd(0xC0);           
           delay_ms(500);
      //     printf("hien thi so a \r\n");   
             twi_lcd_cmd(0xC0);    
             twi_lcd_msg("nhietdo: "); 
            twi_lcd_dwr(rx_buffer[1]);
            twi_lcd_dwr(rx_buffer[2]);  
            twi_lcd_dwr(46); 
            twi_lcd_dwr(rx_buffer[3]);       
            if(rx_buffer[4] == 'e') 
            {   
            //    printf("clear rx_wr_index in while \r\n ");    
               rx_buffer[0] = 0; 
               rx_buffer[4] = 0;
//               rx_wr_index =0;
             }
        }  
//      else if(rx_buffer[0] != 'a')
//         {   
//          delay_ms(500);
//          usart_msg("data clear buffer");   
//           usart_msg("\r\n buffer 0: ");
//          usart_tx(rx_buffer[0]);  
//           usart_msg("\r\n buffer 1: ");   
//           usart_tx(rx_buffer[1]);   
//           usart_msg("\r\n buffer 2: ");
//           usart_tx(rx_buffer[2]);  
//           usart_msg("\r\n buffer 3: ");
//           usart_tx(rx_buffer[3]);  
//           usart_msg("\r\n buffer 4: ");     
//           usart_tx(rx_buffer[4]); 

//           rx_buffer[0] =0;
//           rx_buffer[1] =0;
//           rx_buffer[2] =0;
//           rx_buffer[3] =0;       
//           rx_buffer[4] =0;   
//            rx_wr_index =0;
//         }
    }
}

/*
		
		TWI Enable in Master Mode 
		"TWI.h"
	
*/


#ifndef TWI_H_					/* Define library H file if not defined */
#define TWI_H_

//#define F_CPU 8000000UL						//--- F_CPU Defined 16MHz 
#include <io.h>								//--- AVR IO lib File
#include <delay.h>							//--- Delay Lib file
#include <twi.h>							//--- TWI Status File
#include <math.h>								//--- Math Func
#define SCL_CLK 400000L							//--- SCL for TWI
#define BITRATE(TWSR)	((F_CPU/SCL_CLK)-16)/(2*pow(4,(TWSR&((1<<TWPS0)|(1<<TWPS1)))))		//--- Bitrate formula 

//#define TW_MT_SLA_ACK

 /// 
void twi_start();
void twi_init();
void twi_repeated_start();
void twi_write_cmd(unsigned char address);
void twi_write_dwr(unsigned char data);
void twi_stop();
char twi_read_ack();
char twi_read_nack();

void usart_init();
void usart_tx(char x);
void usart_msg(char *c);
unsigned char usart_rx();

#endif											/* I2C_MASTER_H_FILE_H_ */
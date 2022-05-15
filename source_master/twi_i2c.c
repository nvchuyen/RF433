/*

		TWI MAIN FILE
		twi.c
*/

#include "twi_i2c.h"
#include <mega8.h>
#include <delay.h>
#define F_CPU 8000000UL	

void twi_init()
{
	DDRC = 0x30;								//--- PORTC Last two bit as Output
	PORTC = 0x30;
	
	usart_init();								//--- Usart Initialization
	usart_msg("I2C INIT MASTER:");				        //--- Send String to Com Port of PC
	usart_tx(0x0d);								//--- Next Line
	
	TWCR &= ~(1<<TWEN);							//--- Diable TWI
	TWBR = BITRATE(TWSR = 0x00);	 			//--- Bit rate with prescaler 4
	TWCR = (1<<TWEN);							//--- Enable TWI
	delay_us(10);								//--- Delay
}

/* Function to Send Start Condition */

void twi_start()
{
    char status;
	TWCR= (1<<TWINT)|(1<<TWSTA)|(1<<TWEN);		//--- Start Condition as per Datasheet
	while(!(TWCR & (1<<TWINT)));				//--- Wait till start condition is transmitted to Slave
    while(!(TWCR&(1<<TWINT)));	                /* Wait until TWI finish its current job */
    status=TWSR&0xF8;		                    /* Read TWI status register */
    if(status!=0x10) return ;		            /* Check for repeated start transmitted */
    			                        
//	usart_msg("Start Exe.");					//--- Feedback msg to check for error
//	usart_tx(0x0D);								//--- Next Line
}

/* Function to Send Slave Address for Write operation */

void twi_write_cmd(unsigned char address)
{
    char status;
	TWDR=address;								//--- SLA Address and write instruction
	TWCR=(1<<TWINT)|(1<<TWEN);					//--- Clear TWI interrupt flag,Enable TWI
	while (!(TWCR & (1<<TWINT)));				//--- Wait till complete TWDR byte transmitted to Slave
    status=TWSR&0xF8;		    /* Read TWI status register */
    if(status==0x28) return ;	/* Check for data transmitted &ack received */
   
//	usart_msg("ACK Received for MT SLA");		//--- Feedback msg to check for error 
//	usart_tx(0x0D);								//--- Next Line
}

/* Function to Send Data to Slave Device  */

void twi_write_dwr(unsigned char data)
{
    char status;
	TWDR=data;									//--- Put data in TWDR
	TWCR=(1<<TWINT)|(1<<TWEN);					//--- Clear TWI interrupt flag,Enable TWI
	while(!(TWCR&(1<<TWINT)));	/* Wait until TWI finish its current job */
    status=TWSR&0xF8;		    /* Read TWI status register */
    if(status==0x28) return ;	/* Check for data transmitted &ack received */
    
//	usart_msg("ACK Received for MT Data");		//--- Feedback msg to check error
//	usart_tx(0x0D);								//--- Next Line

}

/* Function to Send Stop Condition */

void twi_stop()
{
	TWCR = (1<<TWINT)|(1<<TWEN)|(1<<TWSTO);		//--- Stop Condition as per Datasheet
}

/* Function to Send Repeated Start Condition */


void twi_repeated_start()
{
    char status;
	TWCR= (1<<TWINT)|(1<<TWSTA)|(1<<TWEN);		//--- Repeated Start Condition as per Datasheet
	while(!(TWCR & (1<<TWINT)));				//--- Wait till restart condition is transmitted to Slave
	status=TWSR&0xF8;		/* Read TWI status register */
    if(status!=0x10)     return ;		/* Check for repeated start transmitted */

	usart_msg("Repeated Start Exe.");			//--- Feedback msg to check error
	usart_tx(0x0D);								//--- Next Line
}


/* Function to Send Read Acknowledgment */

char twi_read_ack()
{
	TWCR=(1<<TWEN)|(1<<TWINT)|(1<<TWEA);		//--- Acknowledgment Condition as per Datasheet
	while (!(TWCR & (1<<TWINT)));				//--- Wait until Acknowledgment Condition is transmitted to Slave
//	while(TW_STATUS != TW_MR_DATA_ACK);			//--- Check for Acknowledgment 						
//	usart_msg("Receiving MR data ACK ");		//--- Feedback msg to check error
//	usart_tx(0x0D);								//--- Next Line
	return TWDR;								//--- Return received data from Slave
}

/* Function to Send Read No Acknowledgment */

char twi_read_nack()
{
	TWCR=(1<<TWEN)|(1<<TWINT);					//--- No Acknowledgment Condition as per Datasheet
	while (!(TWCR & (1<<TWINT)));				//--- Wait until No Acknowledgment Condition is transmitted to Slave
//	while(TW_STATUS != TW_MR_DATA_NACK);		//--- Check for Acknowledgment
//	usart_msg("Receiving MR Data NACK");		//--- Feedback msg to check error
//	usart_tx(0x0D);								//--- Next Line
	return TWDR;								//--- Return received data
}

/* Function to Initialize USART */

void usart_init()
{
	UBRRH = 0;										//--- USART Baud Rate is set to 115200
	UBRRL = UBRRL=0x33;//0x08;	
	UCSRC = (1<<URSEL) | (1<<UCSZ1) | (1<<UCSZ0);	//--- 8-Bit Data Selected
	UCSRB = (1<<TXEN) | (1<<RXEN) | (1<<RXCIE);					//--- Enable TX & RX
}

/* Function to Transmit data */

void usart_tx(char x)
{
	while (!( UCSRA & (1<<UDRE)));					//--- Check for Buffer is empty
	UDR = x;										//--- Send data to USART Buffer
}

/* Function to Receive data */

unsigned char usart_rx()
{
	while(!(UCSRA & (1<<RXC)));						//--- Check for data received completed
	return(UDR);									//--- Return the received data
}

/* Function to transmit string */

void usart_msg(char *c)
{
	while(*c != '\0')								//--- Check for Null
	usart_tx(*c++);									//--- Send the String
}


/****** END of Program ******/
//--------??? ?? ---------------//
#include <16F877a.h>
#fuses HS,NOWDT,NOPROTECT,NOLVP
#use delay(clock=20000000)
#use rs232 (baud = 115200, errors, parity=N, xmit = PIN_C6, rcv = PIN_C7)

//--------?? define-------------//
#define Buzzer_ON		output_high(PIN_C0)
#define Buzzer_OFF		output_low(PIN_C0)
#define ch_nibp_DC 	0
#define ch_nibp_AC 	1
#define ch_ecg 		2
#define ch_ppg 		3

int Timer_flag = 0;
int MA_buffer_ecg[8] = {0,0,0,0,0,0,0,0};	// buffer array for moving average filter
int MA_buffer_ppg[8] = {0,0,0,0,0,0,0,0};	// buffer array for moving average filter
int MA_buffer_nibp_AC[8] = {0,0,0,0,0,0,0,0};	// buffer array for moving average filter
int MA_buffer_nibp_DC[8] = {0,0,0,0,0,0,0,0};	// buffer array for moving average filter

int ecg_out = 10;
int ppg_out = 10;
int nibp_AC_out = 10;
int nibp_DC_out = 10;


int ecg_data = 10;	
int ppg_data = 10;
int nibp_AC_data = 10;
int nibp_DC_data = 10;


//--------?? ?? ??-------//
void system_Init(void);

int MA_Filter_8point_ecg(int data);
int MA_Filter_8point_ppg(int data);
int MA_Filter_8point_nibp_AC(int data);
int MA_Filter_8point_nibp_DC(int data);

void biosignal_ch_sel(int ch);
void rs232_out(void);

//------- ???? ??? ------//
#INT_RTCC
RTCC_ISR(){
	set_RTCC(94);		// 480Hz sampling : 1?? 480?

	biosignal_ch_sel(ch_ecg);
	ecg_data = read_adc(); 
	ecg_out = MA_Filter_8point_ecg(ecg_data);

	biosignal_ch_sel(ch_ppg);
	ppg_data = read_adc(); 
	ppg_out = MA_Filter_8point_ppg(ppg_data);

	biosignal_ch_sel(ch_nibp_AC);
	nibp_AC_data = read_adc(); 
	nibp_AC_out = MA_Filter_8point_nibp_AC(nibp_AC_data);
 	nibp_AC_out = nibp_AC_data;

	biosignal_ch_sel(ch_nibp_DC);
	nibp_DC_data = read_adc(); 
	nibp_DC_out = MA_Filter_8point_nibp_DC(nibp_DC_data);
	nibp_DC_out = nibp_DC_data;
rs232_out();
	Timer_flag = 1;
}

//----------?? ??-----------//
void main() {

	int timeCnt = 0;
	
	//stem_Init();		//??? ???
	
	while(1){
		putc(0x31);
		delay_ms(400);
		putc(0x32);
		delay_ms(400);
	}// End of while()...



}// End of main()...



//------------?? ???----------//
// ??? ??? ?? //

void system_Init(void){

	Buzzer_OFF;					//?? ???
	setup_adc_ports(ALL_ANALOG);
	setup_adc(ADC_CLOCK_INTERNAL);

	biosignal_ch_sel(ch_ecg);
	setup_counters(rtcc_internal, rtcc_div_64);
	enable_interrupts(int_rtcc);
	enable_interrupts(global);
	
}//End of System_Init()...


int MA_Filter_8point_ecg(int data)
{
	int i;
	unsigned long MA_Output=0;

	for(i=0;i<7;i++)  MA_buffer_ecg[i] = MA_buffer_ecg[i+1];
	MA_buffer_ecg[7] = data;
	for(i=0;i<8;i++) MA_Output += MA_buffer_ecg[i];
	MA_Output = (MA_Output >> 3);
	
	return (int)MA_Output;	
}//End of MA_filter()...

int MA_Filter_8point_ppg(int data)
{
	int i;
	unsigned long MA_Output=0;

	for(i=0;i<7;i++)  MA_buffer_ppg[i] = MA_buffer_ppg[i+1];
	MA_buffer_ppg[7] = data;
	for(i=0;i<8;i++) MA_Output += MA_buffer_ppg[i];
	MA_Output = (MA_Output >> 3);
	
	return (int)MA_Output;	
}//End of MA_filter()...

int MA_Filter_8point_nibp_AC(int data)
{
	int i;
	unsigned long MA_Output=0;

	for(i=0;i<7;i++)  MA_buffer_nibp_AC[i] = MA_buffer_nibp_AC[i+1];
	MA_buffer_nibp_AC[7] = data;
	for(i=0;i<8;i++) MA_Output += MA_buffer_nibp_AC[i];
	MA_Output = (MA_Output >> 3);
	
	return (int)MA_Output;	
}//End of MA_filter()...

int MA_Filter_8point_nibp_DC(int data)
{
	int i;
	unsigned long MA_Output=0;

	for(i=0;i<7;i++)  MA_buffer_nibp_DC[i] = MA_buffer_nibp_DC[i+1];
	MA_buffer_nibp_DC[7] = data;
	for(i=0;i<8;i++) MA_Output += MA_buffer_nibp_DC[i];
	MA_Output = (MA_Output >> 3);
	
	return (int)MA_Output;	
}//End of MA_filter()...

void biosignal_ch_sel(int ch){
	set_adc_channel(ch);
	delay_us(20);
}

void rs232_out(void){

	if(ecg_out == 0xff) ecg_out = 0xfd;
	if(ppg_out == 0xff)	ppg_out = 0xfd;
	if(nibp_AC_out == 0xff)	nibp_AC_out = 0xfd;
	if(nibp_DC_out == 0xff) nibp_DC_out = 0xfd;

	putc(0xff);			//for checking data
//	delay_us(10);
	putc(ecg_out);
//	delay_us(10);
	putc(ppg_out);
//	delay_us(10);
	putc(nibp_AC_out);
//	delay_us(10);
	putc(nibp_DC_out);
	delay_us(10);
}
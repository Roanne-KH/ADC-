  
#ifndef DIO_H
#define	DIO_H

#define OUT    1
#define IN     0


void _setPIN(int pinNum);

void _resetPIN(int pinNum);

// Data Direction Functions for PORT
void PORTAas(int dir);
void PORTBas(int dir);
void PORTCas(int dir);
void PORTDas(int dir);

// Data Direction Functions for PINs
void PINAas(int pinNum, int dir);
void PINBas(int pinNum, int dir);
void PINCas(int pinNum, int dir);
void PINDas(int pinNum, int dir);

void setPORTA(int data);
void setPORTB(int data);
void setPORTC(int data);
void setPORTD(int data);

int isPressedA(int pinNum);
int isPressedB(int pinNum);
int isPressedC(int pinNum);
int isPressedD(int pinNum);

void setPIN(int pinNum, char port);

void resetPIN(int pinNum, char port);

void setPINA(int pinNum);

void setPINB(int pinNum);

void setPINC(int pinNum);

void setPIND(int pinNum);

void togglePIND(int pinNum);


#include <xc.h> // include processor files - each processor file is guarded.  

// TODO Insert appropriate #include <>

// TODO Insert C++ class definitions if appropriate

// TODO Insert declarations

// Comment a function and leverage automatic documentation with slash star star
/**
    <p><b>Function prototype:</b></p>
  
    <p><b>Summary:</b></p>

    <p><b>Description:</b></p>

    <p><b>Precondition:</b></p>

    <p><b>Parameters:</b></p>

    <p><b>Returns:</b></p>

    <p><b>Example:</b></p>
    <code>
 
    </code>

    <p><b>Remarks:</b></p>
 */
// TODO Insert declarations or function prototypes (right here) to leverage 
// live documentation

#ifdef	__cplusplus
extern "C" {
#endif /* __cplusplus */

    // TODO If C++ is being used, regular C code needs function names to have C 
    // linkage so the functions can be used by the c code. 

#ifdef	__cplusplus
}
#endif /* __cplusplus */

#endif	/* XC_HEADER_TEMPLATE_H */


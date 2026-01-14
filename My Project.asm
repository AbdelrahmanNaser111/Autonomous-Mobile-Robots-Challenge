
_delay1ms:

;abd.c,99 :: 		void delay1ms(void)
;abd.c,101 :: 		TMR0 = 6u;
	MOVLW      6
	MOVWF      TMR0+0
;abd.c,102 :: 		INTCON &= 0xFB;          // clear T0IF (bit2) using mask: 11111011b = 0xFB
	MOVLW      251
	ANDWF      INTCON+0, 1
;abd.c,103 :: 		while ((INTCON & 0x04) == 0u) { }   // wait T0IF=1
L_delay1ms0:
	MOVLW      4
	ANDWF      INTCON+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_delay1ms1
	GOTO       L_delay1ms0
L_delay1ms1:
;abd.c,104 :: 		}
L_end_delay1ms:
	RETURN
; end of _delay1ms

_delay_ms:

;abd.c,106 :: 		void delay_ms(unsigned int ms)
;abd.c,109 :: 		for (i = 0; i < ms; i++)
	CLRF       delay_ms_i_L0+0
	CLRF       delay_ms_i_L0+1
L_delay_ms2:
	MOVF       FARG_delay_ms_ms+1, 0
	SUBWF      delay_ms_i_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__delay_ms128
	MOVF       FARG_delay_ms_ms+0, 0
	SUBWF      delay_ms_i_L0+0, 0
L__delay_ms128:
	BTFSC      STATUS+0, 0
	GOTO       L_delay_ms3
;abd.c,110 :: 		delay1ms();
	CALL       _delay1ms+0
;abd.c,109 :: 		for (i = 0; i < ms; i++)
	INCF       delay_ms_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       delay_ms_i_L0+1, 1
;abd.c,110 :: 		delay1ms();
	GOTO       L_delay_ms2
L_delay_ms3:
;abd.c,111 :: 		}
L_end_delay_ms:
	RETURN
; end of _delay_ms

_delay2us:

;abd.c,116 :: 		void delay2us(void)
;abd.c,118 :: 		asm nop; asm nop; asm nop; asm nop;
	NOP
	NOP
	NOP
	NOP
;abd.c,119 :: 		}
L_end_delay2us:
	RETURN
; end of _delay2us

_delay10us:

;abd.c,120 :: 		void delay10us(void)
;abd.c,122 :: 		asm nop; asm nop; asm nop; asm nop; asm nop;
	NOP
	NOP
	NOP
	NOP
	NOP
;abd.c,123 :: 		asm nop; asm nop; asm nop; asm nop; asm nop;
	NOP
	NOP
	NOP
	NOP
	NOP
;abd.c,124 :: 		asm nop; asm nop; asm nop; asm nop; asm nop;
	NOP
	NOP
	NOP
	NOP
	NOP
;abd.c,125 :: 		asm nop; asm nop; asm nop; asm nop; asm nop;
	NOP
	NOP
	NOP
	NOP
	NOP
;abd.c,126 :: 		}
L_end_delay10us:
	RETURN
; end of _delay10us

_pwm_init:

;abd.c,129 :: 		void pwm_init(void)
;abd.c,131 :: 		TRISC &= (unsigned char)(~M_RC2);
	MOVLW      251
	ANDWF      TRISC+0, 1
;abd.c,132 :: 		PR2 = (unsigned char)PWM_PR2;
	MOVLW      99
	MOVWF      PR2+0
;abd.c,133 :: 		TMR2 = 0;
	CLRF       TMR2+0
;abd.c,134 :: 		T2CON = 0x05;      // Timer2 ON, prescale 1:4
	MOVLW      5
	MOVWF      T2CON+0
;abd.c,135 :: 		CCP1CON = 0x0C;    // PWM mode
	MOVLW      12
	MOVWF      CCP1CON+0
;abd.c,136 :: 		}
L_end_pwm_init:
	RETURN
; end of _pwm_init

_pwm_set:

;abd.c,138 :: 		void pwm_set(unsigned int duty)
;abd.c,143 :: 		if (duty >= PWM_FULL) duty = PWM_FULL - 1u;
	MOVLW      1
	SUBWF      FARG_pwm_set_duty+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__pwm_set133
	MOVLW      144
	SUBWF      FARG_pwm_set_duty+0, 0
L__pwm_set133:
	BTFSS      STATUS+0, 0
	GOTO       L_pwm_set5
	MOVLW      143
	MOVWF      FARG_pwm_set_duty+0
	MOVLW      1
	MOVWF      FARG_pwm_set_duty+1
L_pwm_set5:
;abd.c,145 :: 		CCPR1L = (unsigned char)(duty / 4u);
	MOVF       FARG_pwm_set_duty+0, 0
	MOVWF      R0+0
	MOVF       FARG_pwm_set_duty+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      CCPR1L+0
;abd.c,146 :: 		low2 = duty % 4u;
	MOVLW      3
	ANDWF      FARG_pwm_set_duty+0, 0
	MOVWF      R1+0
	MOVF       FARG_pwm_set_duty+1, 0
	MOVWF      R1+1
	MOVLW      0
	ANDWF      R1+1, 1
	MOVF       R1+0, 0
	MOVWF      R3+0
	MOVF       R1+1, 0
	MOVWF      R3+1
;abd.c,149 :: 		if (low2 == 0u) add = 0x00;
	MOVLW      0
	XORWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__pwm_set134
	MOVLW      0
	XORWF      R1+0, 0
L__pwm_set134:
	BTFSS      STATUS+0, 2
	GOTO       L_pwm_set6
	CLRF       R5+0
	GOTO       L_pwm_set7
L_pwm_set6:
;abd.c,150 :: 		else if (low2 == 1u) add = 0x10;
	MOVLW      0
	XORWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__pwm_set135
	MOVLW      1
	XORWF      R3+0, 0
L__pwm_set135:
	BTFSS      STATUS+0, 2
	GOTO       L_pwm_set8
	MOVLW      16
	MOVWF      R5+0
	GOTO       L_pwm_set9
L_pwm_set8:
;abd.c,151 :: 		else if (low2 == 2u) add = 0x20;
	MOVLW      0
	XORWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__pwm_set136
	MOVLW      2
	XORWF      R3+0, 0
L__pwm_set136:
	BTFSS      STATUS+0, 2
	GOTO       L_pwm_set10
	MOVLW      32
	MOVWF      R5+0
	GOTO       L_pwm_set11
L_pwm_set10:
;abd.c,152 :: 		else add = 0x30;
	MOVLW      48
	MOVWF      R5+0
L_pwm_set11:
L_pwm_set9:
L_pwm_set7:
;abd.c,154 :: 		CCP1CON = (unsigned char)((CCP1CON & 0xCFu) | add);
	MOVLW      207
	ANDWF      CCP1CON+0, 0
	MOVWF      R0+0
	MOVF       R5+0, 0
	IORWF      R0+0, 0
	MOVWF      CCP1CON+0
;abd.c,155 :: 		}
L_end_pwm_set:
	RETURN
; end of _pwm_set

_motors_stop:

;abd.c,158 :: 		void motors_stop(void) { PORTC &= (unsigned char)(~M_DIR_ALL); }
	MOVLW      198
	ANDWF      PORTC+0, 1
L_end_motors_stop:
	RETURN
; end of _motors_stop

_motors_forward:

;abd.c,160 :: 		void motors_forward(void)
;abd.c,162 :: 		PORTC = (PORTC & (unsigned char)(~M_DIR_ALL)) | (M_RC0 | M_RC4);
	MOVLW      198
	ANDWF      PORTC+0, 0
	MOVWF      R0+0
	MOVLW      17
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;abd.c,163 :: 		}
L_end_motors_forward:
	RETURN
; end of _motors_forward

_pivot_left_dir:

;abd.c,165 :: 		void pivot_left_dir(void)
;abd.c,167 :: 		PORTC = (PORTC & (unsigned char)(~M_DIR_ALL)) | (M_RC3 | M_RC4);
	MOVLW      198
	ANDWF      PORTC+0, 0
	MOVWF      R0+0
	MOVLW      24
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;abd.c,168 :: 		}
L_end_pivot_left_dir:
	RETURN
; end of _pivot_left_dir

_pivot_right_dir:

;abd.c,170 :: 		void pivot_right_dir(void)
;abd.c,172 :: 		PORTC = (PORTC & (unsigned char)(~M_DIR_ALL)) | (M_RC0 | M_RC5);
	MOVLW      198
	ANDWF      PORTC+0, 0
	MOVWF      R0+0
	MOVLW      33
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;abd.c,173 :: 		}
L_end_pivot_right_dir:
	RETURN
; end of _pivot_right_dir

_left_coast:

;abd.c,175 :: 		void left_coast(void)  { PORTC &= (unsigned char)(~(M_RC0 | M_RC3)); }
	MOVLW      246
	ANDWF      PORTC+0, 1
L_end_left_coast:
	RETURN
; end of _left_coast

_right_coast:

;abd.c,176 :: 		void right_coast(void) { PORTC &= (unsigned char)(~(M_RC4 | M_RC5)); }
	MOVLW      207
	ANDWF      PORTC+0, 1
L_end_right_coast:
	RETURN
; end of _right_coast

_left_black:

;abd.c,179 :: 		unsigned char left_black(void)
;abd.c,181 :: 		unsigned char raw = (PORTB & M_L_LINE) ? 1u : 0u;
	BTFSS      PORTB+0, 7
	GOTO       L_left_black12
	MOVLW      1
	MOVWF      R1+0
	GOTO       L_left_black13
L_left_black12:
	CLRF       R1+0
L_left_black13:
;abd.c,183 :: 		return (raw == 0u) ? 1u : 0u;
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_left_black14
	MOVLW      1
	MOVWF      R2+0
	GOTO       L_left_black15
L_left_black14:
	CLRF       R2+0
L_left_black15:
	MOVF       R2+0, 0
	MOVWF      R0+0
;abd.c,187 :: 		}
L_end_left_black:
	RETURN
; end of _left_black

_right_black:

;abd.c,189 :: 		unsigned char right_black(void)
;abd.c,191 :: 		unsigned char raw = (PORTB & M_R_LINE) ? 1u : 0u;
	BTFSS      PORTB+0, 6
	GOTO       L_right_black16
	MOVLW      1
	MOVWF      R1+0
	GOTO       L_right_black17
L_right_black16:
	CLRF       R1+0
L_right_black17:
;abd.c,193 :: 		return (raw == 0u) ? 1u : 0u;
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_right_black18
	MOVLW      1
	MOVWF      R2+0
	GOTO       L_right_black19
L_right_black18:
	CLRF       R2+0
L_right_black19:
	MOVF       R2+0, 0
	MOVWF      R0+0
;abd.c,197 :: 		}
L_end_right_black:
	RETURN
; end of _right_black

_ir_right_detect:

;abd.c,199 :: 		unsigned char ir_right_detect(void)
;abd.c,201 :: 		unsigned char raw = (PORTD & M_IRR) ? 1u : 0u;
	BTFSS      PORTD+0, 4
	GOTO       L_ir_right_detect20
	MOVLW      1
	MOVWF      R1+0
	GOTO       L_ir_right_detect21
L_ir_right_detect20:
	CLRF       R1+0
L_ir_right_detect21:
;abd.c,203 :: 		return (raw == 0u) ? 1u : 0u;
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ir_right_detect22
	MOVLW      1
	MOVWF      R2+0
	GOTO       L_ir_right_detect23
L_ir_right_detect22:
	CLRF       R2+0
L_ir_right_detect23:
	MOVF       R2+0, 0
	MOVWF      R0+0
;abd.c,207 :: 		}
L_end_ir_right_detect:
	RETURN
; end of _ir_right_detect

_ir_left_detect:

;abd.c,209 :: 		unsigned char ir_left_detect(void)
;abd.c,211 :: 		unsigned char raw = (PORTD & M_IRL) ? 1u : 0u;
	BTFSS      PORTD+0, 5
	GOTO       L_ir_left_detect24
	MOVLW      1
	MOVWF      R1+0
	GOTO       L_ir_left_detect25
L_ir_left_detect24:
	CLRF       R1+0
L_ir_left_detect25:
;abd.c,213 :: 		return (raw == 0u) ? 1u : 0u;
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ir_left_detect26
	MOVLW      1
	MOVWF      R2+0
	GOTO       L_ir_left_detect27
L_ir_left_detect26:
	CLRF       R2+0
L_ir_left_detect27:
	MOVF       R2+0, 0
	MOVWF      R0+0
;abd.c,217 :: 		}
L_end_ir_left_detect:
	RETURN
; end of _ir_left_detect

_ldr_read:

;abd.c,220 :: 		unsigned int ldr_read(void)
;abd.c,223 :: 		ADCON1 = 0x8E; // AN0 analog, right-justified
	MOVLW      142
	MOVWF      ADCON1+0
;abd.c,224 :: 		ADCON0 = 0x81; // CH0, ADON=1, Fosc/32
	MOVLW      129
	MOVWF      ADCON0+0
;abd.c,225 :: 		delay_ms(2);   // was Delay_ms(2)
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_ldr_read28:
	DECFSZ     R13+0, 1
	GOTO       L_ldr_read28
	DECFSZ     R12+0, 1
	GOTO       L_ldr_read28
	NOP
;abd.c,227 :: 		ADCON0 |= 0x04;               // GO/DONE
	BSF        ADCON0+0, 2
;abd.c,228 :: 		while (ADCON0 & 0x04) { }
L_ldr_read29:
	BTFSS      ADCON0+0, 2
	GOTO       L_ldr_read30
	GOTO       L_ldr_read29
L_ldr_read30:
;abd.c,229 :: 		v = (unsigned int)ADRESH * 256u + (unsigned int)ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R4+0
	CLRF       R4+1
	MOVF       R4+0, 0
	MOVWF      R2+1
	CLRF       R2+0
	MOVF       ADRESL+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R2+0, 0
	ADDWF      R0+0, 1
	MOVF       R2+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
;abd.c,230 :: 		return v;
;abd.c,231 :: 		}
L_end_ldr_read:
	RETURN
; end of _ldr_read

_ldr_buzzer_update:

;abd.c,233 :: 		void ldr_buzzer_update(unsigned int ldr)
;abd.c,235 :: 		if (!in_dark)
	MOVF       _in_dark+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_ldr_buzzer_update31
;abd.c,237 :: 		if (ldr <= LDR_ENTER)
	MOVF       FARG_ldr_buzzer_update_ldr+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__ldr_buzzer_update149
	MOVF       FARG_ldr_buzzer_update_ldr+0, 0
	SUBLW      160
L__ldr_buzzer_update149:
	BTFSS      STATUS+0, 0
	GOTO       L_ldr_buzzer_update32
;abd.c,239 :: 		if (dark_cnt < 255) dark_cnt++;
	MOVLW      255
	SUBWF      _dark_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_ldr_buzzer_update33
	INCF       _dark_cnt+0, 1
L_ldr_buzzer_update33:
;abd.c,240 :: 		if (dark_cnt >= LDR_STABLE)
	MOVLW      3
	SUBWF      _dark_cnt+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_ldr_buzzer_update34
;abd.c,242 :: 		in_dark = 1;
	MOVLW      1
	MOVWF      _in_dark+0
;abd.c,243 :: 		dark_cnt = 0;
	CLRF       _dark_cnt+0
;abd.c,244 :: 		bright_cnt = 0;
	CLRF       _bright_cnt+0
;abd.c,245 :: 		}
L_ldr_buzzer_update34:
;abd.c,246 :: 		}
	GOTO       L_ldr_buzzer_update35
L_ldr_buzzer_update32:
;abd.c,247 :: 		else dark_cnt = 0;
	CLRF       _dark_cnt+0
L_ldr_buzzer_update35:
;abd.c,248 :: 		}
	GOTO       L_ldr_buzzer_update36
L_ldr_buzzer_update31:
;abd.c,251 :: 		if (ldr >= LDR_EXIT)
	MOVLW      0
	SUBWF      FARG_ldr_buzzer_update_ldr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ldr_buzzer_update150
	MOVLW      180
	SUBWF      FARG_ldr_buzzer_update_ldr+0, 0
L__ldr_buzzer_update150:
	BTFSS      STATUS+0, 0
	GOTO       L_ldr_buzzer_update37
;abd.c,253 :: 		if (bright_cnt < 255) bright_cnt++;
	MOVLW      255
	SUBWF      _bright_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_ldr_buzzer_update38
	INCF       _bright_cnt+0, 1
L_ldr_buzzer_update38:
;abd.c,254 :: 		if (bright_cnt >= LDR_STABLE)
	MOVLW      3
	SUBWF      _bright_cnt+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_ldr_buzzer_update39
;abd.c,256 :: 		in_dark = 0;
	CLRF       _in_dark+0
;abd.c,257 :: 		bright_cnt = 0;
	CLRF       _bright_cnt+0
;abd.c,258 :: 		dark_cnt = 0;
	CLRF       _dark_cnt+0
;abd.c,259 :: 		}
L_ldr_buzzer_update39:
;abd.c,260 :: 		}
	GOTO       L_ldr_buzzer_update40
L_ldr_buzzer_update37:
;abd.c,261 :: 		else bright_cnt = 0;
	CLRF       _bright_cnt+0
L_ldr_buzzer_update40:
;abd.c,262 :: 		}
L_ldr_buzzer_update36:
;abd.c,264 :: 		if (in_dark) BUZZ_ON();
	MOVF       _in_dark+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_ldr_buzzer_update41
	BSF        PORTD+0, 1
	GOTO       L_ldr_buzzer_update45
L_ldr_buzzer_update41:
;abd.c,265 :: 		else         BUZZ_OFF();
	MOVLW      253
	ANDWF      PORTD+0, 1
L_ldr_buzzer_update45:
;abd.c,266 :: 		}
L_end_ldr_buzzer_update:
	RETURN
; end of _ldr_buzzer_update

_ultrasonic_within_cm:

;abd.c,271 :: 		unsigned char ultrasonic_within_cm(unsigned char cm)
;abd.c,274 :: 		unsigned int thr_us = (unsigned int)cm * 58u;
	MOVF       FARG_ultrasonic_within_cm_cm+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVLW      58
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      ultrasonic_within_cm_thr_us_L0+0
	MOVF       R0+1, 0
	MOVWF      ultrasonic_within_cm_thr_us_L0+1
;abd.c,278 :: 		PORTB &= (unsigned char)(~M_TRIG);
	MOVLW      247
	ANDWF      PORTB+0, 1
;abd.c,279 :: 		delay2us();
	CALL       _delay2us+0
;abd.c,280 :: 		PORTB |= M_TRIG;
	BSF        PORTB+0, 3
;abd.c,281 :: 		delay10us();
	CALL       _delay10us+0
;abd.c,282 :: 		PORTB &= (unsigned char)(~M_TRIG);
	MOVLW      247
	ANDWF      PORTB+0, 1
;abd.c,285 :: 		timeout = 30000u;
	MOVLW      48
	MOVWF      ultrasonic_within_cm_timeout_L0+0
	MOVLW      117
	MOVWF      ultrasonic_within_cm_timeout_L0+1
;abd.c,286 :: 		while (((PORTB & M_ECHO) == 0u) && timeout) timeout--;
L_ultrasonic_within_cm49:
	MOVLW      4
	ANDWF      PORTB+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonic_within_cm50
	MOVF       ultrasonic_within_cm_timeout_L0+0, 0
	IORWF      ultrasonic_within_cm_timeout_L0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_ultrasonic_within_cm50
L__ultrasonic_within_cm119:
	MOVLW      1
	SUBWF      ultrasonic_within_cm_timeout_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       ultrasonic_within_cm_timeout_L0+1, 1
	GOTO       L_ultrasonic_within_cm49
L_ultrasonic_within_cm50:
;abd.c,287 :: 		if (timeout == 0u) return 0u;
	MOVLW      0
	XORWF      ultrasonic_within_cm_timeout_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ultrasonic_within_cm152
	MOVLW      0
	XORWF      ultrasonic_within_cm_timeout_L0+0, 0
L__ultrasonic_within_cm152:
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonic_within_cm53
	CLRF       R0+0
	GOTO       L_end_ultrasonic_within_cm
L_ultrasonic_within_cm53:
;abd.c,289 :: 		start = TMR1_READ16();
	MOVF       TMR1H+0, 0
	MOVWF      ultrasonic_within_cm_start_L0+0
	CLRF       ultrasonic_within_cm_start_L0+1
	MOVF       ultrasonic_within_cm_start_L0+0, 0
	MOVWF      ultrasonic_within_cm_start_L0+1
	CLRF       ultrasonic_within_cm_start_L0+0
	MOVF       TMR1L+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	ADDWF      ultrasonic_within_cm_start_L0+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      ultrasonic_within_cm_start_L0+1, 1
;abd.c,291 :: 		while (PORTB & M_ECHO)
L_ultrasonic_within_cm54:
	BTFSS      PORTB+0, 2
	GOTO       L_ultrasonic_within_cm55
;abd.c,293 :: 		if ((unsigned int)(TMR1_READ16() - start) > thr_us) return 0u;
	MOVF       TMR1H+0, 0
	MOVWF      R4+0
	CLRF       R4+1
	MOVF       R4+0, 0
	MOVWF      R2+1
	CLRF       R2+0
	MOVF       TMR1L+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R2+0, 0
	ADDWF      R0+0, 1
	MOVF       R2+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       ultrasonic_within_cm_start_L0+0, 0
	SUBWF      R0+0, 0
	MOVWF      R2+0
	MOVF       ultrasonic_within_cm_start_L0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      R0+1, 0
	MOVWF      R2+1
	MOVF       R2+1, 0
	SUBWF      ultrasonic_within_cm_thr_us_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ultrasonic_within_cm153
	MOVF       R2+0, 0
	SUBWF      ultrasonic_within_cm_thr_us_L0+0, 0
L__ultrasonic_within_cm153:
	BTFSC      STATUS+0, 0
	GOTO       L_ultrasonic_within_cm56
	CLRF       R0+0
	GOTO       L_end_ultrasonic_within_cm
L_ultrasonic_within_cm56:
;abd.c,294 :: 		}
	GOTO       L_ultrasonic_within_cm54
L_ultrasonic_within_cm55:
;abd.c,295 :: 		return 1u;
	MOVLW      1
	MOVWF      R0+0
;abd.c,296 :: 		}
L_end_ultrasonic_within_cm:
	RETURN
; end of _ultrasonic_within_cm

_forward_pulse:

;abd.c,299 :: 		void forward_pulse(void)
;abd.c,301 :: 		motors_forward();
	CALL       _motors_forward+0
;abd.c,303 :: 		pwm_set(DUTY_KICK);
	MOVLW      64
	MOVWF      FARG_pwm_set_duty+0
	MOVLW      1
	MOVWF      FARG_pwm_set_duty+1
	CALL       _pwm_set+0
;abd.c,304 :: 		delay_ms(KICK_MS);
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_forward_pulse57:
	DECFSZ     R13+0, 1
	GOTO       L_forward_pulse57
	DECFSZ     R12+0, 1
	GOTO       L_forward_pulse57
	NOP
;abd.c,306 :: 		pwm_set(DUTY_RUN);
	MOVLW      140
	MOVWF      FARG_pwm_set_duty+0
	MOVLW      0
	MOVWF      FARG_pwm_set_duty+1
	CALL       _pwm_set+0
;abd.c,307 :: 		delay_ms(PULSE_ON_MS - KICK_MS);
	MOVLW      34
	MOVWF      R12+0
	MOVLW      195
	MOVWF      R13+0
L_forward_pulse58:
	DECFSZ     R13+0, 1
	GOTO       L_forward_pulse58
	DECFSZ     R12+0, 1
	GOTO       L_forward_pulse58
;abd.c,309 :: 		motors_stop();
	CALL       _motors_stop+0
;abd.c,310 :: 		delay_ms(PULSE_OFF_MS);
	MOVLW      8
	MOVWF      R12+0
	MOVLW      201
	MOVWF      R13+0
L_forward_pulse59:
	DECFSZ     R13+0, 1
	GOTO       L_forward_pulse59
	DECFSZ     R12+0, 1
	GOTO       L_forward_pulse59
	NOP
	NOP
;abd.c,311 :: 		}
L_end_forward_pulse:
	RETURN
; end of _forward_pulse

_line_follow_step:

;abd.c,314 :: 		void line_follow_step(void)
;abd.c,316 :: 		unsigned char L = left_black();
	CALL       _left_black+0
	MOVF       R0+0, 0
	MOVWF      line_follow_step_L_L0+0
;abd.c,317 :: 		unsigned char R = right_black();
	CALL       _right_black+0
	MOVF       R0+0, 0
	MOVWF      line_follow_step_R_L0+0
;abd.c,319 :: 		forward_pulse();
	CALL       _forward_pulse+0
;abd.c,321 :: 		if (L && !R) {
	MOVF       line_follow_step_L_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_line_follow_step62
	MOVF       line_follow_step_R_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_line_follow_step62
L__line_follow_step122:
;abd.c,322 :: 		left_coast(); delay_ms(STEER_MS); last_dir = 0;
	CALL       _left_coast+0
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_line_follow_step63:
	DECFSZ     R13+0, 1
	GOTO       L_line_follow_step63
	DECFSZ     R12+0, 1
	GOTO       L_line_follow_step63
	NOP
	CLRF       _last_dir+0
;abd.c,323 :: 		}
	GOTO       L_line_follow_step64
L_line_follow_step62:
;abd.c,324 :: 		else if (!L && R) {
	MOVF       line_follow_step_L_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_line_follow_step67
	MOVF       line_follow_step_R_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_line_follow_step67
L__line_follow_step121:
;abd.c,325 :: 		right_coast(); delay_ms(STEER_MS); last_dir = 1;
	CALL       _right_coast+0
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L_line_follow_step68:
	DECFSZ     R13+0, 1
	GOTO       L_line_follow_step68
	DECFSZ     R12+0, 1
	GOTO       L_line_follow_step68
	NOP
	MOVLW      1
	MOVWF      _last_dir+0
;abd.c,326 :: 		}
	GOTO       L_line_follow_step69
L_line_follow_step67:
;abd.c,327 :: 		else if (!L && !R) {
	MOVF       line_follow_step_L_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_line_follow_step72
	MOVF       line_follow_step_R_L0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_line_follow_step72
L__line_follow_step120:
;abd.c,328 :: 		if (last_dir == 0) pivot_left_dir();
	MOVF       _last_dir+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_line_follow_step73
	CALL       _pivot_left_dir+0
	GOTO       L_line_follow_step74
L_line_follow_step73:
;abd.c,329 :: 		else               pivot_right_dir();
	CALL       _pivot_right_dir+0
L_line_follow_step74:
;abd.c,331 :: 		pwm_set(DUTY_KICK); delay_ms(20);
	MOVLW      64
	MOVWF      FARG_pwm_set_duty+0
	MOVLW      1
	MOVWF      FARG_pwm_set_duty+1
	CALL       _pwm_set+0
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_line_follow_step75:
	DECFSZ     R13+0, 1
	GOTO       L_line_follow_step75
	DECFSZ     R12+0, 1
	GOTO       L_line_follow_step75
	NOP
	NOP
;abd.c,332 :: 		pwm_set(DUTY_RUN);  delay_ms(LOST_PIVOT_MS - 20);
	MOVLW      140
	MOVWF      FARG_pwm_set_duty+0
	MOVLW      0
	MOVWF      FARG_pwm_set_duty+1
	CALL       _pwm_set+0
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_line_follow_step76:
	DECFSZ     R13+0, 1
	GOTO       L_line_follow_step76
	DECFSZ     R12+0, 1
	GOTO       L_line_follow_step76
	NOP
;abd.c,334 :: 		motors_stop();
	CALL       _motors_stop+0
;abd.c,335 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_line_follow_step77:
	DECFSZ     R13+0, 1
	GOTO       L_line_follow_step77
	DECFSZ     R12+0, 1
	GOTO       L_line_follow_step77
	NOP
;abd.c,336 :: 		}
	GOTO       L_line_follow_step78
L_line_follow_step72:
;abd.c,339 :: 		}
L_line_follow_step78:
L_line_follow_step69:
L_line_follow_step64:
;abd.c,340 :: 		}
L_end_line_follow_step:
	RETURN
; end of _line_follow_step

_two_black_action:

;abd.c,343 :: 		void two_black_action(void)
;abd.c,345 :: 		motors_stop(); pwm_set(0); delay_ms(TWO_BLACK_PAUSE_MS);
	CALL       _motors_stop+0
	CLRF       FARG_pwm_set_duty+0
	CLRF       FARG_pwm_set_duty+1
	CALL       _pwm_set+0
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_two_black_action79:
	DECFSZ     R13+0, 1
	GOTO       L_two_black_action79
	DECFSZ     R12+0, 1
	GOTO       L_two_black_action79
	DECFSZ     R11+0, 1
	GOTO       L_two_black_action79
;abd.c,347 :: 		pivot_left_dir();
	CALL       _pivot_left_dir+0
;abd.c,348 :: 		pwm_set(DUTY_KICK); delay_ms(120);
	MOVLW      64
	MOVWF      FARG_pwm_set_duty+0
	MOVLW      1
	MOVWF      FARG_pwm_set_duty+1
	CALL       _pwm_set+0
	MOVLW      2
	MOVWF      R11+0
	MOVLW      56
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_two_black_action80:
	DECFSZ     R13+0, 1
	GOTO       L_two_black_action80
	DECFSZ     R12+0, 1
	GOTO       L_two_black_action80
	DECFSZ     R11+0, 1
	GOTO       L_two_black_action80
;abd.c,349 :: 		pwm_set(DUTY_RUN);  delay_ms(TWO_BLACK_LEFT_MS - 120);
	MOVLW      140
	MOVWF      FARG_pwm_set_duty+0
	MOVLW      0
	MOVWF      FARG_pwm_set_duty+1
	CALL       _pwm_set+0
	MOVLW      4
	MOVWF      R11+0
	MOVLW      219
	MOVWF      R12+0
	MOVLW      255
	MOVWF      R13+0
L_two_black_action81:
	DECFSZ     R13+0, 1
	GOTO       L_two_black_action81
	DECFSZ     R12+0, 1
	GOTO       L_two_black_action81
	DECFSZ     R11+0, 1
	GOTO       L_two_black_action81
;abd.c,351 :: 		motors_stop(); pwm_set(0); delay_ms(TWO_BLACK_PAUSE_MS);
	CALL       _motors_stop+0
	CLRF       FARG_pwm_set_duty+0
	CLRF       FARG_pwm_set_duty+1
	CALL       _pwm_set+0
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_two_black_action82:
	DECFSZ     R13+0, 1
	GOTO       L_two_black_action82
	DECFSZ     R12+0, 1
	GOTO       L_two_black_action82
	DECFSZ     R11+0, 1
	GOTO       L_two_black_action82
;abd.c,353 :: 		pivot_left_dir();
	CALL       _pivot_left_dir+0
;abd.c,354 :: 		pwm_set(DUTY_KICK); delay_ms(120);
	MOVLW      64
	MOVWF      FARG_pwm_set_duty+0
	MOVLW      1
	MOVWF      FARG_pwm_set_duty+1
	CALL       _pwm_set+0
	MOVLW      2
	MOVWF      R11+0
	MOVLW      56
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_two_black_action83:
	DECFSZ     R13+0, 1
	GOTO       L_two_black_action83
	DECFSZ     R12+0, 1
	GOTO       L_two_black_action83
	DECFSZ     R11+0, 1
	GOTO       L_two_black_action83
;abd.c,355 :: 		pwm_set(DUTY_RUN);  delay_ms(TWO_BLACK_LEFT_MS - 120);
	MOVLW      140
	MOVWF      FARG_pwm_set_duty+0
	MOVLW      0
	MOVWF      FARG_pwm_set_duty+1
	CALL       _pwm_set+0
	MOVLW      4
	MOVWF      R11+0
	MOVLW      219
	MOVWF      R12+0
	MOVLW      255
	MOVWF      R13+0
L_two_black_action84:
	DECFSZ     R13+0, 1
	GOTO       L_two_black_action84
	DECFSZ     R12+0, 1
	GOTO       L_two_black_action84
	DECFSZ     R11+0, 1
	GOTO       L_two_black_action84
;abd.c,357 :: 		motors_stop(); pwm_set(0);
	CALL       _motors_stop+0
	CLRF       FARG_pwm_set_duty+0
	CLRF       FARG_pwm_set_duty+1
	CALL       _pwm_set+0
;abd.c,358 :: 		}
L_end_two_black_action:
	RETURN
; end of _two_black_action

_enter_wall_follow:

;abd.c,361 :: 		void enter_wall_follow(void)
;abd.c,363 :: 		pivot_right_dir();
	CALL       _pivot_right_dir+0
;abd.c,364 :: 		pwm_set(DUTY_KICK); delay_ms(120);
	MOVLW      64
	MOVWF      FARG_pwm_set_duty+0
	MOVLW      1
	MOVWF      FARG_pwm_set_duty+1
	CALL       _pwm_set+0
	MOVLW      2
	MOVWF      R11+0
	MOVLW      56
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_enter_wall_follow85:
	DECFSZ     R13+0, 1
	GOTO       L_enter_wall_follow85
	DECFSZ     R12+0, 1
	GOTO       L_enter_wall_follow85
	DECFSZ     R11+0, 1
	GOTO       L_enter_wall_follow85
;abd.c,365 :: 		pwm_set(DUTY_RUN);  delay_ms(ENTER_WALL_RIGHT_MS - 120);
	MOVLW      140
	MOVWF      FARG_pwm_set_duty+0
	MOVLW      0
	MOVWF      FARG_pwm_set_duty+1
	CALL       _pwm_set+0
	MOVLW      4
	MOVWF      R11+0
	MOVLW      90
	MOVWF      R12+0
	MOVLW      31
	MOVWF      R13+0
L_enter_wall_follow86:
	DECFSZ     R13+0, 1
	GOTO       L_enter_wall_follow86
	DECFSZ     R12+0, 1
	GOTO       L_enter_wall_follow86
	DECFSZ     R11+0, 1
	GOTO       L_enter_wall_follow86
	NOP
	NOP
;abd.c,366 :: 		motors_stop(); pwm_set(0); delay_ms(120);
	CALL       _motors_stop+0
	CLRF       FARG_pwm_set_duty+0
	CLRF       FARG_pwm_set_duty+1
	CALL       _pwm_set+0
	MOVLW      2
	MOVWF      R11+0
	MOVLW      56
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_enter_wall_follow87:
	DECFSZ     R13+0, 1
	GOTO       L_enter_wall_follow87
	DECFSZ     R12+0, 1
	GOTO       L_enter_wall_follow87
	DECFSZ     R11+0, 1
	GOTO       L_enter_wall_follow87
;abd.c,367 :: 		}
L_end_enter_wall_follow:
	RETURN
; end of _enter_wall_follow

_wall_follow_step:

;abd.c,370 :: 		void wall_follow_step(void)
;abd.c,372 :: 		unsigned char rwall = ir_right_detect();
	CALL       _ir_right_detect+0
	MOVF       R0+0, 0
	MOVWF      wall_follow_step_rwall_L0+0
;abd.c,373 :: 		unsigned char lwall = ir_left_detect();
	CALL       _ir_left_detect+0
	MOVF       R0+0, 0
	MOVWF      wall_follow_step_lwall_L0+0
;abd.c,374 :: 		unsigned char close = ultrasonic_within_cm(WALL_DIST_CM);
	MOVLW      5
	MOVWF      FARG_ultrasonic_within_cm_cm+0
	CALL       _ultrasonic_within_cm+0
	MOVF       R0+0, 0
	MOVWF      wall_follow_step_close_L0+0
;abd.c,376 :: 		forward_pulse();
	CALL       _forward_pulse+0
;abd.c,378 :: 		if (close) {
	MOVF       wall_follow_step_close_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_wall_follow_step88
;abd.c,379 :: 		if (rwall)      { left_coast();  delay_ms(WALL_GENTLE_MS); }
	MOVF       wall_follow_step_rwall_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_wall_follow_step89
	CALL       _left_coast+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      201
	MOVWF      R13+0
L_wall_follow_step90:
	DECFSZ     R13+0, 1
	GOTO       L_wall_follow_step90
	DECFSZ     R12+0, 1
	GOTO       L_wall_follow_step90
	NOP
	NOP
	GOTO       L_wall_follow_step91
L_wall_follow_step89:
;abd.c,380 :: 		else if (lwall) { right_coast(); delay_ms(WALL_GENTLE_MS); }
	MOVF       wall_follow_step_lwall_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_wall_follow_step92
	CALL       _right_coast+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      201
	MOVWF      R13+0
L_wall_follow_step93:
	DECFSZ     R13+0, 1
	GOTO       L_wall_follow_step93
	DECFSZ     R12+0, 1
	GOTO       L_wall_follow_step93
	NOP
	NOP
	GOTO       L_wall_follow_step94
L_wall_follow_step92:
;abd.c,381 :: 		else            { left_coast();  delay_ms(WALL_GENTLE_MS); }
	CALL       _left_coast+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      201
	MOVWF      R13+0
L_wall_follow_step95:
	DECFSZ     R13+0, 1
	GOTO       L_wall_follow_step95
	DECFSZ     R12+0, 1
	GOTO       L_wall_follow_step95
	NOP
	NOP
L_wall_follow_step94:
L_wall_follow_step91:
;abd.c,382 :: 		return;
	GOTO       L_end_wall_follow_step
;abd.c,383 :: 		}
L_wall_follow_step88:
;abd.c,385 :: 		if (rwall) {
	MOVF       wall_follow_step_rwall_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_wall_follow_step96
;abd.c,386 :: 		return; // straight
	GOTO       L_end_wall_follow_step
;abd.c,387 :: 		}
L_wall_follow_step96:
;abd.c,389 :: 		right_coast();
	CALL       _right_coast+0
;abd.c,390 :: 		delay_ms(WALL_GENTLE_MS);
	MOVLW      8
	MOVWF      R12+0
	MOVLW      201
	MOVWF      R13+0
L_wall_follow_step97:
	DECFSZ     R13+0, 1
	GOTO       L_wall_follow_step97
	DECFSZ     R12+0, 1
	GOTO       L_wall_follow_step97
	NOP
	NOP
;abd.c,391 :: 		}
L_end_wall_follow_step:
	RETURN
; end of _wall_follow_step

_main:

;abd.c,396 :: 		void main(void)
;abd.c,399 :: 		TRISA = 0x01;          // RA0 input (AN0)
	MOVLW      1
	MOVWF      TRISA+0
;abd.c,400 :: 		TRISB = 0xC4;          // RB7,RB6,RB2 inputs; RB3,RB4 outputs
	MOVLW      196
	MOVWF      TRISB+0
;abd.c,401 :: 		TRISC = 0x00;          // motors + PWM outputs
	CLRF       TRISC+0
;abd.c,402 :: 		TRISD = 0x30;          // RD4,RD5 inputs; RD1 output
	MOVLW      48
	MOVWF      TRISD+0
;abd.c,404 :: 		PORTA = 0;
	CLRF       PORTA+0
;abd.c,405 :: 		PORTB = 0;
	CLRF       PORTB+0
;abd.c,406 :: 		PORTC = 0;
	CLRF       PORTC+0
;abd.c,411 :: 		PORTD = (unsigned char)(PORTD & (unsigned char)(~M_BUZZ)); // OFF
	MOVLW      253
	ANDWF      PORTD+0, 1
;abd.c,416 :: 		OPTION_REG = 0x02;
	MOVLW      2
	MOVWF      OPTION_REG+0
;abd.c,419 :: 		T1CON = 0x11;
	MOVLW      17
	MOVWF      T1CON+0
;abd.c,421 :: 		pwm_init();
	CALL       _pwm_init+0
;abd.c,423 :: 		while (1)
L_main98:
;abd.c,425 :: 		unsigned char L = left_black();
	CALL       _left_black+0
	MOVF       R0+0, 0
	MOVWF      main_L_L1+0
;abd.c,426 :: 		unsigned char R = right_black();
	CALL       _right_black+0
	MOVF       R0+0, 0
	MOVWF      main_R_L1+0
;abd.c,427 :: 		unsigned int  ldr = ldr_read();
	CALL       _ldr_read+0
	MOVF       R0+0, 0
	MOVWF      main_ldr_L1+0
	MOVF       R0+1, 0
	MOVWF      main_ldr_L1+1
;abd.c,429 :: 		ldr_buzzer_update(ldr);
	MOVF       R0+0, 0
	MOVWF      FARG_ldr_buzzer_update_ldr+0
	MOVF       R0+1, 0
	MOVWF      FARG_ldr_buzzer_update_ldr+1
	CALL       _ldr_buzzer_update+0
;abd.c,431 :: 		if (ldr <= LDR_ENTER) PORTB |= M_HEAD;
	MOVF       main_ldr_L1+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main160
	MOVF       main_ldr_L1+0, 0
	SUBLW      160
L__main160:
	BTFSS      STATUS+0, 0
	GOTO       L_main100
	BSF        PORTB+0, 4
	GOTO       L_main101
L_main100:
;abd.c,432 :: 		else                  PORTB &= (unsigned char)(~M_HEAD);
	MOVLW      239
	ANDWF      PORTB+0, 1
L_main101:
;abd.c,434 :: 		if (state == ST_LINE)
	MOVF       _state+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main102
;abd.c,436 :: 		if (L && R && (bb_gap == 0))
	MOVF       main_L_L1+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main105
	MOVF       main_R_L1+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main105
	MOVF       _bb_gap+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main105
L__main125:
;abd.c,438 :: 		if (bb_cnt < 255) bb_cnt++;
	MOVLW      255
	SUBWF      _bb_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main106
	INCF       _bb_cnt+0, 1
L_main106:
;abd.c,439 :: 		if ((bb_cnt >= BB_HOLD_COUNT) && (stage_marker_done == 0))
	MOVLW      5
	SUBWF      _bb_cnt+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main109
	MOVF       _stage_marker_done+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main109
L__main124:
;abd.c,441 :: 		two_black_action();
	CALL       _two_black_action+0
;abd.c,442 :: 		stage_marker_done = 1;
	MOVLW      1
	MOVWF      _stage_marker_done+0
;abd.c,444 :: 		bb_cnt = 0;
	CLRF       _bb_cnt+0
;abd.c,445 :: 		bb_gap = BB_GAP_COUNT;
	MOVLW      8
	MOVWF      _bb_gap+0
;abd.c,446 :: 		}
L_main109:
;abd.c,447 :: 		}
	GOTO       L_main110
L_main105:
;abd.c,450 :: 		bb_cnt = 0;
	CLRF       _bb_cnt+0
;abd.c,451 :: 		if (bb_gap > 0) bb_gap--;
	MOVF       _bb_gap+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main111
	DECF       _bb_gap+0, 1
L_main111:
;abd.c,452 :: 		}
L_main110:
;abd.c,454 :: 		if (stage_marker_done && in_dark)
	MOVF       _stage_marker_done+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main114
	MOVF       _in_dark+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main114
L__main123:
;abd.c,456 :: 		state = ST_TUNNEL;
	MOVLW      1
	MOVWF      _state+0
;abd.c,457 :: 		}
L_main114:
;abd.c,459 :: 		line_follow_step();
	CALL       _line_follow_step+0
;abd.c,460 :: 		}
	GOTO       L_main115
L_main102:
;abd.c,461 :: 		else if (state == ST_TUNNEL)
	MOVF       _state+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main116
;abd.c,463 :: 		line_follow_step();
	CALL       _line_follow_step+0
;abd.c,465 :: 		if (!in_dark)
	MOVF       _in_dark+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main117
;abd.c,467 :: 		enter_wall_follow();
	CALL       _enter_wall_follow+0
;abd.c,468 :: 		state = ST_WALL;
	MOVLW      2
	MOVWF      _state+0
;abd.c,469 :: 		}
L_main117:
;abd.c,470 :: 		}
	GOTO       L_main118
L_main116:
;abd.c,473 :: 		wall_follow_step();
	CALL       _wall_follow_step+0
;abd.c,474 :: 		}
L_main118:
L_main115:
;abd.c,475 :: 		}
	GOTO       L_main98
;abd.c,476 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

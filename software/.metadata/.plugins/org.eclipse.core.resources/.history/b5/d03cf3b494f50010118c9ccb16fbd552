#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h" // Biblioteca para controlar o Timer
#include "sys/alt_irq.h"              // Biblioteca para gerenciar Interrupções

// Variável global para guardar o estado dos LEDs
// 'volatile' diz ao compilador: "Não otimize essa variável, ela muda sozinha na interrupção"
volatile int led_state = 0;

// ============================================================================
// 1. A FUNÇÃO DE INTERRUPÇÃO (ISR - Interrupt Service Routine)
// ============================================================================
// Esta função será chamada "magicamente" pelo hardware quando o tempo acabar.
static void handle_timer_interrupt(void *context)
{
    // PASSO CRUCIAL: Limpar o flag de "Timeout" do Timer.
    // Se você esquecer essa linha, o processador vai achar que o timer acabou
    // de novo imediatamente e vai travar num loop infinito aqui dentro.
    IOWR_ALTERA_AVALON_TIMER_STATUS(TIMER_0_BASE, 0);

    // Lógica para piscar (Software Prescaler)
    // O timer padrão do Qsys costuma ser rápido (ex: 1ms ou 10ms).
    // Vamos criar um contador para só piscar a cada X interrupções.
    static int contador_tempo = 0;
    contador_tempo++;

    if (contador_tempo >= 500) // Ajuste esse valor se piscar muito rápido ou devagar
    {
        led_state = !led_state; // Inverte: se era 0 vira 1, se era 1 vira 0

        if (led_state) {
            IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE, 0x3FF); // Acende todos (10 leds)
        } else {
            IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE, 0x000); // Apaga todos
        }

        contador_tempo = 0; // Reseta o contador
    }
}

// ============================================================================
// 2. FUNÇÃO PRINCIPAL
// ============================================================================
int main()
{
    printf("Sistema iniciado! O LED vai piscar por interrupcao.\n");

    // --- Passo A: Registrar a Interrupção ---
    // Dizemos ao sistema: "Quando o TIMER_0 mandar um sinal (IRQ), rode a função 'handle_timer_interrupt'"
    alt_ic_isr_register(
        TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID, // ID do controlador (padrão do sistema)
        TIMER_0_IRQ,                         // Número da linha de interrupção do Timer
        handle_timer_interrupt,              // Nome da nossa função lá em cima
        NULL,                                // Contexto (não usado)
        NULL                                 // Flags (não usado)
    );

    // --- Passo B: Configurar e Ligar o Timer ---
    // Escrevemos no registrador de CONTROLE do Timer:
    // ITO   (Interrupt on Timeout) -> Habilita gerar interrupção
    // CONT  (Continuous)           -> Reinicia a contagem automaticamente após acabar
    // START (Start)                -> Começa a contar agora!
    IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_0_BASE,
        ALTERA_AVALON_TIMER_CONTROL_ITO_MSK  |
        ALTERA_AVALON_TIMER_CONTROL_CONT_MSK |
        ALTERA_AVALON_TIMER_CONTROL_START_MSK);

    // --- Passo C: Loop Infinito ---
    // Note que o loop está VAZIO (ou apenas imprimindo).
    // Não tem usleep() aqui. O processador está livre!
    int contagem_main = 0;
    while(1)
    {
        // Só para provar que o processador não está travado:
        // Vamos imprimir algo no console devagarzinho enquanto o LED pisca frenético.
        // printf("Main rodando livre: %d\n", contagem_main++);
        // usleep(1000000); // Espera 1 segundo no main
    }

    return 0;
}

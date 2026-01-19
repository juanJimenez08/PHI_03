#include <stdio.h>
#include <unistd.h>             // Necessário para usar usleep()
#include "system.h"             // Arquivo com os endereços (LEDS_BASE, HEX_0_BASE...)
#include "altera_avalon_pio_regs.h" // Macros IOWR para escrever nos pinos

// Tabela de codificação para Display de 7 Segmentos (DE1-SoC é Anodo Comum - Active Low)
// O bit 0 é o segmento 'a', bit 6 é o segmento 'g'.
// 0 acende o LED, 1 apaga.
unsigned char tabela_7seg[] = {
    0xC0, // 0
    0xF9, // 1
    0xA4, // 2
    0xB0, // 3
    0x99, // 4
    0x92, // 5
    0x82, // 6
    0xF8, // 7
    0x80, // 8
    0x90  // 9
};

int main()
{
    printf("Teste de Hardware Iniciado!\n");
    printf("Olhe para a sua placa DE1-SoC agora.\n");

    int contador = 0;

    // Loop infinito
    while(1)
    {
        // -------------------------------------------------------
        // 1. Escreve nos LEDs (Binário)
        // -------------------------------------------------------
        // IOWR_ALTERA_AVALON_PIO_DATA(ENDEREÇO, VALOR)
        // LEDS_BASE vem do arquivo system.h gerado pelo BSP
        IOWR_ALTERA_AVALON_PIO_DATA(LEDS_BASE, contador);


        // -------------------------------------------------------
        // 2. Escreve no Display HEX0 (Contagem decimal 0-9)
        // -------------------------------------------------------
        // Usamos o operador % (módulo) para pegar apenas o último dígito (0 a 9)
        int digito = contador % 10;

        // Pega o código hexadecimal correspondente na nossa tabela
        unsigned char valor_display = tabela_7seg[digito];

        // Escreve no HEX_0
        // Nota: Verifique se no seu system.h está HEX_0_BASE ou HEX0_BASE
        // Baseado na sua imagem do Qsys, o nome do componente era HEX_0.
        IOWR_ALTERA_AVALON_PIO_DATA(HEX_0_BASE, valor_display);

        // Se quiser testar os outros, descomente abaixo:
        // IOWR_ALTERA_AVALON_PIO_DATA(HEX_1_BASE, valor_display);
        // IOWR_ALTERA_AVALON_PIO_DATA(HEX_2_BASE, valor_display);


        // -------------------------------------------------------
        // 3. Atualiza e Espera
        // -------------------------------------------------------
        contador++; // Aumenta o contador

        // Espera 100ms (100.000 microsegundos) para dar tempo de ver piscando
        usleep(100000);
    }

    return 0;
}

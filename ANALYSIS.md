# Análise do Repositório

## Visão Geral
Este repositório contém um projeto de Sistema Embarcado baseado em FPGA e processador soft-core Nios II. O objetivo principal do projeto é implementar um controlador de display de texto rolante (scroller) utilizando 6 displays de 7 segmentos.

## Estrutura do Projeto

### Hardware (VHDL)
O hardware é descrito em VHDL e consiste nos seguintes componentes principais:
- **`scroller_avalon.vhd`**: Periférico customizado com interface Avalon-MM (Memory Mapped). Ele atua como uma ponte entre o processador Nios II e a lógica do display.
- **`bloco_controle.vhd`**: Responsável pela lógica de controle do sistema, incluindo:
    - Controle de velocidade do scroll.
    - Funcionalidade de pausa/play.
    - Cálculo do índice do caractere a ser exibido.
    - Interface com botões físicos e comandos de software via registradores.
- **`bloco_operacional.vhd`**: Contém a memória RAM (32 posições) para armazenar o texto e a lógica de decodificação de caracteres para os segmentos do display (função `char_to_seg`).
- **`hardware.vhd`**: Arquivo top-level do projeto FPGA. Ele instancia o sistema Qsys (`myhardware`) e conecta os sinais internos aos pinos físicos da placa (Clock, LEDs, Keys, Switches, Displays HEX).

### Software (C)
O software reside na pasta `software/display/` e é destinado a rodar no processador Nios II.
- **`hello_world_small.c`**: O código principal da aplicação.
    - Inicializa o scroller escrevendo a frase "UFPA 2026 123 456" na memória do periférico.
    - Configura a velocidade inicial.
    - Entra em um loop infinito demonstrando o controle de pausa via software, alternando entre pausado e rodando.

### Ferramentas Utilizadas
- **Intel Quartus Prime**: Para síntese e implementação do hardware FPGA.
- **Platform Designer (Qsys)**: Para integração do sistema Nios II e periféricos.
- **Nios II SBT**: Para desenvolvimento do software em C.

## Funcionalidade
O sistema exibe uma mensagem de texto que se desloca da direita para a esquerda nos displays de 7 segmentos. O usuário pode interagir com o sistema através de:
1. **Botões Físicos (Board)**:
    - Alterar a velocidade do scroll (mais rápido/mais lento).
    - Pausar e retomar a exibição.
    - Ligar/Desligar o display (via Switch).
2. **Software (Nios II)**:
    - Escrever novo texto no display.
    - Alterar a velocidade e o estado de pausa programaticamente.

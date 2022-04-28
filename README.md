# AnalizadorLexico
Analizador Léxico mini-C Implementado utilizando o Gerador Flex

Como executar:
    Requisitos:
        sudo apt install flex
    Passos: (no linux)
        flex lexico.l
        makefile -B all
        ./lexico "nome-do-arquivo.extensao"


-Este analizador léxico reconhece as palavras reservadas int, float, string, if, else, while, void, printf.
-Reconhece  os operadores lógicos (e, ou, maior(igual), menor(igual)) e aritméticos para operações básicas.
-Possui distinção de separadores entre tokens.

-Recebe a entrada por arquivo de texto e retorna tabela de tokens e erros, caso existam, em arquivo de texto.
-Exibe mensagem de aviso caso o número de erros definidos como máximo seja encontrado.


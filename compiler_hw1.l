/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	int number_line = 0;
	int comment_line = 0;
%}

/* Define regular expression label */

letter [a-zA-Z]
digit [0-9]
id {letter}+({letter}|{digit})*
IntNumber {digit}+|([-]{digit}+)
FloatNumber {IntNumber}+[.]{digit}+
StringConstants ["](.)+["]
CComment "/*"((\*+[^/])|([^*]))*"*/" 
CPlusComment \/{2}(.)*

/* Rules section */
%%

"+" 	{ printf("%s \t ADD\n", yytext); }
"-"	{ printf("%s \t SUB\n", yytext); }
"*"	{ printf("%s \t MUL\n", yytext); }
"/"     { printf("%s \t DIV\n", yytext); }
"%"	{ printf("%s \t MOD\n", yytext); }
"++"    { printf("%s \t INC\n", yytext); }
"--"    { printf("%s \t DEC\n", yytext); }
">"	{ printf("%s \t MT\n", yytext); }
"<"	{ printf("%s \t LT\n", yytext); }
">="    { printf("%s \t MTE\n", yytext); }
"<="    { printf("%s \t LTE\n", yytext); }
"=="    { printf("%s \t EQ\n", yytext); }
"!="    { printf("%s \t NE\n", yytext); }
"["	{ printf("%s \t LSB\n", yytext); }
"]"	{ printf("%s \t RSB\n", yytext); }
","	{ printf("%s \t COMMA\n", yytext); }
";"	{ printf("%s \t SEMICOLON\n", yytext); }
"\""	{ printf("%s \t QUOTA\n", yytext); }
"print" { printf("%s \t PRINT\n", yytext); }
"if"    { printf("%s \t IF\n", yytext); }
"else"  { printf("%s \t ELSE\n", yytext); }
"for"   { printf("%s \t FOR\n", yytext); }
"while" { printf("%s \t WHILE\n", yytext); }
"string" { printf("%s \t STRING\n", yytext); }
"int"   { printf("%s \t INT\n" ,yytext); }
"float" { printf("%s \t FLOAT\n", yytext); }
"="	{ printf("%s \t ASGN\n", yytext); }
"+="	{ printf("%s \t ADDASGN\n", yytext); }
"-="	{ printf("%s \t SUBASGN\n", yytext); }
"*="	{ printf("%s \t MULASGN\n", yytext); }
"/="	{ printf("%s \t DIVASGN\n", yytext); }
"%="	{ printf("%s \t MODASGN\n", yytext); }
"&&"	{ printf("%s \t AND\n", yytext); }
"||"	{ printf("%s \t OR\n", yytext); }
"!"	{ printf("%s \t NOT\n", yytext); }
"("	{ printf("%s \t LB\n", yytext); }
")"	{ printf("%s \t RB\n", yytext); }
"{"	{ printf("%s \t LCB\n", yytext); }
"}"	{ printf("%s \t RCB\n", yytext); }
"void"	{ printf("%s \t VOID\n", yytext); }
"bool"	{ printf("%s \t BOOL\n", yytext); }
"true"	{ printf("%s \t TRUE\n", yytext); }
"false"	{ printf("%s \t FALSE\n", yytext); }
"return"	{ printf("%s \t RET\n", yytext); }
"continue"	{ printf("%s \t CONT\n", yytext); }
"break"	{ printf("%s \t BREAK\n", yytext); }
{IntNumber}	{ printf("%s \t I_CONST\n", yytext); }
{FloatNumber}	{ printf("%s \t F_CONST\n", yytext); }
{StringConstants}	{
	printf("\" 	 QUOTA\n");
	int strlength = (int)strlen(yytext);
	printf("%.*s \t STR_CONST\n",strlength-2 ,yytext+1); 
	printf("\" 	 QUOTA\n");
}
{id}	{ printf("%s \t ID\n", yytext); }
{CPlusComment}	{
	int strlength = (int)strlen(yytext);
	int i = 0;
	for(i = 0;i < strlength;i++){
		if(yytext[i] == '\n'){
			number_line++;
			comment_line++;
		}
	} 
	comment_line++;
	printf("%s \t C++ Comment\n", yytext);
}
{CComment}	{ printf("%s \t C Comment\n", yytext);
        int strlength = (int)strlen(yytext);
        int i = 0;
        for(i = 0;i < strlength;i++){
                if(yytext[i] == '\n'){
                        number_line++;
			comment_line++;
                }
        }
	comment_line++; 
}
"\n"	{number_line = number_line + 1;}
" "	{}

%%

/*	C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc,char *argv[])
{
	yyin = fopen(argv[1],"r");
	yylex();
	printf("\nParse over, the line number is %d.\n\n",number_line);
	printf("comment: %d lines\n\n",comment_line);

	return 0;
}

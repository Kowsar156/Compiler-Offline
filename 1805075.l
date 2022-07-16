%option noyywrap
%x STRINGSTATE
%x SINGLECOMMENTSTATE
%x MULTILINECOMMENTSTATE
%{
#include<iostream>
#include<cstdlib>
#include<cstring>
#include<string>
#include"1805075.cpp"
#include "y.tab.h"

using namespace std;
extern YYSTYPE yylval;
extern SymbolTable *table;
void yyerror(char *);
//Scopetable *scope = new Scopetable(NULL, 7);
//SymbolTable *table = new SymbolTable(scope, 7);

int line_count=1;
char current_string[100000000];
int string_index = 0;
int error_count = 0;

//NUMERROR [0-9]+[^0-9\]]+ -> eita ekta lex regex chilo, jhamela kortesilo hudai
//{NUMERROR} {
			//fprintf(logout,"Invalid suffix on numeric constant at Line no %d\n",line_count);
			//error_count++; 
			//cout << "num error found" << endl;
//}

//FILE *logout;
//FILE *tokenout;

%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n
FLOATING ([0-9]*\.[0-9]+)|([0-9]*\.[0-9]+E[1-9][0-9]*)|([0-9]*\.[0-9]+E-[1-9][0-9]*)|([0-9]+E[1-9][0-9]*)|([0-9]+E-[1-9][0-9]*)
CHARACTER ('[a-zA-Z1-9]')|('\\')|('\\\\')
IDENTIFIER [a-zA-Z_]+[a-zA-Z0-9_]*
SPECCHARACTER '\\[afrbv0nt]*'
STRINGSTART \"
SINGLECOMMENTSTART \/\/
MULTILINECOMMENTSTART \/\*
DPERROR [0-9]*\.[0-9]*\.[0-9.]*
ILNERROR ([0-9]*\.[0-9]+E[\.]+[1-9][0-9]*)|([0-9]*\.[0-9]+E[1-9][0-9]*[\.]+[0-9\.]*)|([0-9]*\.[0-9]+E-[1-9][0-9]*[\.]+[0-9\.]*)|([0-9]*\.[0-9]+E[\.]+-[1-9][0-9]*)|([0-9]*\.[0-9]+E-[\.]+[1-9][\.0-9]*)|([0-9]*\.[0-9]+E-[1-9][0-9]*[\.]+[0-9\.]*)|([0-9]+E[\.]+[1-9][0-9]*)|([0-9]+E[1-9][0-9]*[\.]+[0-9\.]*)|([0-9]+E[\.]+-[1-9][\.0-9]*)|([0-9]+E-[\.]+[1-9][\.0-9]*)|([0-9]+E-[1-9][0-9]*[\.]+[0-9\.]*)
IDERROR [0-9@#$%\^&*]+[a-zA-Z_]+[a-zA-Z0-9_]*

MLCERROR ('[a-zA-Z1-9][a-zA-Z1-9]+')|('\\')|('\\\\(\\)+')
UFCERROR ('[a-zA-Z1-9])|('\\)|('\\\\)
ECERROR ''

%%

{WHITESPACE} {}

"printf" {
			Symbolinfo *s= new  Symbolinfo(yytext, "PRINT");
			yylval.symbol = s;
			return PRINTLN;
	}

"if"	{
			//fprintf(tokenout,"<IF>");
			//fprintf(logout,"Line no %d: TOKEN <IF> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "IF");
			yylval.symbol = s;
			return IF;
		}
		
"else"	{
			//fprintf(tokenout,"<ELSE>");
			//fprintf(logout,"Line no %d: TOKEN <ELSE> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "ELSE");
			yylval.symbol = s;
			return ELSE;
		}

"for"	{
			//fprintf(tokenout,"<FOR>");
			//fprintf(logout,"Line no %d: TOKEN <FOR> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "FOR");
			yylval.symbol = s;
			return FOR;
		}


"do"	{
			//fprintf(tokenout,"<DO>");
			//fprintf(logout,"Line no %d: TOKEN <DO> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "DO");
			yylval.symbol = s;
			return DO;
		}

"int"	{
			//fprintf(tokenout,"<INT>");
			//fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "INT");
			yylval.symbol = s;
			return INTEGER;
		}

"float"	{
			//fprintf(tokenout,"<FLOAT>");
			//fprintf(logout,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "FLOAT");
			yylval.symbol = s;
			return FLOAT;
		}

"void"	{
			//fprintf(tokenout,"<VOID>");
			//fprintf(logout,"Line no %d: TOKEN <VOID> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "VOID");
			yylval.symbol = s;
			return VOID;
		}

"switch"	{
			//fprintf(tokenout,"<SWITCH>");
			//fprintf(logout,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n",line_count,yytext);
		}

"default"	{
			//fprintf(tokenout,"<DEFAULT>");
			//fprintf(logout,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n",line_count,yytext);
		}


"while"	{
			//fprintf(tokenout,"<WHILE>");
			//fprintf(logout,"Line no %d: TOKEN <WHILE> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "WHILE");
			yylval.symbol = s;
			return WHILE;
		}

"break"	{
			//fprintf(tokenout,"<BREAK>");
			//fprintf(logout,"Line no %d: TOKEN <BREAK> Lexeme %s found\n",line_count,yytext);
		}

"char"	{
			//fprintf(tokenout,"<CHAR>");
			//fprintf(logout,"Line no %d: TOKEN <CHAR> Lexeme %s found\n",line_count,yytext);
		}

"double"	{
			//fprintf(tokenout,"<DOUBLE>");
			//fprintf(logout,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n",line_count,yytext);
		}

"return"	{
			//fprintf(tokenout,"<RETURN>");
			//fprintf(logout,"Line no %d: TOKEN <RETURN> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "RETURN");
			yylval.symbol = s;
			return RETURN;
		}

"case"	{
			//fprintf(tokenout,"<CASE>");
			//fprintf(logout,"Line no %d: TOKEN <CASE> Lexeme %s found\n",line_count,yytext);
		}

"continue"	{
			//fprintf(tokenout,"<CONTINUE>");
			//fprintf(logout,"Line no %d: TOKEN <CONTINUE> Lexeme %s found\n",line_count,yytext);
		}
		

"+" |
"-"	        {
			//fprintf(tokenout,"<ADDOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n",line_count,yytext);
			//insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
			Symbolinfo *s= new  Symbolinfo(yytext, "ADDOP");
			yylval.symbol = s;
			return ADDOP;
		}
		
		
		
		
		

"*" |
"/" |
"%"		{
			//fprintf(tokenout,"<MULOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "MULOP");
			yylval.symbol = s;
			return MULOP;
		}
		
"++"		{
			//fprintf(tokenout,"<INCOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <INCOP> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "INCOP");
			yylval.symbol = s;
			return INCOP;
		}
		
"--"            {
			Symbolinfo *s= new  Symbolinfo(yytext, "DECOP");
			yylval.symbol = s;
			return DECOP;
		}
		
"<" | 
"<=" |
">" |
">=" |
"==" |
"!="		{
			//fprintf(tokenout,"<RELOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "RELOP");
			yylval.symbol = s;
			return RELOP;
		}
		
		
"="		{
			//fprintf(tokenout,"<ASSIGNOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "ASSIGNOP");
			yylval.symbol = s;
			return ASSIGNOP;
		}
		
		
"&&" |
"||"		{
			//fprintf(tokenout,"<LOGICOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "LOGICOP");
			yylval.symbol = s;
			return LOGICOP;
		}
		
		
"!"		{
			//fprintf(tokenout,"<NOT,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <NOT> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "NOT");
			yylval.symbol = s;
			return NOT;
		}
		
		
"("		{
			//fprintf(tokenout,"<LPAREN,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "LPAREN");
			yylval.symbol = s;
			return LPAREN;
		}
		
")"		{
			//fprintf(tokenout,"<RPAREN,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "RPAREN");
			yylval.symbol = s;
			return RPAREN;
		}
		
"["		{
			//fprintf(tokenout,"<LTHIRD,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <LTHIRD> Lexeme %s found\n",line_count,yytext);
			//cout<< "T Bracket" << endl;
			Symbolinfo *s= new  Symbolinfo(yytext, "LTHIRD");
			yylval.symbol = s;
			return LTHIRD;
		}
		
"]"		{
			//fprintf(tokenout,"<RTHIRD,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <RTHIRD> Lexeme %s found\n",line_count,yytext);
			//cout << "T Bracket end" << endl;
			Symbolinfo *s= new  Symbolinfo(yytext, "RTHIRD");
			yylval.symbol = s;
			return RTHIRD;
		}
		
","		{
			//fprintf(tokenout,"<COMMA,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <COMMA> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "COMMA");
			yylval.symbol = s;
			return COMMA;
		}
		
";"		{
			//fprintf(tokenout,"<SEMICOLON,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *s= new  Symbolinfo(yytext, "SEMICOLON");
			yylval.symbol = s;
			return SEMICOLON;
		}
		
"{"		{
			//fprintf(tokenout,"<LCURL,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <LCURL> Lexeme %s found\n",line_count,yytext);
			//table->enterScope();
			Symbolinfo *s= new  Symbolinfo(yytext, "LCURL");
			yylval.symbol = s;
			return LCURL;
		}
		
"}"		{
			//fprintf(tokenout,"<RCURL,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <RCURL> Lexeme %s found\n",line_count,yytext);
			//table->exitScope();
			Symbolinfo *s= new  Symbolinfo(yytext, "RCURL");
			yylval.symbol = s;
			return RCURL;
		}
		
{ECERROR} {
			//fprintf(logout,"Empty character constant error at Line no %d\n",line_count);
			error_count++;
}

{UFCERROR} {
			//fprintf(logout,"Unfinished character error at Line no %d\n",line_count);
			error_count++;
}

{STRINGSTART} {
			BEGIN STRINGSTATE;
			//cout << "STRING STARTED" << endl;
	}
	
{SINGLECOMMENTSTART} {
			BEGIN SINGLECOMMENTSTATE;
			//fprintf(logout,"Comment at Line no %d\n",line_count);
}

{MULTILINECOMMENTSTART} {
		BEGIN MULTILINECOMMENTSTATE;
		//fprintf(logout,"Comment started at Line no %d\n",line_count);
}


<MULTILINECOMMENTSTATE>\n {
		line_count++;
}

<MULTILINECOMMENTSTATE>\*\/ {
		BEGIN INITIAL;
		//fprintf(logout,"Comment ended at Line no %d\n",line_count);
}

<MULTILINECOMMENTSTATE><<EOF>> {
		//fprintf(logout,"Unfinished comment at Line no %d\n",line_count);
		return 0;
}



<SINGLECOMMENTSTATE>\\\n {
		line_count++;
}


<SINGLECOMMENTSTATE>\n {
		BEGIN INITIAL;
		line_count++;
}

<STRINGSTATE>\n {
		BEGIN INITIAL;
		//fprintf(logout,"Unfinished string at Line no %d\n",line_count);
		error_count++;
}

<STRINGSTATE>\" {

		//cout << "String is ending" << endl;

		cout<< current_string<<endl;

		current_string[string_index] = '\0';
		char *text = current_string;
		//fprintf(tokenout,"<STRING,%s>",text);
		//fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n",line_count,text);
			
		Symbolinfo *symbol = new Symbolinfo(text, "STRING");
			
		table->insert(symbol);
		//table->printAllScope();
		
		string_index = 0;
		
		BEGIN INITIAL;
	}
	
<STRINGSTATE>\\\n {
		current_string[string_index] = 'a' - 87;
		string_index++;
		line_count++;
	}
	
<STRINGSTATE>\\[afrbv0nt] {
		char *text = yytext;
		text++;
		if(text[0] == 'n'){
			current_string[string_index] = 'a' - 87;
		}
		else if(text[0] == 'a'){
			current_string[string_index] = 'a' - 90;
		}
		else if(text[0] == 't'){
			current_string[string_index] = 'a' - 88;
		}
		else if(text[0] == '0'){
			current_string[string_index] = 'a' - 97;
		}
		else if(text[0] == 'f'){
			current_string[string_index] = 'a' - 85;
		}
		else if(text[0] == 'r'){
			current_string[string_index] = 'a' - 84;
		}
		else if(text[0] == 'b'){
			current_string[string_index] = 'a' - 89;
		}
		else if(text[0] == 'v'){
			current_string[string_index] = 'a' - 86;
		}
		string_index++;
	}
	
<STRINGSTATE>. {
		//cout << "Letter found" << endl;
		char *text = yytext;
		//cout << text[0] << "The letter" << endl;
		//cout << "The index is " << string_index << endl;
		current_string[string_index] = text[0];
		string_index++;
		//cout << "Letter inserted" << endl;
	}



{NEWLINE} {line_count++;}

{CHARACTER} {
			//char *text = yytext;
			//text++;
			//text[strlen(text)-1] = '\0';
			//fprintf(tokenout,"<CONST_CHAR,%s>",text);
			//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count,text);
			
			//Symbolinfo *symbol = new Symbolinfo(text, "CONST_CHAR");
			
		        //table->insert(symbol);
		        //table->printAllScope();
	}
	
{MLCERROR} {
			//fprintf(logout,"Multi character constant error at Line no %d\n",line_count);
			error_count++;
}
	
{SPECCHARACTER} {
			
			char *text = yytext;
			text++;
			text[strlen(text)-1] = '\0';
			Symbolinfo *symbol;
			if(text[1] == 'n'){
				text[0] = 'a' - 87;
				text[1] = '\0';
				//fprintf(tokenout,"<CONST_CHAR,%s>", text);
				//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count, text);
				symbol = new Symbolinfo(text, "CONST_CHAR");
			}
			else if(text[1] == 'a'){
				text[0] = 'a' - 90;
				text[1] = '\0';
				//fprintf(tokenout,"<CONST_CHAR,%s>", text);
				//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count, text);
				symbol = new Symbolinfo(text, "CONST_CHAR");
			}
			else if(text[1] == 't'){
				text[0] = 'a' - 88;
				text[1] = '\0';
				//fprintf(tokenout,"<CONST_CHAR,%s>", text);
				//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count, text);
				symbol = new Symbolinfo(text, "CONST_CHAR");
			}
			else if(text[1] == '0'){
				text[0] = 'a' - 97;
				text[1] = '\0';
				//fprintf(tokenout,"<CONST_CHAR,%s>", text);
				//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count, text);
				symbol = new Symbolinfo(text, "CONST_CHAR");
			}
			else if(text[1] == 'f'){
				text[0] = 'a' - 85;
				text[1] = '\0';
				//fprintf(tokenout,"<CONST_CHAR,%s>", text);
				//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count, text);
				symbol = new Symbolinfo(text, "CONST_CHAR");
			}
			else if(text[1] == 'r'){
				text[0] = 'a' - 84;
				text[1] = '\0';
				//fprintf(tokenout,"<CONST_CHAR,%s>", text);
				//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count, text);
				symbol = new Symbolinfo(text, "CONST_CHAR");
			}
			else if(text[1] == 'b'){
				text[0] = 'a' - 89;
				text[1] = '\0';
				//fprintf(tokenout,"<CONST_CHAR,%s>", text);
				//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count, text);
				symbol = new Symbolinfo(text, "CONST_CHAR");
			}
			else if(text[1] == 'v'){
				text[0] = 'a' - 86;
				text[1] = '\0';
				//fprintf(tokenout,"<CONST_CHAR,%s>", text);
				//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count, text);
				symbol = new Symbolinfo(text, "CONST_CHAR");
			}
		        table->insert(symbol);
		       // table->printAllScope();
	}
	
	
	


{DIGIT}+ 	{
				//fprintf(tokenout,"<CONST_INT,%s>",yytext);
				//fprintf(logout,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n",line_count,yytext);
				//cout << "sending const_int " << yytext << endl;
				
				Symbolinfo *symbol = new Symbolinfo(yytext, "CONST_INT");
				yylval.symbol = symbol;
		                return CONST_INT;
			}



{FLOATING} {
			
			//fprintf(tokenout,"<CONST_FLOAT,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
			
			Symbolinfo *symbol = new Symbolinfo(yytext, "CONST_FLOAT");
		        yylval.symbol = symbol;
		        return CONST_FLOAT;
	}
	
{DPERROR} {
		//fprintf(logout,"Too many decimal points at Line no %d\n",line_count);
		error_count++;
}

{ILNERROR} {
		//fprintf(logout,"Ill formed number at Line no %d\n",line_count);
		error_count++;
}

		
		
{IDENTIFIER} {
			//fprintf(tokenout,"<ID,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <ID> Lexeme %s found\n",line_count,yytext);
			Symbolinfo *symbol = new Symbolinfo(yytext, "ID");
			yylval.symbol = symbol;
		        //table->insert(symbol);
		        //table->printAllScope();
		        return ID;
	}
	
{IDERROR} {
		//fprintf(logout,"Invalid prefix on identifier at Line no %d\n",line_count);
		error_count++;
}





		
. {
			//fprintf(logout,"Unrecognized character at Line no %d\n",line_count);
			error_count++;

}


<<EOF>> {		//fprintf(logout, "Total Line Number: %d and total number of errors: %d\n",line_count-1,error_count); 
			return 0;
	}			

%%

/*int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= fopen("log.txt","w");
	tokenout= fopen("token.txt","w");
	

	yyin= fin;
	yylex();
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}*/

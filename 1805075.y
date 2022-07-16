%{
#include<iostream>
#include<fstream>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<string>
#include<sstream>
#include<iterator>
#include<list>
#include<vector>
#include<utility>
#include"1805075.cpp"
//#include "symbol.h"
//#define YYSTYPE Symbolinfo*

using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int line_count;

Scopetable *scope = new Scopetable(NULL, 7);
SymbolTable *table = new SymbolTable(scope, 7);
ofstream logout;
ofstream errorout;
list<Symbolinfo*> symbolList;
vector<pair<Symbolinfo*, Symbolinfo*>> func_param; //type specifier first
vector<pair<Symbolinfo*, Symbolinfo*>> params; 
vector<Symbolinfo*> args;
string returntype;




//vector<Symbolinfo*> called_args;

//%left 
//%right

//%nonassoc - egula token and type er pore chilo



void yyerror(char *s)
{
	//write your code
}


%}

%token <symbol> ID LPAREN RPAREN SEMICOLON COMMA LCURL RCURL INTEGER FLOAT VOID LTHIRD RTHIRD CONST_INT CONST_FLOAT FOR IF ELSE  
%token <symbol> DO WHILE PRINTLN RETURN ASSIGNOP LOGICOP RELOP ADDOP MULOP NOT INCOP DECOP
%type <symbol> start program unit var_declaration variable type_specifier declaration_list expression_statement func_declaration parameter_list func_definition
%type <symbol> compound_statement statements unary_expression factor statement arguments expression logic_expression simple_expression rel_expression term argument_list

%nonassoc ELSE_FIRST
%nonassoc ELSE

%union
{
	int intvalue;
	Symbolinfo* symbol;
}


%%

start : program
	{
		$$ = $1;
		logout << "Line " << line_count << ":  program : unit" << endl;
		logout << $$->getName() << endl;
	}
	;

program : program unit {
				$$ = new Symbolinfo($1->getName() + "\n" + $2->getName(), "PROGRAM");
				logout << "Line " << line_count << ":  program : program unit" << endl;
				logout << $$->getName() << endl;
		       }
	| unit {
			$$ = $1;
			logout << "Line " << line_count << ":  program : unit" << endl;
			logout << $$->getName() << endl;
	       }
	;
	
unit : var_declaration {
		 		$$ = $1;
		 		logout << "Line " << line_count << ": unit : var_declaration" << endl;
				logout << $$->getName() << endl;
		       }
     | func_declaration {
		 		$$ = $1;
		 		logout << "Line " << line_count << ": unit : func_declaration" << endl;
				logout << $$->getName() << endl;
		       }
     | func_definition {
		 		$$ = $1;
		 		logout << "Line " << line_count << ": unit : func_definition" << endl;
				logout << $$->getName() << endl;
		       }
     ;
     
func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON {
										bool a = table->insert($2);
										if(a == false){
											errorout << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl;
										}
										else{
											table->lookupSymbol($2->getName())->setDataType($1->getName());
											table->lookupSymbol($2->getName())->setIfFunc(true);
											func_param.clear();
											table->lookupSymbol($2->getName())->setParam(func_param);
											
											$$ = new Symbolinfo($1->getName() + " " + $2->getName() + $3->getName() + $4->getName() + $5->getName(), "FUNCTION");
											logout << "Line " << line_count << ": func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON" << endl;
											logout << $$->getName() << endl;
										}
									     }
		| type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
										bool a = table->insert($2);
										if(a == false){
											errorout << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl;
										}
										else{
											table->lookupSymbol($2->getName())->setDataType($1->getName());
											table->lookupSymbol($2->getName())->setIfFunc(true);
											
											table->lookupSymbol($2->getName())->setParam(func_param);
											func_param.clear();
											$$ = new Symbolinfo($1->getName() + " " + $2->getName() + $3->getName() + $4->getName() + $5->getName() + $6->getName(), "FUNCTION");
											logout << "Line " << line_count << ": func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON" << endl;
											logout << $$->getName() << endl;
										}
									     }
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN {
									bool a = table->insert($2);
									//table->printAllScope("log.txt");
									if(a == false){
										if(table->lookupSymbol($2->getName())->getIfDefined() == true){
											errorout << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl;
											
										}
										else if(table->lookupSymbol($2->getName())->getIfFunc() == false){
											errorout << "Error at line " << line_count << ": " << $2->getName() << " not a function" << endl;
											//table->enterScope();
										}
										else if(table->lookupSymbol($2->getName())->getDataType() != $1->getName()){
											errorout << "Error at line " << line_count << ": Return type mismatch with function declaration in function " << $2->getName() << endl;
											//table->enterScope();
										}
										else{
											//table->enterScope();
											table->lookupSymbol($2->getName())->setDataType($1->getName());
											table->lookupSymbol($2->getName())->setIfFunc(true);
											table->lookupSymbol($2->getName())->setParam(func_param);
											
											returntype = $1->getName();
										}
									}
									else{
										//table->enterScope();
										table->lookupSymbol($2->getName())->setDataType($1->getName());
										table->lookupSymbol($2->getName())->setIfFunc(true);
										table->lookupSymbol($2->getName())->setParam(func_param);
										//cout << "all good" << endl;
										
										returntype = $1->getName();
									}
									//func_param.clear();
									
								 }
		 compound_statement {
		 			$$ = new Symbolinfo($1->getName() + " " + $2->getName() + $3->getName() + $4->getName() + $5->getName() + $7->getName(), "FUNCTION");
		 			logout << "Line " << line_count << ": func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement" << endl;
					logout << $$->getName() << endl;
		 		    }
		| type_specifier ID LPAREN RPAREN {
							bool a = table->insert($2);
							//table->printAllScope("log.txt");
							if(a == false){
								if(table->lookupSymbol($2->getName())->getIfDefined() == true){
									errorout << "Error at line " << line_count << ": Multiple declaration of " << $2->getName() << endl;
									//table->enterScope();
								}
								else if(table->lookupSymbol($2->getName())->getIfFunc() == false){
									errorout << "Error at line " << line_count << ": " << $2->getName() << " not a function" << endl;
									//table->enterScope();
								}
								else if(table->lookupSymbol($2->getName())->getDataType() != $1->getName()){
											errorout << "Error at line " << line_count << ": Return type mismatch with function declaration in function " << $2->getName() << endl;
											//table->enterScope();
										}
								else{
									//table->enterScope();
									table->lookupSymbol($2->getName())->setDataType($1->getName());
									table->lookupSymbol($2->getName())->setIfFunc(true);
									table->lookupSymbol($2->getName())->setParam(func_param);
									
									returntype = $1->getName();
								}
							}
							else{
								//table->enterScope();
								table->lookupSymbol($2->getName())->setDataType($1->getName());
								table->lookupSymbol($2->getName())->setIfFunc(true);
								table->lookupSymbol($2->getName())->setParam(func_param);
								
								returntype = $1->getName();
							}
							//func_param.clear();
							
						  }
		 compound_statement {
		 			$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() + $4->getName() + $6->getName(), "FUNCTION");
		 			logout << "Line " << line_count << ": func_definition : type_specifier ID LPAREN RPAREN compound_statement" << endl;
					logout << $$->getName() << endl;
		 		    }
 		;				


parameter_list  : parameter_list COMMA type_specifier ID {
								
								if($3->getType() == "VOID"){
									errorout << "Error at line " << line_count << ": Parameter type cannot be void" << endl;
								}
								else{
									$4->setDataType($3->getName());
									func_param.push_back(make_pair($3, $4));
									$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() + " " + $4->getName(), "ID");
						   			logout << "Line " << line_count << ": parameter_list : parameter_list COMMA type_specifier ID" << endl;
									logout << $$->getName() << endl;
									//errorout << "ID " << func_param.at(1).second->getName() << " data type: " << func_param.at(1).second->getDataType() << "..." << endl;
								}
							 }
		| parameter_list COMMA type_specifier {
								
								if($3->getType() == "VOID"){
									errorout << "Error at line " << line_count << ": Parameter type cannot be void" << endl;
								}
								else{
									Symbolinfo *s = new Symbolinfo("", "ID");
									func_param.push_back(make_pair($3, s));
									$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName(), "ID");
						   			logout << "Line " << line_count << ": parameter_list : parameter_list COMMA type_specifier" << endl;
									logout << $$->getName() << endl;
								}
							 }
 		| type_specifier ID {
					
					if($1->getType() == "VOID"){
						errorout << "Error at line " << line_count << ": Parameter type cannot be void" << endl;
					}
					else{
						$2->setDataType($1->getName());
						func_param.clear();
						func_param.push_back(make_pair($1, $2));
						$$ = new Symbolinfo($1->getName() + " " + $2->getName(), $2->getType());
			   			logout << "Line " << line_count << ": parameter_list : type_specifier ID" << endl;
						logout << $$->getName() << endl;
						//errorout << "ID " << func_param.at(0).second->getName() << " data type: " << func_param.at(0).second->getDataType() << "..." << endl;
					}
				 }
		| type_specifier {
					
					if($1->getType() == "VOID"){
						errorout << "Error at line " << line_count << ": Parameter type cannot be void" << endl;
					}
					else{
						Symbolinfo *s = new Symbolinfo("", "ID");
						func_param.clear();
						func_param.push_back(make_pair($1, s));
						$$ = new Symbolinfo($1->getName(), "ID");
			   			logout << "Line " << line_count << ": parameter_list : type_specifier" << endl;
						logout << $$->getName() << endl;
					}
				 }
 		;

 		
compound_statement : LCURL {
				table->enterScope();
				if(!func_param.empty()){
					bool a;
					for(int i = 0 ; i < func_param.size() ; i++){
						a = table->insert(func_param.at(i).second);
						if(a == false){
							errorout << "Error at line " << line_count << ": Multiple declaration of " << func_param.at(i).second->getName() << " in parameter" << endl;
						}
					}
					func_param.clear();
				}
		   	   }
		    statements RCURL {
						$$ = new Symbolinfo($1->getName() + $3->getName() + $4->getName(), $3->getType());
		   				logout << "Line " << line_count << ": compound_statement : LCURL statements RCURL" << endl;
						logout << $$->getName() << endl;
						logout << "\n\n\n" << endl;
						table->printAllScope("temp.txt");
						ifstream reader("temp.txt");
						string line;
						while(getline(reader, line)){
							logout << line << endl;
						}
						reader.close();
						logout << "\n\n\n" << endl;
						table->exitScope();
					    }
 		    | LCURL {
				table->enterScope();
				if(!func_param.empty()){
					bool a;
					for(int i = 0 ; i < func_param.size() ; i++){
						a = table->insert(func_param.at(i).second);
						if(a == false){
							errorout << "Error at line " << line_count << ": Multiple declaration of " << func_param.at(i).second->getName() << " in parameter" << endl;
						}
					}
					func_param.clear();
				}
		   	   }
		      RCURL {
 		    			$$ = new Symbolinfo($1->getName() + $3->getName(), "LCRC");
 		    			logout << "Line " << line_count << ": compound_statement : LCURL RCURL" << endl;
					logout << $$->getName() << endl;
					logout << "\n\n\n" << endl;
					table->printAllScope("temp.txt");
					ifstream reader("temp.txt");
					string line;
					while(getline(reader, line)){
						logout << line << endl;
					}
					reader.close();
					logout << "\n\n\n" << endl;
					table->exitScope();
 		    		  }
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON { 
								if($1->getType() == "VOID"){
									errorout << "Error at line " << line_count << ": Variable type cannot be void" << endl;
								}
								else{
									$$ = new Symbolinfo($1->getName() + " " + $2->getName() + ";", $1->getType());
									$$->setDataType($1->getName());
									logout << "Line " << line_count << ": var_declaration : type_specifier declaration_list SEMICOLON" << endl;
									logout << $$->getName() << endl;
									 while(!symbolList.empty()){
									 	Symbolinfo *s = symbolList.front();
									 	symbolList.pop_front();
									 	table->lookupSymbol(s->getName())->setDataType($1->getName());
									 }
								}
								 }
 		 ;
 		 
type_specifier	: INTEGER {
				$$ = $1;
				logout << "Line " << line_count << ": type_specifier : INT" << endl;
				logout << $1->getName() << endl;
				}
 		| FLOAT {
 				$$ = $1;
				logout << "Line " << line_count << ": type_specifier : FLOAT" << endl;
				logout << $1->getName() << endl;
 			}
 		| VOID {
 				$$ = $1;
				logout << "Line " << line_count << ": type_specifier : VOID" << endl;
				logout << $1->getName() << endl;
 			}
 		;
 		
declaration_list : declaration_list COMMA ID { 
						bool a = table->insert($3);
						if(a == false){
							errorout << "Error at line " << line_count << ": Multiple declaration of " << $3->getName() << endl;
						}
						else{
							symbolList.push_back($3);
							$$ = new Symbolinfo($1->getName() + "," + $3->getName(), "IDS");
							logout << "Line " << line_count << ": declaration_list : declaration_list COMMA ID" << endl;
							logout << $1->getName() << "," << $3->getName() <<endl;
						}
						
						 }
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD { 
										$3->setIfArr(true);
										stringstream ss;
										int num;
										string str = $5->getName();
										ss << str;
										ss >> num;
										$3->setArrSize(num);
										bool a = table->insert($3);
										if(a == false){
											errorout << "Error at line " << line_count << ": Multiple declaration of " << $3->getName() << endl;
										}
										else{
											symbolList.push_back($3);
											$$ = new Symbolinfo($1->getName() + "," + $3->getName() + "[" + $5->getName() + "]", "IDS");
											logout << "Line " << line_count << ": declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD" << endl;
											logout << $1->getName() << "," << $3->getName() << "[" << $5->getName() << "]" << endl;
										}
						
						 			}
 		  | ID { 
 		  	
 		  	bool a = table->insert($1);
 		  	if(a == false){
 		  		errorout << "Error at line " << line_count << ": Multiple declaration of " << $1->getName() << endl;
 		  	}
 		  	else{
 		  		symbolList.push_back($1);
 		  		$$ = $1;
 		  		logout << "Line " << line_count << ": declaration_list : ID" << endl;
 		  		logout << $1->getName() << endl;
 		  	}
 		  	 }
 		  | ID LTHIRD CONST_INT RTHIRD	{
 		  					$1->setIfArr(true);
 		  					stringstream ss;
							int num;
							string str = $3->getName();
							ss << str;
							ss >> num;
				 		  	$1->setArrSize(num);
 		  					bool a = table->insert($1);
				 		  	if(a == false){
				 		  		errorout << "Error at line " << line_count << ": Multiple declaration of " << $1->getName() << endl;
				 		  	}
				 		  	else{
				 		  		symbolList.push_back($1);
				 		  		$$ = new Symbolinfo($1->getName() + "[" + $3->getName() + "]" , "ID");
				 		  		logout << "Line " << line_count << ": declaration_list : ID LTHIRD CONST_INT RTHIRD" << endl;
				 		  		logout << $1->getName() << "[" << $3->getName() << "]" << endl;
				 		  	} 
 		  				}
 		  ;
 		  
statements : statement {
	  			$$ = $1;
				logout << "Line " << line_count << ": statements : statement" << endl;
				logout << $$->getName() << endl;
	  		}
	   | statements statement {
	   				$$ = new Symbolinfo($1->getName() + "\n" + $2->getName() , $1->getType());
	   				logout << "Line " << line_count << ": statements : statements statement" << endl;
					logout << $$->getName() << endl;
	   			  }
	   ;
	   
statement : var_declaration {
	  			$$ = $1;
				logout << "Line " << line_count << ": statement : var_declaration" << endl;
				logout << $$->getName() << endl;
	  		    }
	  | expression_statement {
	  				$$ = $1;
					logout << "Line " << line_count << ": statement : expression_statement" << endl;
					logout << $$->getName() << endl;
	  			 }
	  | compound_statement {
		  			$$ = $1;
					logout << "Line " << line_count << ": statement : compound_statement" << endl;
					logout << $$->getName() << endl;
	  			}
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement {
	  				
	  				$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() + $4->getName() + $5->getName() + $6->getName() + $7->getName(), "forloop");
	  				logout << "Line " << line_count << ": statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement" << endl;
					logout << $$->getName() << endl;
	  			 }
	  | IF LPAREN expression RPAREN statement %prec ELSE_FIRST{
	  				$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() + $4->getName() + $5->getName(), "ifstatement");
	  				logout << "Line " << line_count << ": statement : IF LPAREN expression RPAREN statement" << endl;
					logout << $$->getName() << endl;
	  			 }
	  | IF LPAREN expression RPAREN statement ELSE statement {
	  				$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() + $4->getName() + $5->getName() + $6->getName() + $7->getName(), "ifelsestatement");
	  				logout << "Line " << line_count << ": statement : IF LPAREN expression RPAREN statement ELSE statement" << endl;
					logout << $$->getName() << endl;
	  			 }
	  | WHILE LPAREN expression RPAREN statement {
	  				$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() + $4->getName() + $5->getName(), "whileloop");
	  				logout << "Line " << line_count << ": statement : WHILE LPAREN expression RPAREN statement" << endl;
					logout << $$->getName() << endl;
	  			 }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON {
	  				$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() + $4->getName() + $5->getName(), "print");
	  				logout << "Line " << line_count << ": statement : PRINTLN LPAREN ID RPAREN SEMICOLON" << endl;
					logout << $$->getName() << endl;
	  			 }
	  | RETURN expression SEMICOLON {
	  				if(returntype == $2->getDataType()){
	  					$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName(), "return");
		  				logout << "Line " << line_count << ": statement : RETURN expression SEMICOLON" << endl;
						logout << $$->getName() << endl;
	  				}
	  				else{
	  					errorout << "Error at line " << line_count << ": Return type mismatch" << endl;
	  					//errorout << "			function return type: " << returntype << "	expression return type: " << $2->getDataType() << "..." << endl;
	  				}
	  			 }
	  ;
	  
expression_statement 	: SEMICOLON {
					$$ = $1;
					logout << "Line " << line_count << ": expression_statement : SEMICOLON" << endl;
					logout << $$->getName() << endl;
				    }		
			| expression SEMICOLON {
							$$ = new Symbolinfo($1->getName() + $2->getName(), $1->getType());
							logout << "Line " << line_count << ": expression_statement : expression SEMICOLON" << endl;
							logout << $$->getName() << endl;
						}
			;
	  
variable : ID 	{
			if(table->lookupSymbol($1->getName()) != NULL){
				$$ = table->lookupSymbol($1->getName());
				logout << "Line " << line_count << ": variable : ID" << endl;
				logout << $1->getName() << endl;
			}
			else{
				errorout << "Error at line " << line_count << ": Undeclared variable " << $1->getName() << endl;
			}
		}	
	 | ID LTHIRD expression RTHIRD {
						if(table->lookupSymbol($1->getName()) == NULL){
							errorout << "Error at line " << line_count << ": Undeclared variable " << $1->getName() << endl;
						}
	 					else if(!table->lookupSymbol($1->getName())->getIfArr()){
	 						errorout << "Error at line " << line_count << ": " << $1->getName() << " not an array" << endl;
	 					}
	 					else if($3->getType() != "CONST_INT"){
	 						errorout << "Error at line " << line_count << ": Expression inside third brackets not an integer" << endl;
	 					}
	 					else{
	 						$$ = new Symbolinfo($1->getName()+"["+$3->getName()+"]", $1->getType());
	 						$$->setIfArr(true);
	 						$$->setDataType(table->lookupSymbol($1->getName())->getDataType());
							logout << "Line " << line_count << ": variable : ID LTHIRD expression RTHIRD" << endl;
							logout << $1->getName() << "[" << $3->getName() << "]" << endl;
	 					}
	 				}
	 ;
	 
 expression : logic_expression {
					$$ = $1;
					logout << "Line " << line_count << ": expression : logic_expression" << endl;
					logout << $1->getName() << endl;
					
				}	
	   | variable ASSIGNOP logic_expression {
	   						if($1->getDataType() != $3->getDataType()){
	   							errorout << "Error at line " << line_count << ": Type mismatch" << endl;
	   							//errorout << "variable " << $1->getName() << " data type: " << $1->getDataType() << " logic_exp " << $3->getName() << " data type: " << $3->getDataType() << "..." << endl;
	   						}
	   						else{
	   							$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() , $1->getType());
								$$->setDataType($1->getDataType());
								logout << "Line " << line_count << ": expression : variable ASSIGNOP logic_expression" << endl;
								logout << $$->getName() << endl;
	   						}
	   					}	
	   ;
			
logic_expression : rel_expression {
					$$ = $1;
					logout << "Line " << line_count << ": logic_expression : rel_expression" << endl;
					logout << $1->getName() << endl;
					
				  }	
		 | rel_expression LOGICOP rel_expression {
		 						$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() , $1->getType());
								$$->setDataType("int");
								logout << "Line " << line_count << ": logic_expression : rel_expression LOGICOP rel_expression" << endl;
								logout << $$->getName() << endl;
		 					}
		 ;
			
rel_expression	: simple_expression {
					$$ = $1;
					logout << "Line " << line_count << ": rel_expression  : simple_expression" << endl;
					logout << $1->getName() << endl;
					
				    }
		| simple_expression RELOP simple_expression {
								$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() , $1->getType());
								$$->setDataType("int");
								logout << "Line " << line_count << ": rel_expression : simple_expression RELOP simple_expression" << endl;
								logout << $$->getName() << endl;
							    }
		;
				
simple_expression : term {
				$$ = $1;
				logout << "Line " << line_count << ": simple_expression : term" << endl;
				logout << $1->getName() << endl;
				
			 }
		  | simple_expression ADDOP term {
		  					string t = $1->getDataType();
		  					if($3->getDataType() == "float"){
		     						t = "float";
		     					}
		     					$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() , $1->getType());
							//$$->setIfArr($3->getIfArr());
			 				$$->setDataType(t);
				 			logout << "Line " << line_count << ": simple_expression : simple_expression ADDOP term" << endl;
							logout << $$->getName() << endl;
							
		  				 }
		  ;
					
term :	unary_expression {
				$$ = $1;
				logout << "Line " << line_count << ": term :  unary_expression" << endl;
				logout << $1->getName() << endl;
				
			 }
     |  term MULOP unary_expression {
     					if($2->getName() == "%" && ($1->getDataType() != "int" || $3->getDataType() != "int")){
     						errorout << "Error at line " << line_count << ": Invalid operands of modulus operator" << endl;
     					}
     					string t = $1->getDataType();
     					if($1->getDataType() == "float" || $3->getDataType() == "float"){
     						t = "float";
     					}
     					$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() , $1->getType());
					//$$->setIfArr(false);
	 				$$->setDataType(t);
		 			logout << "Line " << line_count << ": term : term MULOP unary_expression" << endl;
					logout << $$->getName() << endl;
     				    }
     ;

unary_expression : ADDOP unary_expression  {
						if($2->getDataType() == "int" || $2->getDataType() == "float"){
							$$ = new Symbolinfo($1->getName() + $2->getName() , $2->getType());
							$$->setIfArr($2->getIfArr());
	 						$$->setDataType($2->getDataType());
		 					logout << "Line " << line_count << ": unary_expression : ADDOP unary_expression" << endl;
							logout << $1->getName() << $2->getName() << endl;
						}
						else{
							errorout << "Error at line " << line_count << ": Type mismatch" << endl;
						}
					   }
		 | NOT unary_expression {
		 				if($2->getDataType() == "int"){
		 					$$ = new Symbolinfo("!" + $2->getName(), $2->getType());
		 					$$->setIfArr($2->getIfArr());
	 						$$->setDataType($2->getDataType());
		 					logout << "Line " << line_count << ": unary_expression : NOT unary_expression" << endl;
							logout << "!" << $2->getName() << endl;
		 				}
		 				else{
		 					errorout << "Error at line " << line_count << ": Syntax error" << endl;
		 				}
		 			}
		 | factor {
		 		$$ = $1;
		 		logout << "Line " << line_count << ": unary_expression : factor" << endl;
				logout << $1->getName() << endl;
				
		 	   }
		 ;
	
factor	: variable {
			$$ = $1;
			logout << "Line " << line_count << ": factor  : variable" << endl;
			logout << $1->getName() << endl;
			
		   }
	| ID LPAREN argument_list RPAREN {
						if(table->lookupSymbol($1->getName()) != NULL){
							if(table->lookupSymbol($1->getName())->getIfFunc() == false){
								errorout << "Error at line " << line_count << ": Not a function" << endl;
								args.clear();
							}
							else{
								params = table->lookupSymbol($1->getName())->getParam();
								if(params.size() != args.size()){
									errorout << "Error at line " << line_count << ": Arguments do not match with parameters" << endl;
									args.clear();
									params.clear();
								}
								else if(args.empty()){
									$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() + $4->getName(), $1->getType());
									$$->setDataType(table->lookupSymbol($1->getName())->getDataType());
									logout << "Line " << line_count << ": factor  : ID LPAREN argument_list RPAREN" << endl;
									logout << $$->getName() << endl;
									args.clear();
									params.clear();
								}
								else{
									bool ifError = false;
									for(int i = 0 ; i < params.size() ; i++){
										if(params.at(i).first->getName() != args.at(i)->getDataType()){
											errorout << "Error at line " << line_count << ": Argument type does not match with parameter type" << endl;
											ifError = true;
											break;
										}
									}
									if(!ifError){
										$$ = new Symbolinfo($1->getName() + $2->getName() + $3->getName() + $4->getName(), $1->getType());
										$$->setDataType(table->lookupSymbol($1->getName())->getDataType());
										logout << "Line " << line_count << ": factor  : ID LPAREN argument_list RPAREN" << endl;
										logout << $$->getName() << endl;
									}
									args.clear();
									params.clear();
								}
							}
						}
						else{
							errorout << "Error at line " << line_count << ": Undeclared function call" << endl;
							args.clear();
						}
					}
	| LPAREN expression RPAREN {
					$$ = new Symbolinfo("(" + $2->getName() + ")", $2->getType());
					$$->setIfArr($2->getIfArr());
	 				$$->setDataType($2->getDataType());
					logout << "Line " << line_count << ": factor  : LPAREN expression RPAREN" << endl;
					logout << $$->getName() << endl;
				    }
	| CONST_INT {
			$$ = $1;
			$$->setDataType("int");
			logout << "Line " << line_count << ": factor  : CONST_INT" << endl;
			logout << $1->getName() << endl;
		    }
	| CONST_FLOAT {
				$$ = $1;
				$$->setDataType("float");
				logout << "Line " << line_count << ": factor  : CONST_FLOAT" << endl;
				logout << $1->getName() << endl;
			}
	| variable INCOP {
				$$ = new Symbolinfo($1->getName()+"++", $1->getType());
	 			$$->setIfArr($1->getIfArr());
	 			$$->setDataType($1->getDataType());
				logout << "Line " << line_count << ": factor  : variable INCOP" << endl;
				logout << $$->getName() << "++" << endl;
				
			}
	| variable DECOP {
				$$ = new Symbolinfo($1->getName()+"--", $1->getType());
	 			$$->setIfArr($1->getIfArr());
	 			$$->setDataType($1->getDataType());
				logout << "Line " << line_count << ": factor  : variable DECOP" << endl;
				logout << $$->getName() << "--" << endl;
			}
	;
	
argument_list : arguments {
				$$ = $1;
			  	logout << "Line " << line_count << ": argument_list : arguments" << endl;
				logout << $$->getName() << endl;
			  }
			  | {
			  	$$ = new Symbolinfo("", "");
			  	logout << "Line " << line_count << ": argument_list : " << endl;
				logout << $$->getName() << endl;
			    }
			  ;
	
arguments : arguments COMMA logic_expression {
	      				args.push_back($3);
	      				$$ = new Symbolinfo($1->getName() + $1->getName() + $1->getName(), $1->getType());
	      				logout << "Line " << line_count << ": arguments  : arguments COMMA logic_expression" << endl;
					logout << $$->getName() << endl;
	      			 }
	      | logic_expression {
	      				args.push_back($1);
	      				$$ = new Symbolinfo($1->getName() , $1->getType());
	      				logout << "Line " << line_count << ": arguments  : logic_expression" << endl;
					logout << $$->getName() << endl;
	      			 }
	      ;
 

%%
int main(int argc,char *argv[])
{

	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	errorout.open("error.txt");
	
	logout.open("log.txt");
	yyin= fin;

	//fp2= fopen(argv[2],"w");
	//fclose(fp2);
	//fp3= fopen(argv[3],"w");
	//fclose(fp3);
	
	//fp2= fopen(argv[2],"a");
	//fp3= fopen(argv[3],"a");
	
	yyparse();
	fclose(yyin);

	//fclose(fp2);
	//fclose(fp3);
	logout << "\n\n\n" << endl;
	table->printAllScope("temp.txt");
	ifstream reader("temp.txt");
	string line;
	while(getline(reader, line)){
		logout << line << endl;
	}
	reader.close();
	logout << "\n\n\n" << endl;
	logout.close();
	errorout.close();
	
	return 0;
}


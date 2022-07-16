#include<iostream>
#include<fstream>
#include<cstdlib>
#include<cstring>
#include<sstream>
#include<vector>
#include<utility>
using namespace std;

class Symbolinfo{
	private:
	 string name;
	 string type;
	 string data_type;
	 bool if_array;
	 bool if_func;
	 bool if_defined;
	 int arr_size;
	 string current_index;
	 Symbolinfo *nextID; //for declaration list
	 
	 
	 Symbolinfo *next;
	 Symbolinfo *parent;
	 
	 vector<pair<Symbolinfo*, Symbolinfo*>> parameters;
	
	public:
	 
	 
	 Symbolinfo(string name, string type){
		this->name = name;
		this->type = type;
		this->next = NULL;
		this->parent = NULL;
		this->if_array = false;
		this->if_func = false;
		this->arr_size = 0;
		this->data_type = "";
		this->if_defined = false;
		this->nextID = NULL;
	}
	
	void setIfDefined(bool set){
		this->if_defined = set;
	}
	
	bool getIfDefined(){
		return this->if_defined;
	}
	
	void setName(string name){
		this->name = name;
	}
	
	void setParam(vector<pair<Symbolinfo*, Symbolinfo*>> parameters){
		this->parameters = parameters;
	}
	
	vector<pair<Symbolinfo*, Symbolinfo*>> getParam(){
		return this->parameters;
	}
	
	void setIfFunc(bool set){
		this->if_func = set;
	}
	
	bool getIfFunc(){
		return this->if_func;
	}
	
	void setIndex(string i){
		this->current_index = i;
	}
	
	string getIndex(){
		return this->current_index;
	}
	
	void setNextID(Symbolinfo *s){
		this->nextID = s;
	}
	
	Symbolinfo* getNextID(){
		return this->nextID;
	}
	
	void setDataType(string dType){
		this->data_type = dType;
	}
	
	string getDataType(){
		return this->data_type;
	}
	
	void setIfArr(bool set){
		this->if_array = set;
	}
	
	bool getIfArr(){
		return this->if_array;
	}
	
	void setArrSize(int size){
		this->arr_size = size;
	}
	
	int getArrSize(){
		return this->arr_size;
	}
	
	
	 void setNext(Symbolinfo *symbolinfo){
		this->next = symbolinfo;
		symbolinfo->setParent(this);
	}
	
	void setParent(Symbolinfo *symbolinfo){
		this->parent = symbolinfo;
	}
	
	Symbolinfo* getNext(){
		return this->next;
	}
	
	Symbolinfo* getParent(){
		return this->parent;
	}
	
	 string getName(){
		return this->name;
	}
	
	string getType(){
		return this->type;
	}
	
	void printSymbol(){
		cout<<"<"<<this->name<<" : "<<this->type<<">";
	}
	
	~Symbolinfo(){
		delete this;
	}
};



class Scopetable{
	private:
	 Symbolinfo **symbols;
	 Scopetable *parentScope;
	 Scopetable *nextScope;
	 int size;
	 int number_of_children;
	 string id;
	
	public:
	 Scopetable(Scopetable *parent, int size){
		this->size = size;
		this->symbols = new Symbolinfo*[size];
		for(int i = 0 ; i < size ; i++){
			this->symbols[i] = NULL;
		}
		if(parent != NULL){
			int num = (parent->getChildrenCount())+1;
			ostringstream str1;
			str1 << num;
			string st = str1.str();
			this->id = parent->getId() + "." + st;
		}
		else{
			this->id = "1";
		}
		this->parentScope = parent;
		this->number_of_children = 0;
		if(parent != NULL){
			parent->increaseChildrenCount();
		}
		this->nextScope = NULL;
		//cout<<"New ScopeTable with id "<< this->id<<" created"<<endl;
	}
	
	long symbol_hash(string name){
	unsigned long hash = 0;
    int c;
    int i = 0;
    while (c = name[i++])
        hash = c + (hash << 6) + (hash << 16) - hash;

    return hash;
}
	
	 bool insert(Symbolinfo *symbolinfo){
		string name = symbolinfo->getName();
		long index = symbol_hash(name)%(this->size);
		int hashIndex = (int)index;
		Symbolinfo* symbol = lookup(name);
		if(symbol != NULL){
			
			return false;
		}
		if(this->symbols[hashIndex] == NULL){
            
			this->symbols[hashIndex] = symbolinfo;
		}
		else{
			Symbolinfo *symbol = this->symbols[hashIndex];
            
           
			while(symbol->getNext() != NULL){
                
				symbol = symbol->getNext();
			}
			symbol->setNext(symbolinfo);
            
		}
		
		return true;
	}

	Symbolinfo* lookup(string name){
		long index = symbol_hash(name)%(this->size);
		int hashIndex = (int)index;
		Symbolinfo *symbol = this->symbols[hashIndex];
		while((symbol != NULL) && (symbol->getName() != name)){
			symbol = symbol->getNext();
		}
		return symbol;
	}
	
	
	 string getId(){
	 	return this->id;
	 }
	 
	 int getChildrenCount(){
	 	return this->number_of_children;
	 }
	 
	 void increaseChildrenCount(){
	 	this->number_of_children++;
	 }
	 
	 void printScope(string filename){
	 	ofstream logfileout;
	 	logfileout.open(filename);
	 	logfileout<<"Scope ID : "<<this->id<<endl;
	 	for(int i = 0 ; i < this->size ; i++){
	 		logfileout<<"Index "<<i<<":";
	 		Symbolinfo *symbol = symbols[i];
	 		while(symbol != NULL){
	 			logfileout<<" <"<<symbol->getName()<<" : "<<symbol->getType()<<">  ";
	 			symbol = symbol->getNext();
			}
			logfileout<<endl;
		 }
		 logfileout.close();
	 }
	 
	 bool deleteEntry(string name){
         //cout<<"In Scopetable..."<<endl;
	 	Symbolinfo *symbol = lookup(name);
         //cout<<"Symbol found!"<<endl;
	 	if(symbol == NULL){
             //cout<<"Symbol not found!"<<endl;
	 		return false;
		 }
	 	Symbolinfo *parent = symbol->getParent();
         //cout<<"Parent found!"<<endl;
	 	if(parent != NULL){
             //cout<<"Parent not null"<<endl;
		 	parent->setNext(symbol->getNext());	
		}
         else{
            long index = symbol_hash(name)%(this->size);
            int hashIndex = (int)index;
            this->symbols[hashIndex] = symbol->getNext();
         }
         //cout<<"final deleting..."<<endl;
	 	//delete symbol;
         //cout<<"symbol deleted!"<<endl;
	 	return true;
	 }
	 
	 void setNextScope(Scopetable *scope){
	 	this->nextScope = scope;
	 	
	 }
	 
	 void setParentScope(Scopetable *scope){
	 	this->parentScope = scope;
	 }
	 
	 Scopetable* getNextScope(){
	 	return this->nextScope;
	 }
	 
	 Scopetable* getParentScope(){
	 	return this->parentScope;
	 }
};

class SymbolTable{
	private:
		Scopetable *head;
		Scopetable *current;
		int scopeTableSize;
	
	public:
		SymbolTable(Scopetable *scope, int size){
			this->head = scope;
			this->current = scope;
			this->scopeTableSize = size;
		}
		
		long symbol_hash(string name){
	unsigned long hash = 0;
    int c;
    int i = 0;
    while (c = name[i++])
        hash = c + (hash << 6) + (hash << 16) - hash;

    return hash;
}
		
		void enterScope(){
			Scopetable *newScope = new Scopetable(this->current, this->scopeTableSize);
			(this->current)->setNextScope(newScope);
			this->current = newScope;
		}
		
		void exitScope(){
			Scopetable *scope = this->current;
			this->current = (this->current)->getParentScope();
			(this->current)->setNextScope(NULL);
			
			delete scope;
		}
		
		bool insert(Symbolinfo *symbol){
			return (this->current)->insert(symbol);
		}
		
		bool deleteElement(string name){
           
			return (this->current)->deleteEntry(name);
		}
		
		Symbolinfo* lookupSymbol(string name){
			Scopetable *scope = this->current;
			while((scope != NULL) && (scope->lookup(name) == NULL)){
				scope = scope->getParentScope();
			}
			if(scope == NULL){
				
				return NULL;
			}
			else{
                long index = symbol_hash(name)%(this->scopeTableSize);
                int hashIndex = (int)index;
				
				return scope->lookup(name);
			}
		}
		
		
		//void printCurrentScope(){
           // cout<<" "<<endl;
			//(this->current)->printScope();
		//}
		
		void printAllScope(string filename){
			ofstream logprint;
			logprint.open(filename);
            		logprint <<" "<< endl;
			Scopetable *scope = this->head;
			while(scope != NULL){
				logprint<<endl;
				scope->printScope(filename);
				scope = scope->getNextScope();
			}
			logprint.close();
		}
};

/*int main()
{
//	Scopetable *scope = new Scopetable(NULL, 7);
//	SymbolTable *table = new SymbolTable(scope, 7);
//	Symbolinfo *symbol = new Symbolinfo("a", "a");
//	table->insert(symbol);
//	table->enterScope();
//	Symbolinfo *symbol2 = new Symbolinfo("h", "h");
//	table->insert(symbol2);
//	table->enterScope();
//	Symbolinfo *symbol3 = new Symbolinfo("o", "o");
//	table->insert(symbol3);
//	table->printAllScope();
//	table->lookupSymbol("o");
//	table->lookupSymbol("a");
//	table->exitScope();
//	table->enterScope();
//	Symbolinfo *symbol4 = new Symbolinfo("foo", "Function");
//	table->insert(symbol4);
//	table->exitScope();
//	table->enterScope();
//	Symbolinfo *symbol5 = new Symbolinfo("i", "VAR");
//	table->insert(symbol5);
//	table->printAllScope();
//	table->lookupSymbol("foo");
//	table->lookupSymbol("j");
    //cout<<"Hello"<<endl;

    string name;
    string type;
    char ch;
    char temp;
	ifstream fin("input.txt");
	int bucket;
    if (fin.is_open()){
//        cout<<"File is open"<<endl;
        fin>>bucket;
//        cout<<bucket;
        Scopetable *scope = new Scopetable(NULL, bucket);
	    SymbolTable *table = new SymbolTable(scope, bucket);
        while(fin){
            fin>>ch;
            if(ch == 'I'){
                fin>>name>>type;
                cout<<ch<<" "<<name<<" "<<type<<endl;
                Symbolinfo *symbol = new Symbolinfo(name, type);
                table->insert(symbol);
            }
            else if(ch == 'L'){
                fin>>name;
                cout<<ch<<" "<<name<<endl;
                table->lookupSymbol(name);
            }
            else if(ch == 'D'){
                fin>>name;
                cout<<ch<<" "<<name<<endl;
                table->deleteElement(name);
            }
            else if (ch == 'P'){
                fin>>temp;
                cout<<ch<<" "<<temp<<endl;
                if (temp == 'A'){

                    table->printAllScope();
                }
                else{
                    table->printCurrentScope();
                }
            }
            else if (ch == 'S'){
                cout<<ch<<endl;
                table->enterScope();
            }
            else{
                cout<<ch<<endl;
                table->exitScope();
            }
        }
    }
//    fin>>bucket;
//    cout<<bucket;
//    int index = 0;
//    while((line[index]!=' ') && (line[index]!='\n')){
//        bucket = (bucket*10) + (int)line[index];
//        index++;
//    }
//    cout<<bucket<<endl;
//	Scopetable *scope = new Scopetable(NULL, bucket);
//	SymbolTable *table = new SymbolTable(scope, bucket);
//	while(fin){
//		getline(fin, line);
//		if(line[0] == 'I'){
//            int j = 2;
//            while(line[j]!=' '){
//                name[j-2] = line[j];
//                j++;
//            }
//            j++;
//            int k = 0;
//            while((line[j]!=' ') && (line[j]!='\n')){
//                type[k] = line[j];
//                k++;
//                j++;
//            }
//            Symbolinfo *symbol = new Symbolinfo(name, type);
//            table->insert(symbol);
//        }
//        else if(line[0] == 'L'){
//            int j = 2;
//            while((line[j]!=' ') && (line[j]!='\n')){
//                name[j-2] = line[j];
//                j++;
//            }
//            table->lookupSymbol(name);
//        }
//        else if(line[0] == 'D'){
//            int j = 2;
//            while((line[j]!=' ') && (line[j]!='\n')){
//                name[j-2] = line[j];
//                j++;
//            }
//            table->deleteElement(name);
//        }
//        else if (line[0] == 'P'){
//            if (line[2] == 'A'){
//                table->printAllScope();
//            }
//            else{
//                table->printCurrentScope();
//            }
//        }
//        else if (line[0] == 'S'){
//            table->enterScope();
//        }
//        else{
//            table->exitScope();
//        }
//	}
	fin.close();

	return 0;
}*/

#include<iostream>
#include<fstream>
#include<ctype.h>
#include<string.h>
using namespace std;
 int main()
 {
    ifstream myinput("in.txt");
    ofstream myoutput("out.txt");
    string line,token="",temp="",variable="\n\nVariable List :\n ";
    int flag=0;
     while(getline(myinput,line))
     {
         temp+=line+"\n";
     }
  for (int i=0;i<temp.length();i++)
    { while (temp[i]!=' ')
       {
           if (temp[i]=='\n')
               break;
           token = token + temp[i];
            if(token=="int" || token=="float" || token=="long" ||
                 token=="string" || token=="double")
                    {
                        i=i+2;
                        while(true)
                        {

                            if(temp[i]==';')
                            {
                                variable=variable+'\n';
                                break;
                            }
                            else if(temp[i]=='\n')
                            {
                                variable=variable+'\n';
                                break;
                            }
                            else if(temp[i]==',')
                            {
                                variable=variable+'\n';
                                i++;
                            }
                            else
                            {
                                variable=variable+temp[i];
                                i++;
                            }
                        }
                    }
            i++;
        }
        token = "";
    }

myoutput<<temp<<variable;

    return 0;
    }

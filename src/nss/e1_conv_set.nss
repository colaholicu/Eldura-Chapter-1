#include "e_eval_expr"

void main()
{
    int args = StringToInt(GetScriptParam("argc"));

    int result = EvaluateExpression(GetScriptParam("arg" + IntToString(1)));
    int i = 2;
    for ( ; i <= args; i++)
    {
        string expression = GetScriptParam("arg" + IntToString(i));
        result = EvaluateExpression(expression) && result;
    }
}
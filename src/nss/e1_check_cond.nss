#include "e_eval_expr"

int StartingConditional()
{
    int args = StringToInt(GetScriptParam("argc"));

    int result = EvaluateExpression(GetScriptParam("arg" + IntToString(1)));
    int i = 2;
    for ( ; (i <= args) && (result == TRUE); i++)
    {
        string expression = GetScriptParam("arg" + IntToString(i));
        result = result && EvaluateExpression(expression);
    }

    return result;
}

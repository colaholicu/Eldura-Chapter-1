#include "e_debug_out"
#include "e_eval_expr_ex"

void main()
{
    string expression = GetLocalString(OBJECT_SELF, "expr");

    if (GetStringLength(expression) <= 0)
    {
        DebugOut("Object with tag " + GetTag(OBJECT_SELF) + "needs to have a valid value configured on the object for the \'expr\' variable");
        return;
    }

    EvaluateExpressionEx(expression);
}
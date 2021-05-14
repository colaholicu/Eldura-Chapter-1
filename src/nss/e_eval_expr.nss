#include "e_debug_out"
#include "nw_i0_tool"

const int op_equal = 0;
const int op_not_equal = 1;
const int op_less_or_equal = 2;
const int op_greater_or_equal = 3;
const int op_less = 4;
const int op_greater = 5;
const int op_assign = 6;

const int scope_local = 0;
const int scope_global = 1;
const int scope_inventory = 2;

const int t_int = 0;
const int t_float = 1;
const int t_string = 2;
const int t_object = 3;

// operators:  ==, !=, <=, >=, <, >
// types: n: -> int, f: -> float, s: -> string, o: -> object
// scopes: p: -> GetLocal<type>(PC), m: -> GetLocal<type>(module), i: -> Has/Give/CreateItem(PC)

// valid expression examples:
// p:variable_name==n:1
// m:variable_name==s:string_value
// p:variable_name=n:3

string OpToString(int op)
{
    switch (op)
    {
        case op_equal:
            return "==";

        case op_not_equal:
            return "!=";

        case op_less_or_equal:
            return "<=";

        case op_greater_or_equal:
            return ">=";

        case op_less:
            return "<";

        case op_greater:
            return ">";

        case op_assign:
            return "=";

    }

    return "##";
}

string TypeToString(int type)
{
    switch (type)
    {
        case t_int:
            return "n:";

        case t_float:
            return "f:";

        case t_string:
            return "s:";

        case t_object:
            return "o:";
    }

    return "$:";
}

string ScopeToString(int scope)
{
    switch (scope)
    {
        case scope_local:
            return "p:";

        case scope_global:
            return "m:";

        case scope_inventory:
            return "b:";
    }

    return "@:";
}

int CompareInt(string variableName, int value, int op, int scope)
{
    int variable = 0;
    if (scope == scope_local)
    {
        variable = GetLocalInt(GetPCSpeaker(), variableName);
    }
    else
    {
        variable = GetLocalInt(GetModule(), variableName);
    }
    
    switch (op)
    {
        case op_equal:
            return variable == value;

        case op_not_equal:
            return variable != value;

        case op_less_or_equal:
            return variable <= value;

        case op_greater_or_equal:
            return variable >= value;

        case op_less:
            return variable < value;

        case op_greater:
            return variable > value;
    }

    return FALSE;
}

int CompareFloat(string variableName, float value, int op, int scope)
{
    float variable = 0.0f;
    if (scope == scope_local)
    {
        variable = GetLocalFloat(GetPCSpeaker(), variableName);
    }
    else
    {
        variable = GetLocalFloat(GetModule(), variableName);
    }
    
    switch (op)
    {
        case op_equal:
            return variable == value;

        case op_not_equal:
            return variable != value;

        case op_less_or_equal:
            return variable <= value;

        case op_greater_or_equal:
            return variable >= value;

        case op_less:
            return variable < value;

        case op_greater:
            return variable > value;
    }

    return FALSE;
}

int CompareString(string variableName, string value, int op, int scope)
{
    string variable = "";
    if (scope == scope_local)
    {
        variable = GetLocalString(GetPCSpeaker(), variableName);
    }
    else
    {
        variable = GetLocalString(GetModule(), variableName);
    }
    
    switch (op)
    {
        case op_equal:
            return variable == value;

        case op_not_equal:
        case op_less_or_equal:
        case op_greater_or_equal:
        case op_less:
        case op_greater:
        case op_assign:
            return variable != value;
    }

    return FALSE;
}

int CompareObject(string variableName, string objectName, int op, int scope)
{
    object variable = OBJECT_INVALID;
    if (scope == scope_local)
    {
        variable = GetLocalObject(GetPCSpeaker(), variableName);
    }
    else
    {
        variable = GetLocalObject(GetModule(), variableName);
    }
    
    object value = GetNearestObjectByTag(objectName);
    switch (op)
    {
        case op_equal:
            return variable == value;

        case op_not_equal:
        case op_less_or_equal:
        case op_greater_or_equal:
        case op_less:
        case op_greater:
            return variable != value;
    }

    return FALSE;
}

int EvaluateGet(int scope, string variable, int op, int type, string value)
{
    int result = FALSE;
    if (scope == scope_inventory)
    {
        if (type == t_int)
        {
            int hasItem = HasItem(GetPCSpeaker(), variable);
            if (op == op_equal)
            {
                result = hasItem == StringToInt(value);
            }
            else
            {
                result = hasItem != StringToInt(value);
            }            
        }
        else
        {
            DebugOut("ERROR: wrong type (expected \'n:\') in expression: " + ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value + ")");
        }
    }
    else
    {
        switch (type)
        {
            case t_int:
                result = CompareInt(variable, StringToInt(value), op, scope);
                break;

            case t_float:
                result = CompareFloat(variable, StringToFloat(value), op, scope);
                break;

            case t_string:
                result = CompareString(variable, value, op, scope);
                break;

            case t_object:
                result = CompareObject(variable, value, op, scope);
                break;

            default:
                result = FALSE;
                DebugOut("ERROR: unknown type in expression: ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value");
        }
    }
    
    DebugOut("EVAL SUCCESS: result = " + IntToString(result) + " --> " + ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value + ")");
    return result;
}

int EvaluateSet(int scope, string variable, int op, int type, string value)
{
    if (scope == scope_inventory)
    {        
        if (type == t_int)
        {
            if (CreateItemOnObject(variable, GetPCSpeaker(), StringToInt(value)) != OBJECT_INVALID)
            {
                DebugOut("SUCCESS: CreateItemOnObject(" + variable + ", PC, " + value + ")");
            }
            else
            {
                DebugOut("ERROR: CreateItemOnObject(" + variable + ", PC, " + value + ")");
            }
        }
        else
        {
            DebugOut("ERROR: wrong type (expected \'n:\') in expression: ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value");
            return FALSE;
        }        
    }
    else
    {
        switch (type)
        {
            case t_int:
                SetLocalInt((scope == scope_local) ? GetPCSpeaker() : GetModule(), variable, StringToInt(value));
                break;

            case t_float:
                SetLocalFloat((scope == scope_local) ? GetPCSpeaker() : GetModule(), variable, StringToFloat(value));
                break;

            case t_string:
                SetLocalString((scope == scope_local) ? GetPCSpeaker() : GetModule(), variable, value);
                break;

            case t_object:
                SetLocalObject((scope == scope_local) ? GetPCSpeaker() : GetModule(), variable, GetNearestObjectByTag(value));
                break;

            default:
                DebugOut("ERROR: wrong type in expression: ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value");
                return FALSE;
        }

        DebugOut("SetLocal<type>(" + ((scope == scope_local) ? "PC, " : "Module, ") + variable + ", " + value + ")");
    }

    return TRUE;
}

int EvaluateExpression(string expression)
{
    string variable = "";
    string value = "";

    int expressionLength = GetStringLength(expression);

    int scope = scope_local;
    if (FindSubString(expression, "m:") != -1)
    {
        scope = scope_global;
    }
    else if (FindSubString(expression, "i:") != -1)
    {
        scope = scope_inventory;
    }

    int type = -1;
    for (type = t_int ; type <= t_string; type++)
    {
        int found = -1;
        switch (type)
        {
            case t_int:
                found = FindSubString(expression, "n:");
                break;

            case t_float:
                found = FindSubString(expression, "f:");
                break;

            case t_string:
                found = FindSubString(expression, "s:");
                break;

            case t_object:
                found = FindSubString(expression, "o:");
                break;
        }

        if (found != -1)
        {
            value = GetSubString(expression, found + 2, expressionLength - 2 - found);
            break;
        }
    }

    int op = -1;
    for (op = op_equal; op <= op_assign; op++)
    {
        int found = -1;
        int opStrLength = 2;
        switch (op)
        {
            case op_equal:
                found = FindSubString(expression, "==");
                break;

            case op_not_equal:
                found = FindSubString(expression, "!=");
                break;

            case op_less_or_equal:
                found = FindSubString(expression, "<=");
                break;

            case op_greater_or_equal:
                found = FindSubString(expression, ">=");
                break;

            case op_less:
                found = FindSubString(expression, "<");
                opStrLength = 1;
                break;

            case op_greater:
                found = FindSubString(expression, ">");
                opStrLength = 1;
                break;

            case op_assign:
                found = FindSubString(expression, "=");
                opStrLength = 1;
                break;
        }

        if (found != -1)
        {
            variable = GetSubString(expression, 2, found - 2);
            break;
        }
    }

    if (op == op_assign)
    {
        return EvaluateSet(scope, variable, op, type, value);
    }
    else
    {
        return EvaluateGet(scope, variable, op, type, value);
    }

    return FALSE;
}

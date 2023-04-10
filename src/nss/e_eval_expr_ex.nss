#include "e_debug_out"
#include "nw_i0_tool"

const int op_equal = 0;
const int op_not_equal = 1;
const int op_less_or_equal = 2;
const int op_greater_or_equal = 3;
const int op_less = 4;
const int op_greater = 5;
const int op_invalid = 6;

const int scope_local = 0;
const int scope_global = 1;
const int scope_inventory = 2;
const int scope_jump = 3;

const int operation_blackboard = 0;
const int operation_module = 1;
const int operation_inventory = 2;
const int operation_jump = 3;

const int type_int = 0;
const int type_float = 1;
const int type_string = 2;
const int type_object = 3;

// operators:  ==, !=, <=, >=, <, >, Set
// types: Int, Float, String, Object
// scopes: Blackboard -> Get/SetLocal<type>(PC), Global -> Get/SetLocal<type>(module), Has/Give(PC), Jump(PC) -> JumpToLocation

// valid expression examples:
// GetBlackboardInt(PC, variable_name) == 1
// GetModuleString(variable_name) == string_value
// SetBlackboardFloat(PC, variable_name, 3)
// Has(PC, variable_name)==true
// Give(PC, variable_name)
// JumpTo(PC, location)

string StringReplace(string in, string toReplace, string replaceWith)
{
    string result = "";
    int pos = 0;
    while (pos < GetStringLength(in))
    {
        string i = GetSubString(in, pos, 1);
        if (i == toReplace)
            result = result + replaceWith;
        else
            result = result + i;
        pos++;
    }

    return result;
}


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
    }

    return "##";
}

string TypeToString(int type)
{
    switch (type)
    {
        case type_int:
            return "Int";

        case type_float:
            return "Float";

        case type_string:
            return "String";

        case type_object:
            return "Object";
    }

    return "$:";
}

string OperationToString(int operation)
{
    switch (operation)
    {
        case operation_blackboard:
            return "Blackboard";

        case operation_module:
            return "Module";

        case operation_inventory:
            return "Item";

        case operation_jump:
            return "JumpTo";
    }

    return "@:";
}

int CompareInt(string variableName, int value, int op, int scope)
{
    int variable = 0;
    if (scope == scope_local)
    {
        variable = GetLocalInt(GetFirstPC(), variableName);
    }
    else if (scope == scope_global)
    {
        variable = GetLocalInt(GetModule(), variableName);
    }
    else
    {
        return FALSE;
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
        variable = GetLocalFloat(GetFirstPC(), variableName);
    }
    else if (scope == scope_global)
    {
        variable = GetLocalFloat(GetModule(), variableName);
    }
    else
    {
        return FALSE;
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
        variable = GetLocalString(GetFirstPC(), variableName);
    }
    else if (scope == scope_global)
    {
        variable = GetLocalString(GetModule(), variableName);
    }
    else
    {
        return FALSE;
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
            return variable != value;
    }

    return FALSE;
}

int CompareObject(string variableName, string objectName, int op, int scope)
{
    object variable = OBJECT_INVALID;
    if (scope == scope_local)
    {
        variable = GetLocalObject(GetFirstPC(), variableName);
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

// int EvaluateGet(int scope, string variable, int op, int type, string value)
// {
//     int result = FALSE;
//     switch (scope)
//     {
//         case scope_inventory:
//             if (type == type_int)
//             {
//                 int hasItem = HasItem(GetFirstPC(), variable);
//                 if (op == op_equal)
//                 {
//                     result = hasItem == StringToInt(value);
//                 }
//                 else
//                 {
//                     result = hasItem != StringToInt(value);
//                 }            
//             }
//             else
//             {
//                 DebugOut("ERROR: wrong type (expected \'n:\') in expression: " + ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value + ")");
//             }
//             break;

//         case scope_jump:
//             DebugOut("ERROR: invalid use of EvaluateGet() in expression: " + ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value + ")");
//             break;

//         default:
//             switch (type)
//             {
//                 case type_int:
//                     result = CompareInt(variable, StringToInt(value), op, scope);
//                     break;

//                 case type_float:
//                     result = CompareFloat(variable, StringToFloat(value), op, scope);
//                     break;

//                 case type_string:
//                     result = CompareString(variable, value, op, scope);
//                     break;

//                 case type_object:
//                     result = CompareObject(variable, value, op, scope);
//                     break;

//                 default:
//                     result = FALSE;
//                     DebugOut("ERROR: unknown type in expression: ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value");
//             }
//             break;
//     }
    
//     DebugOut(ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value + " => " + IntToString(result));
//     return result;
// }

// int EvaluateSet(int scope, string variable, int op, int type, string value)
// {
//     switch (scope)
//     {
//         case scope_inventory:
//             if (type == type_int)
//             {
//                 if (CreateItemOnObject(variable, GetFirstPC(), StringToInt(value)) != OBJECT_INVALID)
//                 {
//                     DebugOut("SUCCESS: CreateItemOnObject(" + variable + ", PC, " + value + ")");
//                 }
//                 else
//                 {
//                     DebugOut("ERROR: CreateItemOnObject(" + variable + ", PC, " + value + ")");
//                 }
//             }
//             else
//             {
//                 DebugOut("ERROR: wrong type (expected \'n:\') in expression: ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value");
//                 return FALSE;
//             }
//             break;

//         case scope_jump:
//             if (type == type_int)
//             {
//                 object target = GetObjectByTag(variable);
//                 if (target == OBJECT_INVALID)
//                 {
//                     DebugOut("ERROR: GetObjectByTag(" + variable + ")");
//                 }
//                 else
//                 {
//                     DebugOut("SUCCESS: AssignCommand(PC, ActionJumpToObject(" + variable + ", FALSE" + "))");
//                     AssignCommand(GetFirstPC(), ActionJumpToObject(target, FALSE));
//                 }
//             }
//             else
//             {
//                 DebugOut("ERROR: wrong type (expected \'n:\') in expression: ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value");
//                 return FALSE;
//             }
//             break;


//         default:
//             switch (type)
//             {
//                 case type_int:
//                     SetLocalInt((scope == scope_local) ? GetFirstPC() : GetModule(), variable, StringToInt(value));
//                     break;

//                 case type_float:
//                     SetLocalFloat((scope == scope_local) ? GetFirstPC() : GetModule(), variable, StringToFloat(value));
//                     break;

//                 case type_string:
//                     SetLocalString((scope == scope_local) ? GetFirstPC() : GetModule(), variable, value);
//                     break;

//                 case type_object:
//                     SetLocalObject((scope == scope_local) ? GetFirstPC() : GetModule(), variable, GetNearestObjectByTag(value));
//                     break;

//                 default:
//                     DebugOut("ERROR: wrong type in expression: ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value");
//                     return FALSE;
//             }

//             DebugOut("SetLocal<type>(" + ((scope == scope_local) ? "PC, " : "Module, ") + variable + ", " + value + ")");
//             break;

//     }

//     return TRUE;
// }

int EvaluateInstruction(int operation, string variable, int type, string value)
{
    switch (operation)
    {
        case operation_inventory:
        {
            if (type == type_int)
            {
                if (CreateItemOnObject(variable, GetFirstPC(), StringToInt(value)) != OBJECT_INVALID)
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
            break;
        }

        case operation_jump:
        {
            object target = GetObjectByTag(variable);
            if (target == OBJECT_INVALID)
            {
                DebugOut("ERROR: GetObjectByTag(" + variable + ")");
            }
            else
            {
                DebugOut("SUCCESS: AssignCommand(PC, ActionJumpToObject(" + variable + ", FALSE" + "))");
                AssignCommand(GetFirstPC(), ActionJumpToObject(target, FALSE));
            }
            // else
            // {
            //     DebugOut("ERROR: wrong type (expected \'n:\') in expression: ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value");
            //     return FALSE;
            // }
            break;
        }

        default:
        {
            switch (type)
            {
                case type_int:
                    SetLocalInt((operation == operation_blackboard) ? GetFirstPC() : GetModule(), variable, StringToInt(value));
                    break;

                case type_float:
                    SetLocalFloat((operation == operation_blackboard) ? GetFirstPC() : GetModule(), variable, StringToFloat(value));
                    break;

                case type_string:
                    SetLocalString((operation == operation_blackboard) ? GetFirstPC() : GetModule(), variable, value);
                    break;

                case type_object:
                    SetLocalObject((operation == operation_blackboard) ? GetFirstPC() : GetModule(), variable, GetNearestObjectByTag(value));
                    break;

                default:
                    DebugOut("ERROR: wrong type in expression: ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value");
                    return FALSE;
            }

            if (operation == operation_blackboard)
                DebugOut("SetLocal" + TypeToString(type) + "(PC, " + variable + ", " + value + ")");
            else
                DebugOut("SetLocal" + TypeToString(type) + "(Module, " + variable + ", " + value + ")");
            break;
        }

    }

    return TRUE;
}

int EvaluateQuery(int operation, string variable, int op, int type, string value)
{
    int result = FALSE;    
    switch (operation)
    {
        case scope_inventory:
        {
            int hasItem = HasItem(GetFirstPC(), variable);
            if (op == op_equal)
            {
                result = hasItem == StringToInt(value);
            }
            else
            {
                result = hasItem != StringToInt(value);
            }  
            break;
        }

        case scope_jump:
        {
            DebugOut("ERROR: invalid use of EvaluateQuery() in expression: " + OperationToString(operation) + variable + OpToString(op) + TypeToString(type) + value + ")");
            break;
        }

        default:
        {
            switch (type)
            {
                case type_int:
                    result = CompareInt(variable, StringToInt(value), op, (operation == operation_module) ? scope_global : scope_local);
                    break;

                case type_float:
                    result = CompareFloat(variable, StringToFloat(value), op, (operation == operation_module) ? scope_global : scope_local);
                    break;

                case type_string:
                    result = CompareString(variable, value, op, (operation == operation_module) ? scope_global : scope_local);
                    break;

                case type_object:
                    result = CompareObject(variable, value, op, (operation == operation_module) ? scope_global : scope_local);
                    break;

                default:
                    result = FALSE;
                    DebugOut("ERROR: unknown type in expression: ScopeToString(scope) + variable + OpToString(op) + TypeToString(type) + value");
            }
            break;
        }
    }
    
    DebugOut(OperationToString(operation) + variable + OpToString(op) + TypeToString(type) + value + " => " + IntToString(result));
    return result;
}

int EvaluateExpressionEx(string expression)
{
    int expressionLength = GetStringLength(expression);

    DebugOut("Expression: " + expression);
    expression = StringReplace(expression, " ", "");    

    int operation = -1;
    int cursor = 0;
    int op = -1;
    // get the type of operation + advance the cursor by the length of the operation string
    for (op = operation_blackboard; op < operation_jump; op++)
    {
        string operationKeyword = OperationToString(op);
        if (FindSubString(expression, operationKeyword) >= 0)
        {
            operation = op;
            cursor += GetStringLength(operationKeyword);
            break;
        }
    }

    if (operation == -1)
    {
        DebugOut("ERROR: expression does not contain a valid operation!");
        return FALSE;
    }

    int isQuery = FALSE;
    // get if it's a query or if it's an action/assigment + advance the cursor
    switch (operation)
    {
        case operation_blackboard:
        case operation_module:
            if (FindSubString(expression, "Get") == 0)
            {
                isQuery = TRUE;
            }
            else if (FindSubString(expression, "Set") != 0)
            {
                DebugOut("ERROR: expression does not contain a valid variable setting operation!");
                return FALSE;
            }
            cursor += 3;
            break;

        case operation_inventory:
            if (FindSubString(expression, "Has") == 0)
            {
                isQuery = TRUE;
                cursor += 3;
            }
            else if (FindSubString(expression, "Give") == 0)
            {
                cursor += 4;                
            }
            else
            {
                DebugOut("ERROR: expression does not contain a valid inventory operation!");
                return FALSE;
            }            
            break;
    }

    int type = -1;
    // get the data type used in the operation (mainly blackboard and module vars) + advance the cursor by the data type's length
    switch (operation)
    {
        case operation_blackboard:
        case operation_module:
            if (FindSubString(expression, OperationToString(op) + "Int(") > 0)
            {
                type = type_int;
                cursor += 4;
            }
            else if (FindSubString(expression, OperationToString(op) + "Float(") > 0)
            {
                type = type_float;
                cursor += 6;
            }
            else if (FindSubString(expression, OperationToString(op) + "String(") > 0)
            {
                type = type_string;
                cursor += 7;
            }
            else if (FindSubString(expression, OperationToString(op) + "Object(") > 0)
            {
                type = type_object;
                cursor += 7;
            }
            break;

        case operation_inventory:
        case operation_jump:
            type = 0;
            break;
    }

    if (type == -1)
    {
        DebugOut("ERROR: Invalid type in operation!");
        return FALSE;
    }
    
    // construct query    
    string variable = "";
    string value = "";
    if (isQuery)
    {
        int argumentsEnd = FindSubString(expression, ")", cursor);
        variable = GetSubString(expression, cursor, argumentsEnd - cursor);

        op = -1;
        for (op = op_equal; op < op_greater; op++)
        {
            int found = -1;
            int opStrLength = 2;
            switch (op)
            {
                case op_equal:
                    cursor = FindSubString(expression, "==");
                    break;

                case op_not_equal:
                    cursor = FindSubString(expression, "!=");
                    break;

                case op_less_or_equal:
                    cursor = FindSubString(expression, "<=");
                    break;

                case op_greater_or_equal:
                    cursor = FindSubString(expression, ">=");
                    break;

                case op_less:
                    cursor = FindSubString(expression, "<");
                    opStrLength = 1;
                    break;

                case op_greater:
                    cursor = FindSubString(expression, ">");
                    opStrLength = 1;
                    break;
            }

            if (cursor != -1)
            {
                value = GetSubString(expression, cursor, GetStringLength(expression) - cursor - 1);
                break;
            }
        }

        return EvaluateQuery(operation, variable, op, type, value);
    }
    else
    {
        int variableEnd = 0;
        if (operation == operation_blackboard)
        {
            cursor += 3; // PC,
            variableEnd = FindSubString(expression, ",", cursor);
            variable = GetSubString(expression, cursor, variableEnd - cursor);
            variable = StringReplace(variable, " ", "");
            cursor = variableEnd + 1; // to include ","
        }
        else
        {
            variableEnd = FindSubString(expression, ",", cursor);
            variable = GetSubString(expression, cursor, variableEnd - cursor);
        }

        int valueEnd = FindSubString(expression, ")", cursor);
        value = GetSubString(expression, cursor, valueEnd - cursor);

        return EvaluateInstruction(operation, variable, type, value);
    }

    DebugOut("Expression " + expression + " failed!");
    return FALSE;
}
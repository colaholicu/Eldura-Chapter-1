#include "e_debug_out"
#include "nw_i0_tool"
#include "x3_inc_string"

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

// operators:  ==, !=, <=, >=, <, >, Set/Get
// types: Int, Float, String, Object
// scopes: Blackboard -> Get/SetLocal<type>(PC), Global -> Get/SetLocal<type>(module), Has/GiveItem(PC), Jump(PC) -> JumpToLocation

// valid expression examples:
// GetBlackboardInt(PC, variable_name) == 1
// GetModuleString(variable_name) == string_value
// SetBlackboardFloat(PC, variable_name, 3)
// HasItem(PC, variable_name)==1
// GiveItem(PC, variable_name)
// JumpTo(PC, location)

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
            return "Global";

        case operation_inventory:
            return "Item";

        case operation_jump:
            return "JumpTo";
    }

    return "@:";
}

int CompareInt(string variableName, int value, int op, int scope)
{
    int variable_value = 0;
    if (scope == scope_local)
    {
        variable_value = GetLocalInt(GetFirstPC(), variableName);
    }
    else if (scope == scope_global)
    {
        variable_value = GetLocalInt(GetModule(), variableName);
    }
    else
    {
        return FALSE;
    }
    
    switch (op)
    {
        case op_equal:
            return variable_value == value;

        case op_not_equal:
            return variable_value != value;

        case op_less_or_equal:
            return variable_value <= value;

        case op_greater_or_equal:
            return variable_value >= value;

        case op_less:
            return variable_value < value;

        case op_greater:
            return variable_value > value;
    }

    return FALSE;
}

int CompareFloat(string variableName, float value, int op, int scope)
{
    float variable_value = 0.0f;
    if (scope == scope_local)
    {
        variable_value = GetLocalFloat(GetFirstPC(), variableName);
    }
    else if (scope == scope_global)
    {
        variable_value = GetLocalFloat(GetModule(), variableName);
    }
    else
    {
        return FALSE;
    }
    
    switch (op)
    {
        case op_equal:
            return variable_value == value;

        case op_not_equal:
            return variable_value != value;

        case op_less_or_equal:
            return variable_value <= value;

        case op_greater_or_equal:
            return variable_value >= value;

        case op_less:
            return variable_value < value;

        case op_greater:
            return variable_value > value;
    }

    return FALSE;
}

int CompareString(string variableName, string value, int op, int scope)
{
    string variable_value = "";
    if (scope == scope_local)
    {
        variable_value = GetLocalString(GetFirstPC(), variableName);
    }
    else if (scope == scope_global)
    {
        variable_value = GetLocalString(GetModule(), variableName);
    }
    else
    {
        return FALSE;
    }
    
    switch (op)
    {
        case op_equal:
            return variable_value == value;

        case op_not_equal:
        case op_less_or_equal:
        case op_greater_or_equal:
        case op_less:
        case op_greater:
            return variable_value != value;
    }

    return FALSE;
}

int CompareObject(string variableName, string objectName, int op, int scope)
{
    object variable_value = OBJECT_INVALID;
    if (scope == scope_local)
    {
        variable_value = GetLocalObject(GetFirstPC(), variableName);
    }
    else
    {
        variable_value = GetLocalObject(GetModule(), variableName);
    }
    
    object value = GetNearestObjectByTag(objectName);
    switch (op)
    {
        case op_equal:
            return variable_value == value;

        case op_not_equal:
        case op_less_or_equal:
        case op_greater_or_equal:
        case op_less:
        case op_greater:
            return variable_value != value;
    }

    return FALSE;
}

int EvaluateInstruction(int operation, string variable, int type, string value)
{
    switch (operation)
    {
        case operation_inventory:
        {
            if (CreateItemOnObject(variable, GetFirstPC(), StringToInt(value)) != OBJECT_INVALID)
            {
                DebugOut("SUCCESS: CreateItemOnObject(" + variable + ", PC, " + value + ")");
            }
            else
            {
                DebugOut("ERROR: CreateItemOnObject(" + variable + ", PC, " + value + ")");
                return FALSE;
            }
            break;
        }

        case operation_jump:
        {
            object targetCharacter = variable == "PC" ? GetFirstPC() : GetObjectByTag(variable);
            object targetDestination = GetObjectByTag(value);
            if (targetCharacter == OBJECT_INVALID)
            {
                DebugOut("ERROR: GetObjectByTag(" + variable + ")");
                return FALSE;
            }
            if (targetDestination == OBJECT_INVALID)
            {
                DebugOut("ERROR: GetObjectByTag(" + value + ")");
                return FALSE;
            }
            
            DebugOut("SUCCESS: AssignCommand(" + variable + ", ActionJumpToObject(" + value + ", FALSE" + "))");
            AssignCommand(targetCharacter, ActionJumpToObject(targetDestination, FALSE));            
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
    string operationPrefix = "Get";
    string typeString = TypeToString(type);   
    switch (operation)
    {
        case scope_inventory:
        {
            operationPrefix = "Has";
            int hasItem = HasItem(GetFirstPC(), variable);
            if (op == op_equal)
            {
                result = hasItem == StringToInt(value);
            }
            else
            {
                result = hasItem != StringToInt(value);
            }
            typeString = "";
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
                    DebugOut("ERROR: unknown type in expression: operationPrefix + OperationToString(operation) + TypeToString(type) + ( + variable + ) + OpToString(op) + value");
            }
            break;
        }
    }
    
    DebugOut(operationPrefix + OperationToString(operation) + typeString + "(" + variable + ")" + OpToString(op) + value + " => " + IntToString(result));
    return result;
}

int EvaluateExpressionEx(string expression)
{
    int expressionLength = GetStringLength(expression);

    DebugOut("Expression: " + expression);
    expression = StringReplace(expression, " ", "");
    expression = StringReplace(expression, "\"", "");

    int operation = -1;
    int cursor = 0;
    int op = -1;
    // get the type of operation + advance the cursor by the length of the operation string
    for (op = operation_blackboard; op <= operation_jump; op++)
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
            if (FindSubString(expression, "HasItem") == 0)
            {
                isQuery = TRUE;
                cursor += 3 + 4;
            }
            else if (FindSubString(expression, "GiveItem") == 0)
            {
                cursor += 4 + 4;                
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

        case operation_jump:
            cursor += 1;
        case operation_inventory:        
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
            string op_string = OpToString(op);
            cursor = FindSubString(expression, op_string);            

            if ((cursor != -1) && (op != op_invalid))
            {
                cursor += GetStringLength(op_string);
                value = GetSubString(expression, cursor, GetStringLength(expression) - cursor);
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
        }
        
        variableEnd = FindSubString(expression, ",", cursor);
        // GiveItem can be:
        // GiveItem(PC, item_name) -> give 1 instance of this item
        // GiveItem(PC, item_name, 3) -> give 3 instances of this item
        if ((operation == operation_inventory) && (variableEnd == -1))
        {
            variableEnd = FindSubString(expression, ")", cursor);
            if (variableEnd != -1)
            {
                variable = GetSubString(expression, cursor, variableEnd - cursor);
                value = "1";
            }
        }
        else
        {
            variable = GetSubString(expression, cursor, variableEnd - cursor);            
        }
        cursor = variableEnd + 1; // to include ","        

        int valueEnd = FindSubString(expression, ")", cursor);
        value = GetSubString(expression, cursor, valueEnd - cursor);
        if (valueEnd >= 0)
            value = GetSubString(expression, cursor, valueEnd - cursor);

        return EvaluateInstruction(operation, variable, type, value);
    }

    DebugOut("Expression " + expression + " failed!");
    return FALSE;
}
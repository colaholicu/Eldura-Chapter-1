float pitch = -1.0f;
float distance = -1.0f;
void main()
{
    string command = GetPCChatMessage();
    object pc = GetFirstPC();

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), pc);
    return;    

    int commandLength = GetStringLength(command);
    string commandPrefix = "tp_";
    int isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        string targetTag = GetSubString(command, 3, commandLength - 3);
        object target = GetObjectByTag(targetTag);
        location targetLocation = GetLocation(target);
        AssignCommand(pc, JumpToLocation(targetLocation));
        return;
    }

    commandPrefix = "gm";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        int prefixLength = GetStringLength(commandPrefix);
        string strValue = GetSubString(command, commandLength - 1, 1);
        int value = StringToInt(strValue);
        string debug = "god mode mismatch";
        if (value == 1)
        {
            if (GetLocalInt(pc, "GodMode") == 0)
            {
                debug = "ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(10000), pc, 1000f);";

                SetLocalInt(pc, "GodMode", 1);
                SetLocalInt(pc, "HP", GetMaxHitPoints(pc));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectTemporaryHitpoints(10000), pc);
            }
        }
        else
        {
            if (GetLocalInt(pc, "GodMode") == 1)
            {
                int hp = GetCurrentHitPoints(pc);
                int originalHP = GetLocalInt(pc, "HP");
                debug = "ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(" + IntToString(hp - originalHP) + "), pc);";

                SetLocalInt(pc, "GodMode", 0);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(hp - originalHP), pc);
            }
        }

        AssignCommand(pc, ActionSpeakString(debug));
        return;
    }

    commandPrefix = "tpcam";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        string strValue = GetSubString(command, commandLength - 1, 1);
        int value = StringToInt(strValue);

        int cameraMode = CAMERA_MODE_STIFF_CHASE_CAMERA;
        float pitch = -1.0f;
        float distance = -1.0f;
        float facing = GetFacing(pc);
        if (value == 1)
        {
            cameraMode = CAMERA_MODE_STIFF_CHASE_CAMERA;
            pitch = 80.f;
            distance = 10.f;

        }
        else
        {
            cameraMode = CAMERA_MODE_TOP_DOWN;
        }

        string strCameraMode = "";
        switch (cameraMode)
        {
            case 0:
                strCameraMode = "CAMERA_MODE_CHASE_CAMERA";
                break;

            case 1:
                strCameraMode = "CAMERA_MODE_TOP_DOWN";
                break;

            case 2:
                strCameraMode = "CAMERA_MODE_STIFF_CHASE_CAMERA";
                break;
        }

        string debug = "SetCameraMode(" + strCameraMode + ");\nSetCameraFacing(" + FloatToString(facing) + ", " + FloatToString(distance) + ", " + FloatToString(pitch) + ")";
        AssignCommand(pc, ActionSpeakString(debug));
        DelayCommand(0.1f, AssignCommand(pc, SetCameraFacing(facing, distance, pitch)));

        DelayCommand(0.2f, LockCameraDistance(pc, value));
        DelayCommand(0.2f, LockCameraPitch(pc, value));
        DelayCommand(0.3f, SetCameraMode(pc, cameraMode));

        return;
    }

    commandPrefix = "scm";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        string strValue = GetSubString(command, commandLength - 1, 1);
        int value = StringToInt(strValue);
        switch (value)
        {
            case 0:
                strValue = "CAMERA_MODE_CHASE_CAMERA";
                break;

            case 1:
                strValue = "CAMERA_MODE_TOP_DOWN";
                break;

            case 2:
                strValue = "CAMERA_MODE_STIFF_CHASE_CAMERA";   // <--- 3rd person
                break;
        }
        string debug = "Setting Camera Mode to " + strValue;
        AssignCommand(pc, ActionSpeakString(debug));
        SetCameraMode(pc, value);
        return;
    }

    commandPrefix = "scp";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        // 80 <--- 3rd person
        float facing = GetFacing(pc);
        int prefixLength = GetStringLength(commandPrefix);
        string variable = GetSubString(command, prefixLength, commandLength - prefixLength);
        pitch = StringToFloat(variable);
        string debug = "SetCameraFacing(" + FloatToString(facing) + ", " + FloatToString(distance) + ", " + variable + ")";
        AssignCommand(pc, ActionSpeakString(debug));
        AssignCommand(pc, SetCameraFacing(facing, distance, pitch));
        return;
    }

    commandPrefix = "scd";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        // 10 <--- 3rd person
        float facing = GetFacing(pc);
        int prefixLength = GetStringLength(commandPrefix);
        string variable = GetSubString(command, prefixLength, commandLength - prefixLength);
        distance = StringToFloat(variable);
        string debug = "SetCameraFacing(" + FloatToString(facing) + ", " + variable + ", " + FloatToString(pitch) + ")";
        AssignCommand(pc, ActionSpeakString(debug));
        AssignCommand(pc, SetCameraFacing(facing, distance, pitch));
        return;
    }

    commandPrefix = "kill";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        string debug = "Kill PC";
        AssignCommand(pc, ActionSpeakString(debug));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(999), pc);
        return;
    }

    commandPrefix = "svi_";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        int prefixLength = GetStringLength(commandPrefix);
        string variable = GetSubString(command, prefixLength, commandLength - 1 - prefixLength);
        string strValue = GetSubString(command, commandLength - 1, 1);
        int value = StringToInt(strValue);
        string debug = "SetLocalInt(PC, " + variable + ", " + strValue + ")";
        AssignCommand(pc, ActionSpeakString(debug));
        SetLocalInt(pc, variable, value);
        return;
    }

    commandPrefix = "sgvi_";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        int prefixLength = GetStringLength(commandPrefix);
        string variable = GetSubString(command, prefixLength, commandLength - 1 - prefixLength);
        string strValue = GetSubString(command, commandLength - 1, 1);
        int value = StringToInt(strValue);
        string debug = "SetLocalInt(Module, " + variable + ", " + strValue + ")";
        AssignCommand(pc, ActionSpeakString(debug));
        SetLocalInt(GetModule(), variable, value);
        return;
    }

    commandPrefix = "gi_";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        int prefixLength = GetStringLength(commandPrefix);
        string itemRef = GetSubString(command, prefixLength, commandLength - 1 - prefixLength);
        string strValue = GetSubString(command, commandLength - 1, 1);
        int value = StringToInt(strValue);
        string debug = "";
        if (value == 1)
        {
            object item = CreateItemOnObject(itemRef, pc);
            SetLocalObject(pc, itemRef, item);
            debug = "CreateItemOnObject(PC, " + itemRef + ", " + GetTag(item) + ")";
        }
        else
        {
            object item = GetLocalObject(pc, itemRef);
            if (item != OBJECT_INVALID)
            {
                debug = "DestroyObject(" + itemRef + ")";
                SetLocalObject(pc, itemRef, OBJECT_INVALID);
                DestroyObject(item);
            }
            else
            {
                debug = "Could not find object " + itemRef;
            }
        }

        AssignCommand(pc, ActionSpeakString(debug));
        return;
    }
}

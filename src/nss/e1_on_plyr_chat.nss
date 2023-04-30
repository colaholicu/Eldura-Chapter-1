#include "e_debug_out"

float pitch = -1.0f;
float distance = -1.0f;

// "tp_[object_tag] -- teleport to an object retrieved by tag\n" +
// "gm [0/1] -- toggle god mode\n" +
// "kill -- kills the player\n" + 
// "dmg [0/1]-- infinite (very high) damage bonus\n" + 
// "sli_[variable][value] -- SetLocalInt(PC, variable, value)\n" + 
// "sgi_[variable][value] -- SetLocalInt(MODULE, variable, value)\n" + 
// "gi_[item][1/0] -- Create an item on the player or remove it";

void main()
{
    string command = GetPCChatMessage();
    object pc = GetFirstPC();

    if (command == "help")
    {
        DebugOut("tp_[object_tag] -- teleport to an object retrieved by tag");
        DebugOut("gm [0/1] -- toggle god mode");
        DebugOut("sli/sgi_[variable][value] -- SetLocalInt(PC/MODULE, variable, value)");
        DebugOut("gi_[item][1/0] -- Create an item on the player or remove it");
        return;
    }
    
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

        DebugOut(debug);
        return;
    }

    commandPrefix = "dmg";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        int prefixLength = GetStringLength(commandPrefix);
        string strValue = GetSubString(command, commandLength - 1, 1);
        int value = StringToInt(strValue);
        string debug = "dmg mismatch";
        if (value == 1)
        {
            if (GetLocalInt(pc, "Dmg") == 0)
            {
                debug = "ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(1000, DAMAGE_TYPE_FIRE), pc)";

                SetLocalInt(pc, "Dmg", 1);
                int damageType = -1;
                for (damageType = DAMAGE_TYPE_BLUDGEONING; damageType <= DAMAGE_TYPE_SONIC; damageType *= 2)
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(20, damageType), pc);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAttackIncrease(20, ATTACK_BONUS_ONHAND), pc);
            }
        }
        else
        {
            if (GetLocalInt(pc, "Dmg") == 1)
            {
                debug = "ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamageIncrease(-1000, DAMAGE_TYPE_FIRE), pc)";

                SetLocalInt(pc, "Dmg", 0);
                int damageType = -1;
                for (damageType = DAMAGE_TYPE_BLUDGEONING; damageType <= DAMAGE_TYPE_SONIC; damageType *= 2)
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(-20, damageType), pc);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAttackIncrease(-20, ATTACK_BONUS_ONHAND), pc);
            }
        }

        DebugOut(debug);
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
            pitch = 80.0f;
            distance = 5.0f;

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
        DebugOut(debug);
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
        DebugOut(debug);
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
        DebugOut(debug);
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
        DebugOut(debug);
        AssignCommand(pc, SetCameraFacing(facing, distance, pitch));
        return;
    }

    commandPrefix = "kill";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        string debug = "Kill PC";
        DebugOut(debug);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(999), pc);
        return;
    }

    commandPrefix = "sli_";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        int prefixLength = GetStringLength(commandPrefix);
        string variable = GetSubString(command, prefixLength, commandLength - 1 - prefixLength);
        string strValue = GetSubString(command, commandLength - 1, 1);
        int value = StringToInt(strValue);
        string debug = "SetLocalInt(PC, " + variable + ", " + strValue + ")";
        DebugOut(debug);
        SetLocalInt(pc, variable, value);
        return;
    }

    commandPrefix = "sgi_";
    isValidCommand = FindSubString(command, commandPrefix);
    if (isValidCommand != -1)
    {
        int prefixLength = GetStringLength(commandPrefix);
        string variable = GetSubString(command, prefixLength, commandLength - 1 - prefixLength);
        string strValue = GetSubString(command, commandLength - 1, 1);
        int value = StringToInt(strValue);
        string debug = "SetLocalInt(Module, " + variable + ", " + strValue + ")";
        DebugOut(debug);
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

        DebugOut(debug);
        return;
    }
}

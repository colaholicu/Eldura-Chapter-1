//::///////////////////////////////////////////////
//:: FileName e1_lth_tk_cond2
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 5
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Inspect local variables
    if(!(GetLocalInt(GetModule(), "e1LutherFullIntro") == 1))
        return FALSE;

    if (GetLocalInt(GetModule(), "e1LeftForTemple") == 1)
        return FALSE;

    if (GetLocalInt(GetModule(), "e1TeleportedFromArcanys") == 1)
        return FALSE;

    return TRUE;
}

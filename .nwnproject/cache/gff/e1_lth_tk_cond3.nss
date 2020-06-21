//::///////////////////////////////////////////////
//:: FileName e1_lth_tk_cond4
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 5
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "e1_luther_bloodied_note"))
        return FALSE;

    if (GetLocalInt(GetModule(), "e1LeftForTemple") == 1)
        return FALSE;

    return TRUE;
}

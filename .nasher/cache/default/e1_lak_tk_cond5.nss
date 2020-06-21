//::///////////////////////////////////////////////
//:: FileName e1_lak_tk_cond5
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 5
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Inspect local variables
    if(!(GetLocalInt(GetPCSpeaker(), "askedLakhesiAboutName") == 1))
        return FALSE;

    if (GetName(OBJECT_SELF) != "Lakhesi")
        return FALSE;


    return TRUE;
}

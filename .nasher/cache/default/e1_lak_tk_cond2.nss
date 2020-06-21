#include "nw_i0_tool"

int StartingConditional()
{
    int iResult = GetLocalInt(GetPCSpeaker(), "lakhesiSpokenBefore");
    if (HasItem(GetPCSpeaker(), "e1_pale_amulet"))
    {
        return FALSE;
    }
    return iResult != 0;
}

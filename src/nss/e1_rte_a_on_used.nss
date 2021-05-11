#include "e_debug_out"

void main()
{
    string debug = "error";
    int openedSanctum = GetLocalInt(GetModule(), "e1OpenedPathToSanctum");
    if (openedSanctum)
    {
        debug = "Sanctum already opened";
        DebugOut(debug);
        return;
    }

    object luther = GetNearestObjectByTag("e1_luther_old");
    if (GetIsObjectValid(luther))
    {
        AssignCommand(OBJECT_SELF, ActionStartConversation(GetFirstPC(), "e1_rte_altar_tk", FALSE, FALSE));
    }
    else
    {
        debug = "GetNearestObjectByTag() failed";
        DebugOut(debug);
    }
}

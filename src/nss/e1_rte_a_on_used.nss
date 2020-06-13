void main()
{
    if (GetLocalInt(GetModule(), "e1OpenedPathToSanctum"))
    {
        return;
    }

    object luther = GetNearestObjectByTag("e1_luther_old");
    AssignCommand(luther, ActionStartConversation(GetFirstPC(), "e1_rte_altar_tk", FALSE, FALSE));
}

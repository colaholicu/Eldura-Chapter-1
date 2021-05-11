void main()
{
    object pc = GetFirstPC();
    if (GetEnteringObject() != pc)
    {
        return;
    }

    object khratul = GetNearestObjectByTag("e1_khratul_plot", pc);
    if (GetLocalInt(khratul, "IsParalyzed"))
    {
        SetCutsceneMode(pc, FALSE);
        DestroyObject(GetNearestObjectByTag("e1_khratul_plot", pc));
        DestroyObject(GetNearestObjectByTag("e1_luther_old", pc));
        AssignCommand(pc, ActionJumpToLocation(GetLocation(GetObjectByTag("e1_rte_from_esf"))));
    }
}

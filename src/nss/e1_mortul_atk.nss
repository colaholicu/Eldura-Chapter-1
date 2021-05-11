void main()
{
    object pc = GetFirstPC();
    SetCutsceneMode(pc, FALSE);
    AssignCommand(GetNearestObjectByTag("e1_mortul_weak"), ActionAttack(pc));
}

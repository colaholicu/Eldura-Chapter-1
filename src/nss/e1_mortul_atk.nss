void main()
{
    object pc = GetFirstPC();
    SetCutsceneMode(pc, FALSE);
    object mortulWeak = GetNearestObjectByTag("e1_mortul_weak");
    AssignCommand(mortulWeak, ActionAttack(pc));
    SetIsTemporaryEnemy(mortulWeak, pc);
    SetIsTemporaryEnemy(pc, mortulWeak);
}

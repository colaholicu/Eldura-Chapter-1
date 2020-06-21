void main()
{
    object pc = GetFirstPC();
    AssignCommand(pc, ActionMoveToLocation(GetLocation(GetNearestObjectByTag("e1_esf_to_rte", pc)), TRUE));
}

void main()
{
    object pc = GetFirstPC();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), GetLocation(pc), 10.0f);
    SetLocalInt(GetModule(), "e1TeleportedFromArcanys", 1);
    DelayCommand(2.0f, AssignCommand(pc, ActionJumpToLocation(GetLocation(GetObjectByTag("e1_lc_door_luthers_cottage")))));
}

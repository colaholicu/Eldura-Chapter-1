void main()
{
    object pc = GetFirstPC();
    object khratul = GetNearestObjectByTag("e1_khratul_plot", pc);
    object luther = GetNearestObjectByTag("e1_luther_old", pc);

    SetLocalInt(khratul, "IsParalyzed", 1);
    AssignCommand(luther, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0f, 1.0f));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_TIME_STOP), GetLocation(khratul), 2000.0f);
    DelayCommand(1.0f, AssignCommand(khratul, ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 1.0f, 2000.0f)));
}

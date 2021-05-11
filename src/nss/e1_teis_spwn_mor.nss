void main()
{
    object luther = GetNearestObjectByTag("e1_luther_old");
    object mortul = GetNearestObjectByTag("e1_mortul_weak");
    location spawnpoint = GetLocation(luther);
    location mortulsLocation = GetLocation(mortul);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), spawnpoint);
    AssignCommand(luther, ActionJumpToLocation(mortulsLocation));
    DelayCommand(0.25f, AssignCommand(mortul, ActionJumpToLocation(spawnpoint)));
    DelayCommand(1.0f, DestroyObject(luther));
}

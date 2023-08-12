void main()
{
    object luther = GetNearestObjectByTag("e1_luther_old");
    object mortul = GetNearestObjectByTag("e1_mortul_weak");
    location spawnpoint = GetLocation(luther);
    location mortulsLocation = GetLocation(mortul);
    SetPlotFlag(luther, FALSE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectInvisibility(INVISIBILITY_TYPE_NORMAL), luther);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE), spawnpoint);
    AssignCommand(mortul, ActionJumpToLocation(spawnpoint));
    AssignCommand(luther, ActionJumpToLocation(mortulsLocation));
    DelayCommand(5.0f, DestroyObject(luther));    
}

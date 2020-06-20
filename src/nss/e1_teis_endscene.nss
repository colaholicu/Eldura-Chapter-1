void spawnZombies(object mortul, object pc)
{
    int i = 1;
    object zombieDestination = GetNearestObjectByTag("e1_teis_zombie_destination", mortul);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), GetLocation(zombieDestination));
    for (i = 1; i < 12; ++i)
    {        
        string spawnpoint = "e1_teis_zombie_spawn" + IntToString(i);
        object zombie = CreateObject(OBJECT_TYPE_CREATURE, "zombie_teis", GetLocation(GetNearestObjectByTag(spawnpoint, mortul)));
        DelayCommand(1.0f, AssignCommand(zombie, ActionForceMoveToLocation(GetLocation(pc))));
        DelayCommand(5.0f, DestroyObject(zombie));
    }

    object aisa = GetNearestObjectByTag("e1_aisa", pc);
    DelayCommand(1.5f, AssignCommand(aisa, SpeakString("By the power of the Eldur!")));
    DelayCommand(2.0f, AssignCommand(aisa, PlayAnimation(ANIMATION_LOOPING_CONJURE2, 5.0f)));
    DelayCommand(2.5f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), GetLocation(zombieDestination)));
    DelayCommand(4.0f, FadeToBlack(pc));
    DelayCommand(7.0f, SetCutsceneMode(pc, FALSE));
    DelayCommand(7.1f, AssignCommand(pc, ActionJumpToLocation(GetLocation(GetObjectByTag("e1_dream_one_start")))));
    DelayCommand(9.0f, FadeFromBlack(pc, FADE_SPEED_SLOWEST));
}

void main()
{    
    object pc = GetFirstPC();
    object mortul = GetObjectByTag("e1_mortul_weak");
    SetCutsceneMode(pc);
    AssignCommand(mortul, ClearAllActions());
    AssignCommand(mortul, PlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0f, 5.0f));
    DelayCommand(2.0f, spawnZombies(mortul, pc));
}
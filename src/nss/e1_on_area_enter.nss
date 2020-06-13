void main()
{
    object pc = GetFirstPC();
    if (GetEnteringObject() != pc)
    {
        return;
    }

    AssignCommand(pc, ActionSpeakString("caca mmmmmmmmmmmaca?"));

    if (GetTag(GetArea(pc)) == "e1_luthers_cottage")
    {
        if (GetLocalInt(GetModule(), "e1TeleportedFromArcanys") && !GetLocalInt(GetModule(), "e1TeleportedToLuther"))
        {
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), GetLocation(pc), 10.0f);
            SetCutsceneMode(pc);
            DelayCommand(3.0f, SetCutsceneMode(pc, FALSE));
            SetLocalInt(GetModule(), "e1TeleportedToLuther", 1);
        }
    }

    return;

    int cameraMode = CAMERA_MODE_STIFF_CHASE_CAMERA;
    float facing = GetFacing(pc);
    float pitch = 80.f;
    float distance = 10.f;

    DelayCommand(0.1f, AssignCommand(pc, SetCameraFacing(facing, distance, pitch)));

    DelayCommand(0.2f, LockCameraDistance(pc, TRUE));
    DelayCommand(0.2f, LockCameraPitch(pc, TRUE));
    DelayCommand(0.3f, SetCameraMode(pc, cameraMode));

    AssignCommand(pc, ActionSpeakString("cacamaca?"));
}

void main()
{
    object luther = GetNearestObjectByTag("e1_luther_old", GetFirstPC());
    if (luther == OBJECT_INVALID)
    {
        SpeakString("invalid luther");
    }

    object door = GetNearestObjectByTag("e1_lc_door_luthers_cottage");
    if (door == OBJECT_INVALID)
    {
        SpeakString("invalid door");
    }
    SetCutsceneMode(GetFirstPC(), TRUE);

    DelayCommand(1.0, AssignCommand(luther, ActionForceMoveToLocation(GetLocation(GetObjectByTag("e1_esf_luther")), TRUE)));
    DelayCommand(4.0, SetCutsceneMode(GetFirstPC(), FALSE));

    SetLocalInt(GetModule(), "e1LeftForTemple", 1);
}

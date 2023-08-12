void Leave(object pc)
{
    // object target = GetNearestObjectByTag("e1_dream_one_target", mortul);
    // AssignCommand(mortul, ActionJumpToObject(target));
    // AssignCommand(arctus, ActionJumpToObject(target));
    // AssignCommand(luther, ActionJumpToObject(target));

    DelayCommand(5.0f, FadeToBlack(pc));
    DelayCommand(7.0f, AssignCommand(pc, ActionJumpToLocation(GetLocation(GetObjectByTag("e1_naroo_inn_start")))));
}

void TalkDream1(int line, object pc)
{
    object mortul = GetNearestObjectByTag("e1_mortul", pc);
    object arctus = GetNearestObjectByTag("e1_arctus_human", pc);
    object luther = GetNearestObjectByTag("e1_luther", pc);

    string lineToSpeak = "";
    object actor = OBJECT_INVALID;
    float delay = 5.0f;
    switch (line)
    {
        case 1:
            lineToSpeak = "We've got him cornered. Let's end this!";
            actor = mortul;
            break;

        case 2:
            lineToSpeak = "Be patient, Ra'nor! It would be unwise to rush in after all these years!";
            actor = luther;
            break;

        case 3:
            lineToSpeak = "I'm afraid we don't have time to wait for the Arch Magi, Luther.";
            actor = arctus;
            delay = 4.0f;
            break;

        case 4:
            lineToSpeak = "The ritual may begin at any moment!";
            actor = arctus;
            break;

        case 5:
            lineToSpeak = "Arctus is right! We should make haste before the Khar escapes once again!";
            actor = mortul;
            break;

        case 6:
            lineToSpeak = "Alright... Let's go in and make sure the ritual doesn't begin. We shall wait for the Magi there.";
            actor = luther;
            break;

        default:
            Leave(pc);
            return;
    }

    AssignCommand(actor, ActionSpeakString(lineToSpeak));
    DelayCommand(delay, TalkDream1(line + 1, pc));
}

void main()
{
    object pc = GetFirstPC();
    string areaName = GetTag(GetArea(pc));
    if (areaName == "e1_dream1")
    {
        StoreCameraFacing();
        int cameraMode = CAMERA_MODE_STIFF_CHASE_CAMERA;
        float facing = GetFacing(pc);
        float pitch = 80.0f;
        float distance = 5.0f;

        DelayCommand(0.5f, AssignCommand(pc, SetCameraFacing(facing, distance, pitch)));

        DelayCommand(0.7f, LockCameraDistance(pc, TRUE));
        DelayCommand(0.8f, LockCameraPitch(pc, TRUE));
        DelayCommand(0.9f, SetCameraMode(pc, cameraMode));

        SetCutsceneMode(pc);
        FadeFromBlack(pc);

        DelayCommand(2.0f, TalkDream1(1, pc));
    }

    ExecuteScript("e1_on_area_enter");
}

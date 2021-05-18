void main()
{
    object pc = GetPCSpeaker();
    FadeToBlack(pc, FADE_SPEED_FASTEST);
    DelayCommand(0.5f, AssignCommand(pc, JumpToObject(GetNearestObjectByTag("e1_etc_rope_wp"), FALSE)));
    DelayCommand(0.75f, FadeFromBlack(pc, FADE_SPEED_FAST));
}

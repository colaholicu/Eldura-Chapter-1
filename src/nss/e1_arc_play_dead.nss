//::///////////////////////////////////////////////
//:: Name x2_def_heartbeat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default Heartbeat script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////

void main()
{
    if (GetLocalInt(OBJECT_SELF, "IsFakeDead") == 1)
    {
        PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 2000.f);
        return;
    }
    ExecuteScript("nw_c2_default1", OBJECT_SELF);
}

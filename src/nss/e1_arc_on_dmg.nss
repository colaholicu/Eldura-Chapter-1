//::///////////////////////////////////////////////
//:: Name x2_def_attacked
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default On Physically attacked script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////

void main()
{

    object xen = GetNearestObjectByTag("e1_vidma");
    if ((GetLastAttacker() == xen) && (GetLocalInt(OBJECT_SELF, "IsFakeDead") == 0))
    {
        SetIsTemporaryFriend(OBJECT_SELF, xen);
        SetIsTemporaryFriend(xen, OBJECT_SELF);
        AssignCommand(xen, ClearAllActions());
        DelayCommand(0.25, PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 2000.0f));
        SetLocalInt(OBJECT_SELF, "IsFakeDead", 1);
        return;
    }
    else if (GetLocalInt(OBJECT_SELF, "IsFakeDead") == 1)
    {
        return;
    }
    //--------------------------------------------------------------------------
    // GZ: 2003-10-16
    // Make Plot Creatures Ignore Attacks
    //--------------------------------------------------------------------------
    if (GetPlotFlag(OBJECT_SELF))
    {
        return;
    }

    //--------------------------------------------------------------------------
    // Execute old NWN default AI code
    //--------------------------------------------------------------------------

    ExecuteScript("nw_c2_default5", OBJECT_SELF);
    //nw_c2_default6
}

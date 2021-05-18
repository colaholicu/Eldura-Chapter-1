// Whenever a player clicks on the tracks - give the proper feedback

// NOTICE: make sure this object's tag is 16 or less chars!!!

void main()
{
    string tag = GetTag(OBJECT_SELF);
    if (tag == "e1_etc_tracks_01" || tag == "e1_etc_tracks_02")
    {
        DestroyObject(GetNearestObjectByTag("e1_etc_tracks_11"));
        DestroyObject(GetNearestObjectByTag("e1_etc_tracks_12"));
    }
    else
    {
        DestroyObject(GetNearestObjectByTag("e1_etc_tracks_01"));
        DestroyObject(GetNearestObjectByTag("e1_etc_tracks_02"));
    }

    ExecuteScript("x1_tracks_used");

    AssignCommand(GetLastUsedBy(), SpeakOneLinerConversation("e1_etc_tracks_tk"));
}

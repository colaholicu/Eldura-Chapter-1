int StartingConditional()
{
    if (GetLocalInt(GetModule(), "e1LeftForTemple") == 1)
    {
        return FALSE;
    }

    return GetLocalInt(GetModule(), "e1TeleportedFromArcanys");
}

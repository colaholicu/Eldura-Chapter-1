int StartingConditional()
{
    int iResult = GetLocalInt(GetPCSpeaker(), "lakhesiSpokenBefore");
    return iResult == 0;
}

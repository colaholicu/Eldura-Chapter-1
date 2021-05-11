void DebugOut(string message)
{
    object pc = GetFirstPC();
    
    // Define colours using Hex. FF is highest, 00 is lowest. See online calculators if you want specific colours.
    int nColourRed = 0xFF0000FF;
    int nColourGreen = 0x00FF0FF;
    int nColourBlue = 0x0000FFFF;
    int nColourWhite = 0xFFFFFFFF;
    int nFadeOut = 0xFFFFFFFF;
    float timeOnScreen = 9999.0f;    

    string msg1 = GetLocalString(pc, "msg1");
    string msg2 = GetLocalString(pc, "msg2");
    string msg3 = GetLocalString(pc, "msg3");
    string msg4 = GetLocalString(pc, "msg4");
    string msg5 = GetLocalString(pc, "msg5");

    if (GetStringLength(msg1) > 0)
    {
        if (GetStringLength(msg2) > 0)
        {
            if (GetStringLength(msg3) > 0)
            {
                if (GetStringLength(msg4) > 0)
                {
                    if (GetStringLength(msg5) > 0)
                    {
                        msg1 = msg2;
                        msg2 = msg3;
                        msg3 = msg4;
                        msg4 = msg5;
                    }
                    
                    msg5 = message;
                }
                else
                {
                    msg4 = message;
                }
            }
            else
            {
                msg3 = message;
            }
        }
        else
        {
            msg2 = message;
        }
    }
    else
    {
        msg1 = message;
    }

    SetLocalString(pc, "msg1", msg1);
    SetLocalString(pc, "msg2", msg2);
    SetLocalString(pc, "msg3", msg3);
    SetLocalString(pc, "msg4", msg4);
    SetLocalString(pc, "msg5", msg5);
    
    PostString(pc, msg1, 0, 0, SCREEN_ANCHOR_TOP_LEFT, timeOnScreen, nColourWhite, nFadeOut);
    PostString(pc, msg2, 0, 1, SCREEN_ANCHOR_TOP_LEFT, timeOnScreen, nColourWhite, nFadeOut);
    PostString(pc, msg3, 0, 2, SCREEN_ANCHOR_TOP_LEFT, timeOnScreen, nColourWhite, nFadeOut);
    PostString(pc, msg4, 0, 3, SCREEN_ANCHOR_TOP_LEFT, timeOnScreen, nColourWhite, nFadeOut);
    PostString(pc, msg5, 0, 4, SCREEN_ANCHOR_TOP_LEFT, timeOnScreen, nColourWhite, nFadeOut);
}
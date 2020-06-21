void main()
{
    string signString = "";
    string northString = GetLocalString(OBJECT_SELF, "North");
    if (northString != "")
    {
       signString += "North: " + northString + "\n";
    }

    string eastString = GetLocalString(OBJECT_SELF, "East");
    if (eastString != "")
    {
       signString += "East: " + eastString + "\n";
    }

    string southString = GetLocalString(OBJECT_SELF, "South");
    if (southString != "")
    {
       signString += "South: " + southString + "\n";
    }

    string westString = GetLocalString(OBJECT_SELF, "West");
    if (westString != "")
    {
       signString += "West: " + westString + "\n";
    }

    string messageString = GetLocalString(OBJECT_SELF, "Message");
    if (messageString != "")
    {
        signString = messageString;
    }

    SpeakString(signString);
}

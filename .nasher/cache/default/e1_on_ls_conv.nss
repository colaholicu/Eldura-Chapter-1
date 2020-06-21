#include "nw_i0_tool"

void main()
{
    int random = Random(5);
    string lineToSpeak = "";
    if (HasItem(GetFirstPC(), "e1_pale_amulet"))
    {
        switch (random)
        {
            case 0:
                lineToSpeak = "Darkness... forest...";
                break;

            case 1:
                lineToSpeak = "Deceiver...";
                break;

            case 2:
                lineToSpeak = "Betrayer...";
                break;

            case 3:
                lineToSpeak = "King... is... gone...";
                break;

            case 4:
                lineToSpeak = "Old... but... powerful";
                break;
        }
    }
    else
    {
        switch (random)
        {
            case 0:
                lineToSpeak = "Yntyneric... pdyr'e...";
                break;

            case 1:
                lineToSpeak = "Ynjeltor...";
                break;

            case 2:
                lineToSpeak = "Trdtor...";
                break;

            case 3:
                lineToSpeak = "Reg'e... ny... mi ye...";
                break;

            case 4:
                lineToSpeak = "Btrn... dr... pytrnyc";
                break;
        }
    }

    SpeakString(lineToSpeak);
}

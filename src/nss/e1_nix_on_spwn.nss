object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
void main()
{
DelayCommand(3.0,ActionStartConversation(oPC,"e1_nix_tk",TRUE,FALSE));
}

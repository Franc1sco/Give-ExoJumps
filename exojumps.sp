/*  SM ExoJump Boots Giver
 *
 *  Copyright (C) 2019 Francisco 'Franc1sco' García
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#include <sourcemod>


public Plugin myinfo =
{
	name = "SM ExoJump Boots Giver",
	author = "Franc1sco franug",
	description = "",
	version = "1.0",
	url = "http://steamcommunity.com/id/franug"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_exojump", Command_ExoJump, ADMFLAG_BAN);
}

public Action Command_ExoJump(int client, int args)
{

	if(args < 1) // Not enough parameters
	{
		ReplyToCommand(client, "[SM] Use: sm_exojump <#userid|name>");
		return Plugin_Handled;
	}


	char strTarget[32]; GetCmdArg(1, strTarget, sizeof(strTarget)); 

	// Process the targets 
	char strTargetName[MAX_TARGET_LENGTH]; 
	int TargetList[MAXPLAYERS], TargetCount; 
	bool TargetTranslate; 

	if ((TargetCount = ProcessTargetString(strTarget, client, TargetList, MAXPLAYERS, COMMAND_FILTER_CONNECTED, 
					strTargetName, sizeof(strTargetName), TargetTranslate)) <= 0) 
	{ 
		ReplyToCommand(client, "client not found");
		return Plugin_Handled; 
	} 

	// Apply to all targets 
	for (int i = 0; i < TargetCount; i++) 
	{ 
		int iClient = TargetList[i]; 
		if (IsClientInGame(iClient) && IsPlayerAlive(iClient)) 
		{
			GiveExoJump(iClient);
			ReplyToCommand(client, "Player %N received exojump",iClient);
		} 
	}

	return Plugin_Handled;
}

stock void GiveExoJump(int iClient)
{
	SetCvar("sv_cheats", 1);
	FakeClientCommand(iClient, "exojump");
	SetCvar("sv_cheats", 0);
}

stock void SetCvar(char cvarName[64], int value)
{
	Handle IntCvar = FindConVar(cvarName);
	if (IntCvar == null) return;

	int flags = GetConVarFlags(IntCvar);
	flags &= ~FCVAR_NOTIFY;
	SetConVarFlags(IntCvar, flags);

	SetConVarInt(IntCvar, value);

	flags |= FCVAR_NOTIFY;
	SetConVarFlags(IntCvar, flags);
}
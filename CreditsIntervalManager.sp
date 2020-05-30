#include <sourcemod>
#include <sdkhooks>
#include <multicolors>
#include <store>

#undef REQUIRE_PLUGIN
#include <SWGM>
#include <servermanager>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Interval Credits Manager",
	author = "Nano",
	description = "Simple plugin to give credits to those who are members in an steam group or on a discord server.",
	version = "1.0",
	url = "https://steamcommunity.com/id/marianzet1/"
};

ConVar g_cCreditsSystem;
ConVar g_cCreditsAmount;
ConVar g_cCreditsInterval;

public void OnPluginStart()
{
	g_cCreditsSystem = CreateConVar("sm_ci_system", "1", "What do you want to use? 1 = Steam Group Manager | 2 = Discord Server Manager (Default 1)");
	g_cCreditsAmount = CreateConVar("sm_ci_amount", "10", "How many credits will people receive? (Default 10)");
	g_cCreditsInterval = CreateConVar("sm_ci_interval", "60", "Interval (in seconds) to receive credits (Default 60)");
	
	AutoExecConfig(true, "plugin.creditsinterval");
}

public void OnMapStart()
{
	CreateTimer(g_cCreditsInterval.FloatValue, Timer_CreditsInterval, TIMER_REPEAT);
}

public Action Timer_CreditsInterval(Handle timer)
{
	int iCredits = g_cCreditsAmount.IntValue;
	for(int i = 1; i <= MaxClients; i++)
	{
		if(g_cCreditsSystem.IntValue == 1)
		{
			if(IsClientInGame(i) && !IsFakeClient(i) && SWGM_IsPlayerValidated(i) && SWGM_InGroup(i))
			{
				Store_SetClientCredits(i, Store_GetClientCredits(i) + iCredits);
				CPrintToChat(i, "​{green}[SM]{default} You have received {orange}%i{default} credits for being member in our {orange}steam group!", iCredits);
			}
		}
		else if(g_cCreditsSystem.IntValue == 2)
		{
			if(IsClientInGame(i) && !IsFakeClient(i) && DSM_IsMember(i))
			{
				Store_SetClientCredits(i, Store_GetClientCredits(i) + iCredits);
				CPrintToChat(i, "​{green}[SM]{default} You have received {orange}%i{default} credits for being member in our {orange}discord server!", iCredits);
			}
		}
	}
}
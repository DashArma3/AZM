class CfgPatches
{
	class Dash_AdvancedZipline
	{
		units[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Weapons_F", "cba_xeh"};
	};
};

class CfgFunctions 
{
	class Dash
	{
		class AdvancedZipline
		{
			file = "\Dash_AdvancedZipline\functions";
			class AdvancedZiplineInit{};
		};
	};
};

class Extended_Init_EventHandlers
{
    class CAManBase
    {
        class AdvancedZipline_Init_EH
        {
            init = "[_this select 0] call Dash_fnc_AdvancedZiplineInit";
        };
    };
};

/* Todo CfgAmmo*/

class CfgAmmo
{
	class F_40mm_CIR;
    class G_40mm_Zipline: F_40mm_CIR {
		deflecting = 0;
		maxSpeed = 0;
		thrust = 0;
		effectsSmoke = "";
		simulation="shotSmoke";
    };
};

class CfgMagazines {
    class CA_Magazine;
    class UGL_FlareCIR_F;

    class 1Rnd_Zipline_shell : UGL_FlareCIR_F {
        ammo = "G_40mm_Zipline";
        descriptionShort = "Advanced Zipline Round";        
        displayName = "Advanced Zipline Round";
    };
};

/* Todo CfgMagazineWells*/

class CfgMagazineWells {
    class VOG_40mm {
        ADDON[] = {"1Rnd_Zipline_shell"};
    };
		class UGL_40x36 {
        ADDON[] = {"1Rnd_Zipline_shell"};
    };
		class 3UGL_40x36 {
        ADDON[] = {"1Rnd_Zipline_shell"};
    };
		class CBA_40mm_M203 {
        ADDON[] = {"1Rnd_Zipline_shell"};
    };
		class CBA_40mm_3GL {
        ADDON[] = {"1Rnd_Zipline_shell"};
    };
		class GL_3GL_F{
        ADDON[] = {"1Rnd_Zipline_shell"};
    };
};

class CfgSounds
{
    sounds[] = {};
    class ZiplineSound
    {
        name = "ZiplineSound";
        sound[] = { "\Dash_AdvancedZipline\fx\ZiplineSound.ogg", 1, 1, 100 };
        titles[] = { 1, "ZiplineSound" };
    };
};

/*
marker
menMax
menRandomMax
customInit
groupId
*/

if (!isServer)exitWith{};

_findNearBuidlings = 
{
	private ["_marker","_radius","_center","_buildingObjects","_buildings"];
	
	_marker = _this select 0;
	
	_radius = 15;
	
	_center = getMarkerPos _marker;
	
	_buildingObjects = nearestObjects [_center, ["building"], _radius];
	
	if (isNil("_buildingObjects")) exitWith{diag_log format ["No buildings found for '%1' within '%2'", _marker, _radius]};
	if (count _buildingObjects == 0) exitWith{};
	
	_buildings = [];
	{
		if (str (_x buildingPos 0) != "[0,0,0]") then {_buildings set[(count _buildings), _x];};
	} forEach _buildingObjects;
	
	if (count _buildings == 0) exitWith{diag_log "No buildings found!"};
	
	_buildings;
};

private ["_marker","_menMax","_menRandomMax","_customInit","_grpId","_milHQ","_milGroup","_buildings","_buildingPositions","_a","_building","_i","_i2","_pos","_unit","_weapon"];

_marker = _this select 0;
_menMax = _this select 1;
_menRandomMax = _this select 2;
_customInit = _this select 3; if (!isNil("_customInit")) then {if (_customInit == "nil0") then {_customInit = nil;};};
_grpId = _this select 4;

if (isNil("LV_ACskills")) then {LV_ACskills = compile preprocessFile "addons\AI_spawn\LV_functions\LV_fnc_ACskills.sqf";};
if (isNil("LV_vehicleInit")) then {LV_vehicleInit = compile preprocessFile "addons\AI_spawn\LV_functions\LV_fnc_vehicleInit.sqf";};

_centerPos = getMarkerPos _marker;

_menAmount = _menMax + (ceil (random _menRandomMax));

diag_log format ["Creating guards for '%1' with '%2' men", _marker, _menAmount];

_buildings = [_marker] call _findNearBuidlings;

if (isNil("_buildings")) exitWith 
{
	diag_log "No buildings found switching to militarize!"
	[_marker, 10, 2, 2, 0, _customInit, _grpId] execVM "addons\AI_spawn\militarizeK.sqf";
};

if (count _buildings == 0) exitWith {};

_buildingPositions = [];
_a = 0;
while {_a < (count _buildings)} do {
	_building = (_buildings select _a);
	_i = 0;
	while {((_building buildingPos _i) select 0) != 0} do {
		_buildingPositions set [count (_buildingPositions), (_building buildingPos _i)];
		_i = _i + 1;
	};
	_a = _a + 1;
};

_milHQ = createCenter east;
_milGroup = createGroup east;

if (_menAmount > 0) then {
	for "_i2" from 1 to _menAmount do {
		_pos = _buildingPositions select floor (random count _buildingPositions);
		if (_menAmount < count _buildingPositions) then {_buildingPositions = _buildingPositions - [_pos];};
		
		_unit = _milGroup createUnit ["O_Soldier_A_F", _pos, [], 0, "NONE"];
		_unit setPos _pos;
		
		removeAllWeapons _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;
		
		_unit forceAddUniform "U_I_GhillieSuit";
		_unit addVest "V_PlateCarrier1_rgr";
		_unit addBackpack "B_Kitbag_mcamo";
		
		_weapon = (ceil (random 5));
		
		switch (_weapon) do
		{
			case (1):
			{
				_unit addWeapon "srifle_EBR_ARCO_pointer_F";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "20Rnd_762x51_Mag";
			};
			
			case (2):
			{
				_unit addWeapon "arifle_MXM_Hamr_pointer_F";
				_unit addMagazine "30Rnd_65x39_caseless_mag";
				_unit addMagazine "30Rnd_65x39_caseless_mag";
				_unit addMagazine "30Rnd_65x39_caseless_mag";
			};
			
			case (3):
			{
				_unit addWeapon "srifle_EBR_ARCO_pointer_snds_F";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "20Rnd_762x51_Mag";
			};
			
			case (4):
			{
				_unit addWeapon "srifle_EBR_ARCO_pointer_F";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "Titan_AA";
				_unit addWeapon "launch_Titan_F";
				_unit addMagazine "Titan_AA";
				_unit addMagazine "Titan_AA";
			};
			
			case (5):
			{
				_unit addWeapon "srifle_EBR_ARCO_pointer_F";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "Titan_AT";
				_unit addWeapon "launch_Titan_short_F";
				_unit addMagazine "Titan_AT";
				_unit addMagazine "Titan_AT";
			};
		};
		
		_unit addPrimaryWeaponItem "acc_flashlight";
		_unit enableGunLights "forceOn";
		_unit addRating 1e11;
		_unit spawn addMilCap;
		_unit spawn refillPrimaryAmmo;
		
		nul = [_unit, 0.75] call LV_ACskills;
		
		nul = [_unit] execVM "addons\AI_spawn\patrol-vG.sqf"; 
				
		if (!isNil("_customInit")) then { 
			nul = [_unit, _customInit] spawn LV_vehicleInit;
		};
	};
};

if (!isNil("_grpId")) then {
	call compile format ["LVgroup%1 = _milGroup", _grpId];
	call compile format ["LVgroup%1spawned = true", _grpId];
	_thisArray = [];
	{
		if (isNil("_x")) then {
			_thisArray set [(count _thisArray), "nil0"];
		} else {
			_thisArray set [(count _thisArray), _x];
		};
	} forEach _this;
	call compile format ["LVgroup%1CI = ['fillhouse',%2]", _grpId, _thisArray];
};

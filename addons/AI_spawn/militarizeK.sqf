/*
marker
radius
customInit
groupId
*/

if (!isServer)exitWith{};

private ["_marker","_radius","_customInit","_grpId","_centerPos","_menAmount","_vehAmount","_allUnitsArray","_milHQ","_milGroup","_validPos","_dir","_range","_pos","_unit","_weapon","_thisArray","_vehicleType","_vehicle","_crew","_driver"];

_marker = if(count _this > 0) then {_this select 0;};
_radius = if(count _this > 1) then {_this select 1;} else {2;};
_customInit = if (count _this > 2) then {_this select 2;} else {nil;}; if(!isNil("_customInit")) then {if(_customInit == "nil0") then {_customInit = nil;};};
_grpId = if(count _this > 3) then {_this select 3;} else {nil;};

if(isNil("LV_ACskills"))then{LV_ACskills = compile preprocessFile "addons\AI_spawn\LV_functions\LV_fnc_ACskills.sqf";};
if(isNil("LV_vehicleInit"))then{LV_vehicleInit = compile preprocessFile "addons\AI_spawn\LV_functions\LV_fnc_vehicleInit.sqf";};
if(isNil("LV_fullLandVehicle"))then{LV_fullLandVehicle = compile preprocessFile "addons\AI_spawn\LV_functions\LV_fnc_fullLandVehicle.sqf";};

_centerPos = getMarkerPos _marker;

_menAmount = 5 + (ceil (random 5));
_vehAmount = (ceil (random 1));

diag_log format ["Creating guards for '%1' with '%2' men and '%3' vehicles", _marker, _menAmount, _vehAmount];

_allUnitsArray = [];
_milHQ = createCenter civilian;
_milGroup = createGroup civilian;

if (_menAmount > 0) then {
	for "_i" from 1 to _menAmount do {
		_validPos = false;
		while {!_validPos} do {
			_dir = random 360;
			_range = random _radius;
			_pos = [(_centerPos select 0) + (sin _dir) * _range, (_centerPos select 1) + (cos _dir) * _range, 0];
			
			if (!surfaceIsWater _pos) then {
				_validPos = true;
			};
		};
		
		_unit = _milGroup createUnit ["C_man_polo_1_F", _pos, [], 0, "NONE"];
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
				diag_log format ["Creating guard %1 with weapon %2", _i, _weapon];
				_unit addWeapon "srifle_EBR_ARCO_pointer_F";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "20Rnd_762x51_Mag";
			};
			
			case (2):
			{
				diag_log format ["Creating guard %1 with weapon %2", _i, _weapon];
				_unit addWeapon "arifle_MXM_Hamr_pointer_F";
				_unit addMagazine "30Rnd_65x39_caseless_mag";
				_unit addMagazine "30Rnd_65x39_caseless_mag";
				_unit addMagazine "30Rnd_65x39_caseless_mag";
			};
			
			case (3):
			{
				diag_log format ["Creating guard %1 with weapon %2", _i, _weapon];
				_unit addWeapon "srifle_EBR_ARCO_pointer_snds_F";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "20Rnd_762x51_Mag";
				_unit addMagazine "20Rnd_762x51_Mag";
			};
			
			case (4):
			{
				diag_log format ["Creating guard %1 with weapon %2", _i, _weapon];
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
				diag_log format ["Creating guard %1 with weapon %2", _i, _weapon];
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
		
		nul = [_unit, _centerPos, _radius, true] execVM "addons\AI_spawn\patrol-vD.sqf";
		
		_unit allowDamage false;
		_allUnitsArray set [(count _allUnitsArray), _unit];
	};
};

_milGroup setBehaviour "SAFE";

if (_vehAmount > 0) then {
	for "_i" from 1 to _vehAmount do {
		_validPos = false;
		while {!_validPos} do {
			_dir = random 360;
			_range = random _radius;
			_pos = [(_centerPos select 0) + (sin _dir) * _range, (_centerPos select 1) + (cos _dir) * _range, 0];
			
			if (!surfaceIsWater _pos) then {
				_validPos = true;
			};
		};
		
		_vehicleType = (ceil (random 2));
		
		switch (_vehicle) do
		{
			case (1):
			{
				diag_log format ["Creating vehicle %1 with vehicleType %2", _i, _vehicleType];
				_vehicle = createVehicle ["B_APC_Tracked_01_AA_F", _pos, [], 0, "NONE"];
			};
			
			case (2):
			{
				diag_log format ["Creating vehicle %1 with vehicleType %2", _i, _vehicleType];
				_vehicle = createVehicle ["B_MBT_01_cannon_F", _pos, [], 0, "NONE"];
			};
		};
		
		_crew = [_vehicle, _milGroup] call BIS_fnc_spawnCrew;
		_driver = driver _vehicle;
		
		nul = [_driver, _pos] execVM 'addons\AI_spawn\patrol-vE.sqf';
		
		_vehicle allowDamage false;
		_allUnitsArray set [(count _allUnitsArray), _vehicle];
		
		(units(group _driver)) joinSilent _milGroup;
	};
};

{
	nul = [_x, 0.75] call LV_ACskills;
	if (!isNil("_customInit")) then {
		[_x, _customInit] spawn LV_vehicleInit;
	};
} forEach units _milGroup;

sleep 3;
{
	_x allowDamage true;
} forEach _allUnitsArray;

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
	call compile format ["LVgroup%1CI = ['militarize',%2]", _grpId, _thisArray];
};

/*
marker
radius
menMax
menRandomMax
vehMax
customInit
groupId
*/

if (!isServer)exitWith{};

_createLandVehicle =
{
	private ["_position","_vehicles","_vehiclesSeats","_milHQ","_milGroup","_vehicleId","_selectedVehicle","_radius","_roads","_posTemp","_vehicle","_unit","_i","_driver"];

	_position = _this select 0;

	_vehicles = ["O_MBT_02_arty_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_AA_F","O_APC_Tracked_02_cannon_F","O_MBT_02_cannon_F"];
	_vehiclesSeats = [3,2,2,3,3,3,3];

	_milHQ = createCenter east;
	_milGroup = createGroup east;

	_vehicleId = floor (random (count _vehicles));
	_selectedVehicle = _vehicles select _vehicleId;
	_spots = _vehiclesSeats select _vehicleId;

	_radius = 40;
	_roads = [];
	while {(count _roads) == 0} do {
		_roads = _position nearRoads _radius;
		_radius = _radius + 10;
	};

	if (((_roads select 0) distance _pos) < 200) then {
		_pos = getPos (_roads select 0);
		_posTemp = [_pos, 0, 25, 5, 0, 1, 0] call BIS_fnc_findSafePos;
	} else {
		_posTemp = [_pos, 0, 200, 5, 0, 1, 0] call BIS_fnc_findSafePos;
	};
	_pos = [_posTemp select 0, _posTemp select 1, 0];

	sleep 0.5;

	_vehicle = createVehicle [_selectedVehicle, _pos, [], 0, "NONE"];
	_vehicle setPos _pos;

	_vehicle allowDamage false;

	sleep 2;
	if (((vectorUp _vehicle) select 2) != 0) then {_vehicle setVectorUp [0, 0, 0]};
	sleep 2;
	_vehicle allowDamage true;

	for "_i" from 1 to _spots do {
		_unit = _milGroup createUnit ["O_Soldier_A_F", _pos, [], 0, "NONE"];

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
		_unit addWeapon "srifle_EBR_ARCO_pointer_F";
		_unit addMagazine "20Rnd_762x51_Mag";
		_unit addMagazine "20Rnd_762x51_Mag";
		_unit addMagazine "20Rnd_762x51_Mag";
		_unit addPrimaryWeaponItem "acc_flashlight";
		_unit enableGunLights "forceOn";
		_unit addRating 1e11;
		_unit spawn addMilCap;
		_unit spawn refillPrimaryAmmo;
		
		nul = [_unit, 0.75] call LV_ACskills;
		
		switch (_i) do {
			case 1: {
				_unit moveInDriver _vehicle;
			};
			
			default {
				if (_vehicle emptyPositions "gunner" > 0) then {
					_unit moveInGunner _vehicle;
				} else {
					if (_vehicle emptyPositions "commander" > 0) then {
						_unit moveInCargo _vehicle;
					} else {
						_unit moveInCargo _vehicle;
					};
				};
			};
		};
		
		sleep 0.3;
	};

	_vehicle
};

private ["_marker","_radius","_menMax","_menRandomMax","_vehMax","_customInit","_grpId","_centerPos","_menAmount","_vehAmount","_allUnitsArray","_milHQ","_milGroup","_validPos","_dir","_range","_pos","_unit","_weapon","_thisArray","_vehicle","_driver"];

_marker = _this select 0;
_radius = _this select 1;
_menMax = _this select 2;
_menRandomMax = _this select 3;
_vehMax = _this select 4;
_customInit = _this select 5; if(!isNil("_customInit")) then {if(_customInit == "nil0") then {_customInit =nil;};};
_grpId = _this select 6;

if (isNil("LV_ACskills")) then {LV_ACskills = compile preprocessFile "addons\AI_spawn\LV_functions\LV_fnc_ACskills.sqf";};
if (isNil("LV_vehicleInit")) then {LV_vehicleInit = compile preprocessFile "addons\AI_spawn\LV_functions\LV_fnc_vehicleInit.sqf";};

_centerPos = getMarkerPos _marker;

_menAmount = _menMax + (round (random _menRandomMax));
_vehAmount = 0;

if (_vehMax > 0) then
{
	_vehAmount = (round (random _vehMax));
	_menAmount = _menAmount - _vehAmount;
}

diag_log format ["Creating guards for '%1' with '%2' men and '%3' vehicles", _marker, _menAmount, _vehAmount];

_allUnitsArray = [];
_milHQ = createCenter east;
_milGroup = createGroup east;

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
		
		_vehicle = [_pos] call _createLandVehicle;
		
		nul = [_vehicle, _pos] execVM 'addons\AI_spawn\patrol-vE.sqf';
		
		_vehicle allowDamage false;
        
        _allUnitsArray set [(count _allUnitsArray), _vehicle];
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

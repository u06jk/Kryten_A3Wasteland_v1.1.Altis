/*
position
*/

private ["_position","_vehicles","_vehiclesSeats","_milHQ","_milGroup","_vehicleId","_selectedVehicle","_radius","_roads","_posTemp","_vehicle","_unit","_i","_driver"];

_position = _this select 0;

_vehicles = ["O_MBT_02_arty_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_AA_F","O_APC_Tracked_02_cannon_F","O_MBT_02_cannon_F"];
_vehiclesSeats = [3,2,2,3,3,3,3]

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
	
	/*switch (_i) do {
		case 1: {
			_unit moveInDriver _vehicle;
		};
		case 2: {
			_unit moveInTurret _vehicle;
		};
		case 3: {
			_unit moveInCommander _vehicle;
		};
	};*/
	
	_unit moveInCargo _vehicle;
	
	sleep 0.3;
};

_driver = driver _vehicle;

diag_log format ["Vehicle '%1'", _vehicle];
diag_log format ["Crew '%1'", crew _vehicle];
diag_log format ["Driver '%1'", _driver];

_driver
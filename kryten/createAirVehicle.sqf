/*
position,
milGroup
*/

if (!isServer)exitWith{};

private ["_position","_milGroup","_selectedVehicle","_vehicle","_driver","_gunner"]

_position = _this select 0;
_milGroup = _this select 1;

_selectedVehicle = ["O_Heli_Attack_02_F","O_Heli_Attack_02_black_F"] call BIS_fnc_selectRandom;

_vehicle = createVehicle [_selectedVehicle, _position, [], 0, "FLY"];

sleep 0.5;

_driver = [_position, 10, _milGroup, 0, false, false] execVM "kryten\createUnit.sqf";
_driver moveInDriver _vehicle;

_gunner = [_position, 10, _milGroup, 1, false, false] execVM "kryten\createUnit.sqf";
_gunner moveInGunner _vehicle;

_vehicle
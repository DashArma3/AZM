params["_player"];

//1Rnd_Zipline_shell

_player setVariable ["AdvancedZiplineHasEH", false, true];

_player addEventHandler["Reloaded", {
  params["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"];

  if ((!(_unit getVariable "AdvancedZiplineHasEH")) && ((_newMagazine select 0) == "1Rnd_Zipline_shell")) then {
    _unit setVariable ["AdvancedZiplineHasEH", true, true];

      _advancedZiplineFiredManEH = _unit addEventHandler["FiredMan", {
        _this spawn {
          params["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

          if (_magazine != "1Rnd_Zipline_shell") exitWith {};

          _newProjectile = "B_127x108_Ball"
          createVehicle(getPos _projectile);
          _newProjectile setVelocity(velocity _projectile);
          deleteVehicle _projectile;

          /* TODO */

          _attachedProjectile = "BombCluster_03_UXO3_F"
          createVehicle[0, 0, 0];
          _attachedProjectile attachTo[_newProjectile, [0, 0, 0]];
          _attachedProjectile setDir(getDir _unit);
          _attachedProjectile setVariable["AdvancedZipline_magazine", _magazine, true];

          _createDummyPos = _unit modelToWorld[0, 0, 0];
          _pole = createVehicle["Land_Rope_01_F", _createDummyPos, [], 0, "CAN_COLLIDE"];
          _poleAttachment = createVehicle["C_Kart_01_F", _createDummyPos, [], 0, "CAN_COLLIDE"];
          [_poleAttachment] remoteExec["hideObject", 0, true];

          _rope = ropeCreate[_poleAttachment, [0, 0, -1], _attachedProjectile, [0, 0, 0], 100];

          /* End TODO */

          while {
            alive _newProjectile
          }
          do {
            if ((_newProjectile distance _unit) > 100) exitWith {
              _newProjectile setVelocity[0, 0, -5];
            };
          };

          _difX = ((getPosATL _pole) select 0) - ((getPosATL _attachedProjectile) select 0);
          _difY = ((getPosATL _pole) select 1) - ((getPosATL _attachedProjectile) select 1);
          _difZ = ((getPosATL _pole) select 2) - ((getPosATL _attachedProjectile) select 2);

          _pole setVariable["AdvancedZipline_attachedProjectile", _attachedProjectile, true];
          _pole setVariable["AdvancedZipline_rope", _rope, true];
          _pole setVariable["AdvancedZipline_difZ", _difZ, true];
          _pole setVariable["AdvancedZipline_poleAttachment", _poleAttachment, true];

          _pole addAction["Stretch rope", {
            params["_target", "_caller", "_actionId", "_arguments"];

            _attachedProjectile = _target getVariable 'AdvancedZipline_attachedProjectile';
            _poleAttachment = _target getVariable 'AdvancedZipline_poleAttachment';
            _rope = _target getVariable 'AdvancedZipline_rope';

            deleteVehicle _rope;

            _ropeLength = _target distance2D _attachedProjectile;

            _rope = ropeCreate[_poleAttachment, [0, 0, -1], _attachedProjectile, [0, 0, 0], _ropeLength];

            _target setVariable["AdvancedZipline_isStreched", true, true];
            _target setVariable["AdvancedZipline_rope", _rope, true];

            _target removeAction _actionId;

            _target addAction["Hang up", {
              params["_target", "_caller", "_actionId", "_arguments"];

              _attachedProjectile = _target getVariable 'AdvancedZipline_attachedProjectile';
              _rope = _target getVariable "AdvancedZipline_rope";

              _difX = ((getPosASL _target) select 0) - ((getPosASL _attachedProjectile) select 0);
              _difY = ((getPosASL _target) select 1) - ((getPosASL _attachedProjectile) select 1);
              _difZ = ((getPosASL _target) select 2) - ((getPosASL _attachedProjectile) select 2);

              _dis = _target distance _attachedProjectile;

              _caller setPosASL[getPosASL _target select 0, getPosASL _target select 1, (getPosASL _target select 2) - 1.8];
              _caller attachTo[_rope];

              playSound3D["A3\Missions_F_Bootcamp\data\sounds\assemble_target.wss", _caller];

              while {
                _caller distance _attachedProjectile > 5
              }
              do {
                _caller switchMove "vehicle_coshooter_1_Idle_Unarmed";
                _caller setPosASL((getPosASL _caller) vectorAdd[(-_difX / _dis / 5), (-_difY / _dis / 5), (-_difZ / _dis / 5)]);

                _caller setDir (_target getDir _attachedProjectile);
                sleep 0.01;
              };

              _caller setPosASL(getPosASL _attachedProjectile);
              _caller switchMove "AcrgPknlMstpSnonWnonDnon_AmovPercMstpSrasWrflDnon_getOutMedium";

              detach _caller;
            }];
          }];

          _pole addAction["Retract rope", {
            params["_target", "_caller", "_actionId", "_arguments"];

            _attachedProjectile = _target getVariable 'AdvancedZipline_attachedProjectile';
            _magazine = _attachedProjectile getVariable 'AdvancedZipline_magazine';
            _rope = _target getVariable["AdvancedZipline_rope", objNull];

            deleteVehicle _target;
            deleteVehicle _attachedProjectile;
            deleteVehicle _rope;

            _caller addMagazine _magazine;

            hint "Rope collected";

            _caller switchMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
          }];

          _attachedProjectile addAction["Retract rope", {
            params["_target", "_caller", "_actionId", "_arguments"];

            _attachedProjectile = _target getVariable 'AdvancedZipline_attachedProjectile';
            _magazine = _attachedProjectile getVariable 'AdvancedZipline_magazine';
            _rope = _target getVariable["AdvancedZipline_rope", objNull];

            deleteVehicle _target;
            deleteVehicle _attachedProjectile;
            deleteVehicle _rope;

            _caller addMagazine _magazine;

            hint "Rope collected";

            _caller switchMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
          }];
        };
      }];
  } else {
    if ((_unit getVariable "AdvancedZiplineHasEH") && ((_newMagazine select 0) != "1Rnd_Zipline_shell")) then {
      _unit setVariable ["AdvancedZiplineHasEH", false, true];
      _unit removeEventHandler["FiredMan", _advancedZiplineFiredManEH];
    };
  };
}];
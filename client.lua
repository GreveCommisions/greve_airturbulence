local oldVeh = nil
local turbulence = 0.7
local roll = 0.4

local failureChance = 5

local AIRCRAFT_CLASSES = {
    [15] = "heli",
    [16] = "plane"
}

local function IsAircraft(veh)
    local class = GetVehicleClass(veh)
    return AIRCRAFT_CLASSES[class] ~= nil
end

CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)

            if veh ~= oldVeh then
                oldVeh = veh
                local class = GetVehicleClass(veh)

                if class == 15 then -- Helikopter
                    SetHeliTurbulenceScalar(veh, roll)
                    SetHelicopterRollPitchYawMult(veh, turbulence)
                    TaskVehicleTempAction(ped, veh, 7, math.random(300, 550)) -- venstre
                    Wait(500)
                    TaskVehicleTempAction(ped, veh, 8, math.random(300, 550)) -- høyre
                elseif class == 16 then -- Fly
                    SetPlaneTurbulenceMultiplier(veh, turbulence)
                    TaskVehicleTempAction(ped, veh, 7, math.random(300, 750)) -- venstre
                    Wait(500)
                    TaskVehicleTempAction(ped, veh, 8, math.random(300, 750)) -- høyre
                end
            end

            if IsAircraft(veh) and math.random(100) <= failureChance then
                SetVehicleEngineOn(veh, false, true, false)
            end
        else
            oldVeh = nil
        end
    end
end)

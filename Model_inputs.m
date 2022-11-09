%%%%%%%%%%%%%%%%%%%%%%%%%%   Code description   %%%%%%%%%%%%%%%%%%%%%%%%%%%


% This code contains the parameters for a simulink model of a thermal
% network of a household, considering: a PVT, TESS, a HP and a boiler.
% Created by: Celine van der Veen, Mitch Geraedts and Joel Alpízar-Castillo.
% TU Delft
% Version: 1.0

% Considerations:
%  - The model is designed to use the PVT as primary heat source, then the
%    TESS and, by last, either the HP or the boiler.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
%% House

% Walls (concrete)
lenHouse    = 15;             % House length [m]
widHouse    = 8;              % House width [m]
htHouse     = 2.6;            % House height [m]
LWall       = 0.25;           % Wall thickness [m]
wallDensity = 2400;           % Density [kg/m^3]
c_wall      = 750;            % Specific heat [J/kgK]
kWall       = 0.14;           % Thermal conductivity [W/mK]

% Windows (glass)
n1_window     = 3;            % Number of windows in room 1
n2_window     = 2;            % Number of windows in room 2
n3_window     = 2;            % Number of windows in room 3
n4_window     = 1;            % Number of windows in room 4
htWindows     = 1;            % Height of windows [m]
widWindows    = 1;            % Width of windows [m]
LWindow       = 0.004;        % Thickness of a single window pane [m]
LCavity       = 0.014;        % Thickness of the cavity between the double glass window [m]  
windowDensity = 2500;         % Density of glass [kg/m^3]
c_window      = 840;          % Specific heat of glass [J/kgK]
kWindow       = 0.8;          % Thermal conductivity of glass [W/mK]

% Roof (glass fiber)
pitRoof     = 40/180/pi;      % Roof pitch (40 deg)
LRoof       = 0.2;            % Roof thickness [m]
roofDensity = 2440;           % Density of glass fiber [kg/m^3]
c_roof      = 835;            % Specific heat of glass fiber [J/kgK]
kRoof       = 0.04;           % Thermal conductivity of glass fiber [W/mK]

% Air
c_air        = 1005.4;        % Specific heat of air at 273 K [J/kgK]
airDensity   = 1.025;         % Densiity of air at 293 K [kg/m^3]
kAir         = 0.0257;        % Thermal conductivity of air at 293 K [W/mK]

% Initial temperature
temp_initial = 20;            % [degrees C]
temp_initial_liquid = 75;     % [degrees C]

%% Radiators

% Exchange area with air
S_radiator1 = 5;              % [m^2]
S_radiator2 = 5;              % [m^2]
S_radiator3 = 5;              % [m^2]
S_radiator4 = 5;              % [m^2]

% Convective heat transfer coefficient radiator -> air in rooms
h_radiator1 = 100;            % [W/m^2K]
h_radiator2 = 100;            % [W/m^2K]
h_radiator3 = 100;            % [W/m^2K]
h_radiator4 = 100;            % [W/m^2K]

% Convective heat transfer coefficients [W/m^2K]
h_air_wall   = 0.9;%24;       % Indoor air -> walls, scaled to R-value of a C-label house
h_wall_atm   = 0.9;%34;       % Walls -> atmosphere, scaled to R-value of a C-label house
h_air_window = 25;            % Indoor air -> windows
h_window_atm = 32;            % Windows -> atmosphere
h_air_roof   = 12;            % Indoor air -> roof
h_roof_atm   = 38;            % Roof -> atmosphere

% Radiator pipe characteristics
d_radiatorpipe = 2.54e-2;     % Hydraulic diameter of the radiator pipe [m]
S_radiatorpipe = 5e-4;        % Cross-sectional area of the radiator pipe [m^2]

% Roof
roofArea = 2 * (widHouse/(2*cos(pitRoof))*lenHouse);

%% Rooms

% Room 1
area_window_room1 = n1_window * htWindows * widWindows;
area_wall_room1 = (lenHouse * 3/5 *htHouse + widHouse * 2/3 * htHouse) - area_window_room1;
area_roof_room1 = roofArea/4;

% Room 2
area_window_room2 = n2_window * htWindows * widWindows;
area_wall_room2 = (lenHouse * 3/5 * htHouse + widHouse / 3 * htHouse) - area_window_room2;
area_roof_room2 = roofArea/4;

% Room 3
area_window_room3 = n3_window * htWindows * widWindows;
area_wall_room3 = (lenHouse * 2/5 * htHouse + widHouse * 2/3 * htHouse) - area_window_room3;
area_roof_room3 = roofArea/4;

% Room 4
area_window_room4 = n4_window * htWindows * widWindows;
area_wall_room4 = (lenHouse * 2/5 * htHouse + widHouse / 3 * htHouse) - area_window_room4;
area_roof_room4 = roofArea/4;

%% Parameter structures -------------------------------
load = struct();
panel = struct();
pipe = struct();
tank = struct();
pumps = struct();

%% Load parameters ------------------------------------

load.R = 4.5;  %Resistance. With default parameters, 4.5 Ohm is approximately optimal for maximum electrical power extraction

%% Solar panel parameters

% Initial temperatures [K]
panel.initial.Tg0 = 295;            % Glass cover
panel.initial.Tpv0 = 295;           % PV cells
panel.initial.Te0 = 295;            % Heat exchanger
panel.initial.Tw0 = 295;            % Water in the tank
panel.initial.Tb0 = 295;            % Back cover

% Geometry
panel.geometry.Acell = 0.0225;      % Area of a cell, [m^2]
panel.geometry.Ncell = 72;          % Number of cells

% Optical properties
panel.optical.ng = 1.52;            % Refractive index ratio glass/air
panel.optical.absg = 0.2;           % Absorption coefficient of glass per unit length [1/m]
panel.optical.dg = 0.01;            % Thickness of glass cover [m]
panel.optical.rpv = 0.15;           % Reflection factor of PV cell

% Heat transfer properties
panel.heatTransfer.Ta = 295;        % Temperature of ambient air [K]
panel.heatTransfer.Tsky = 290;      % Temperature of sky (for radiative heat transfer) [K]

panel.heatTransfer.Mg = 4;          % Mass of glass cover [kg]
panel.heatTransfer.Mpv = 0.2;       % Mass of one PV cell [kg]
panel.heatTransfer.Me = 15;         % Mass of heat exchanger [kg]
panel.heatTransfer.Mb = 5;          % Mass of back cover [kg]
 
panel.heatTransfer.Cg = 800;        % Specific heat of glass [J/kg/K]
panel.heatTransfer.Cpv = 200;       % Specific heat of PV cell [J/kg/K]
panel.heatTransfer.Ce = 460;        % Specific heat of heat exchanger [J/kgK]
panel.heatTransfer.Cb = 400;        % Specific heat of back cover [J/kg/K]

panel.heatTransfer.epsg = 0.75;     % Emissivity of glass
panel.heatTransfer.epspv = 0.7;     % Emissivity of PV cell
        
panel.heatTransfer.hga = 10;        % Free convection coefficient between glass and ambient air [W/m^2/K]
panel.heatTransfer.hgpv = 20;       % Free convection coefficient between PV cells and glass [W/m^2K]
panel.heatTransfer.hba = 10;        % Free convection coefficient between back cover and ambient air [W/m^2K]
        
panel.heatTransfer.ke = 130;        % Thermal conductivity of heat exchanger [W/mK]
panel.heatTransfer.Le = 0.04;       % Thickness of heat exchanger [m]
panel.heatTransfer.kins = 0.1;      % Thermal conductivity of insulation layer [W/m/K]
panel.heatTransfer.Lins = 0.03;     % Thickness of insulation layer [m]

% PV cell electrical properties
panel.pv.Isc = 8.88;                % Short-circuit current, Isc [A]
panel.pv.Voc = 0.62;                % Open-circuit voltage, Voc [V]
panel.pv.Is  = 1e-6;                % Diode saturation current, Is [A]
panel.pv.Is2 = 0;                   % Diode saturation current, Is2 [A]
panel.pv.Iph0 = 8.88;               % Solar-generated current for measurements, Iph0 [A]
panel.pv.Ir0 = 1000;                % Irradiance used for measurements, Ir0 [W/m^2]
panel.pv.ec = 1.5;                  % Quality factor, N
panel.pv.N2 = 2;                    % Quality factor, N2
panel.pv.Rs = 0;                    % Series resistance, Rs [Ohm]
panel.pv.Rp = inf ;                 % Parallel resistance, Rp [Ohm]
panel.pv.TIPH1 = 0;                 % First order temperature coefficient for Iph, TIPH1 [1/K]
panel.pv.EG  = 1.11;                % Energy gap, EG [eV]
panel.pv.TXIS1 = 3;                 % Temperature exponent for Is, TXIS1
panel.pv.TXIS2 = 3;                 % Temperature exponent for Is2, TXIS2
panel.pv.TRS1 = 0;                  % Temperature exponent for Rs, TRS1
panel.pv.TRP1 = 0;                  % Temperature exponent for Rp, TRP1
panel.pv.Tmeas = 25;                % Measurement temperature [deg C]

%% Pipe parameters

pipe.length = 5;                    % Pipe length [m]
pipe.area = 0.0007;                 % Cross-sectional area [m^2]
pipe.Dh = 0.03;                     % Hydraulic diameter [m]
pipe.length_add = 1;                % Aggregate equivalent length of local resistances [m]
pipe.roughness = 15e-6;             % Internal surface absolute roughness [m]
pipe.Re_lam = 2000;                 % Laminar flow upper Reynolds number limit
pipe.Re_tur = 4000;                 % Turbulent flow lower Reynolds number limit
pipe.shape_factor = 64;             % Shape factor for laminar flow viscous friction
pipe.Nu_lam = 3.66;                 % Nusselt number for laminar flow heat transfer

%% Tank parameters

tank.Volmax = 4;                    % Maximum tank capacity [m^3]
tank.Atank = 1;                     % Tank cross-sectional area [m^2]
tank.Voltank0 = 0.9 * tank.Volmax;  % Initial volume in the tank [m^3]
tank.Ttank0 = 273.15 + 75;          % Initial temperature in the tank [K]
tank.Lins = 0.05;                   % Insulating layer thickness [m]
tank.kins = 0.1;                    % Thermal conductivity of insulation layer [W/mK]
tank.hta = 10;                      % Free convection coefficient between tank and ambient air [W/m^2K]

%% Pump flow input parameters

pumps.mdot_int = 0.0278; %0.02;              % Internal circuit mass flow rate [kg/s]
pumps.mdot_dem = 0.0278; %0.005;             % Demand mass flow rate (to the sink) [kg/s]
pumps.mdot_sup = 0.0278; %0.005;             % Supply mass flow rate (from the source) [kg/s]

%% Valves Parameters

valves.opening = 0.005;                      % Valves maximum opening [m]
valves.openingA = 1e-4;                      % Valves maximum opening area [m2]
valves.crossA = 0.01;                        % Valves cross-sectional area [m2]
valves.length = 2.5*valves.opening;          % Valves characteristic longitudinal length [m]

%% Solar variables

% Inclination angle
data1 = readtable('model_data.xlsx','HeaderLines',1); 
data2 = table2array(data1(:,3));            % Inclination angle data in hours for one year [rad]
a1 = transpose(data2);
b1 = repmat(a1,3600,1);
data3 = b1(:);                              % Inclination angle data in seconds, interpolated from hourly data
t_sec = 1:31536000;                         % Amount of seconds in a year
Inclination_angle = [t_sec' data3];         % Variable for Simulink

% Global irradiation
data4 = readtable('model_data.xlsx','HeaderLines',1); 
data5 = table2array(data1(:,4));            % Global irradiation data in hours for one year [W/m^2]
a2 = transpose(data5);
b2 = repmat(a2,3600,1);
data6 = b2(:);                              % Global irradiation data in seconds, interpolated from hourly data
Global_irradiation = [t_sec' data6];        % Variable for Simulink

%% Ambient temperature data

data = readtable('model_data.xlsx','HeaderLines',1); 
tempdata = table2array(data(:,2));          % Ambient temperature data in hours for one year [degrees C]
a = transpose(tempdata);
b = repmat(a,3600,1);
ambient_temp = b(:);                        % Ambient temperature data in seconds, interpolated from hourly data
T_ambient = [t_sec' ambient_temp];          % Variable for Simulink

%% Desired temperature data

l(1:6*3600) = 15;
l(6*3600:19*3600) = 18.1;
l(19*3600:24*3600) = 15;                    % Generating a setpoint indoor temperature profile for one day
temp = repmat(l',365,1);                    % Generating yearly data
T_desired = [t_sec' temp];                  % Variable for Simulink
T_indoor = T_desired(1,:);
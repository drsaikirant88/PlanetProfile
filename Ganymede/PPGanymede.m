function PPGanymede
%PPGanymede
Planet.name='Ganymede';
Planet.rho_kgm3 = 1936; % Schubert et al. 2004: 1942.0�4.8 claimed to be 4x more accurate than Anderson 1996 of 1936 � 22
Planet.R_m = 2634.1e3;
Planet.M_kg =1.4819e23;
Planet.gsurf_ms2 = 1.428; 
Planet.Tsurf_K = 110; 
Planet.Psurf_MPa = 0; 
Planet.Cmeasured = 0.3115;
Planet.Cuncertainty = 0.0028;
%note: Schubert et al. 2004 cite the Anderson C/MR2 as 0.3115�0.0028.  This
%is incorrect, as the value cited everywhere else is consistent with the
%Anderson et al. (1996) value of C/MR2=0.3105\pm0.0028 used here
Planet.FeCore=true;
Planet.rho_sil_withcore_kgm3 = 3250; %3250
Planet.xFeS = 0.25; %0.25
Planet.rhoFe = 8000; %8000
Planet.rhoFeS = 5150; %5150

Planet.Ocean.comp='MgSO4';
load L_Ice_MgSO4.mat
% rmfield(Planet.Ocean,'fnTfreeze_K');
Planet.Ocean.fnTfreeze_K = griddedInterpolant(PPg',wwg',TT');

%%  Interior constraints imposed in Vance et al. 2014
mSi = 28.0855; mS = 32.065; mFe = 55.845; mMg = 24.305;
xOl = 0.44; % percentage of olivine - Javoy (1995) - Fe/Si = 0.909 Mg/Si = 0.531, Mg# = 0.369
%mOl = 2*((1-0.369)*58.85+0.369*24.31)+28.0855+4*16=184.295
%mPx = 2*((1-0.369)*58.85+0.369*24.31+28.0855+3*16) =244.3805
xSi = (xOl+2*(1-xOl))*mSi/(xOl*184.295+(1-xOl)*244.3805); % mass fraction of sulfur in silicates
M_Earth_kg = 5.97e24;
xSiEarth = 0.1923; % Javoy in kg/kg in Exoplanets paper20052006-xSiSolar only in mole
xK = 1; %enrichment in K
Hrad0 = 24e12*xSi/xSiEarth/M_Earth_kg;

%% Mantle Heat
%cold case  
Planet.kr_mantle = 4; % rock conductivity (Cammarano et al. 2006, Table 4)
Planet.Qmantle = 1.3e11; 
Planet.QHmantle = 0;
%hot case Qm = 2.1e11+8.5e11; %W
% Qmantle = 1.3e11; 
% QHmantle = 8.5e11;

%% Seismic
Seismic.LOW_ICE_Q = 1; % divide Ice Q value by this number
Seismic.mantleEOS = 'ChondriteLL_Stx11.ext';
Seismic.QScore = 1e4;

%Attenuation Parameters Based on those Described in Cammarano et al. 2006
% ice I
Seismic.B_aniso_iceI = 0.56;
Seismic.gamma_aniso_iceI = 0.2;
Seismic.g_aniso_iceI = 22; %C2006
% ice II
Seismic.B_aniso_iceIII = 0.56;
Seismic.gamma_aniso_iceIII = 0.2;
Seismic.g_aniso_iceIII = 30; 
% ice III
Seismic.B_aniso_iceIII = 0.56;
Seismic.gamma_aniso_iceIII = 0.2;
Seismic.g_aniso_iceIII = 25; 
% ice V
Seismic.B_aniso_iceV = 0.56;
Seismic.gamma_aniso_iceI = 0.2;
Seismic.g_aniso_iceV = 27; 
% ice VI
Seismic.B_aniso_iceVI = 0.56;
Seismic.gamma_aniso_iceVI = 0.2;
Seismic.g_aniso_iceVI = 28; 
% mantle
Seismic.B_aniso_mantle = 0.56;
Seismic.gamma_aniso_mantle = 0.2;
Seismic.g_aniso_mantle = 30; %C2006

%% Model Parameters
Params.CALC_NEW =1;
Params.CALC_NEW_REFPROFILES=0;
Params.CALC_NEW_SOUNDSPEEDS=1;
Params.INCLUDE_ELECTRICAL_CONDUCTIVITY=1;
Params.foursubplots =1;
Params.HOLD = 0; % overlay previous run
Params.Legend=0;
Params.Pseafloor_MPa = 1800;
Params.LegendPosition = 'southeast';
Params.ylim = [925 1375];
Params.nsteps_iceI = 20;
Params.nsteps_ocean = 450; 
Params.nsteps_ref_rho = 30;
Params.nsteps_mantle = 100;
Params.nsteps_core = 10;
Params.savefigformat = 'epsc';
Params.wref=[0 5 10 15];
Params.colororder = 'mcbkgrm';
Params.Temps = [250 252.5 255 260 265 270 273];

%% Run the Calculation!
%Planet.Tb_K = [250 255 260 265 270]; % 15 Wt% temperatures at the bottom of the Ice Ih
% %Planet.Tb_K = [252.5 255 260 265 270]; %3 and 5 Wt% temperatures at the bottom of the Ice Ih
%  Planet.Ocean.w_ocean_pct=10; Planet.Tb_K = [252 255 260 265 270]; % 10 Wt% temperatures at the bottom of the Ice Ih
 Planet.Ocean.w_ocean_pct=10; Planet.Tb_K = [252  260  270]; % 10 Wt% temperatures at the bottom of the Ice Ih
PlanetProfile(Planet,Seismic,Params)

Params.CALC_NEW =1;
Params.CALC_NEW_SOUNDSPEEDS=1;
Params.INCLUDE_ELECTRICAL_CONDUCTIVITY=0;

Params.HOLD = 1; % overlay previous run
Planet.Ocean.w_ocean_pct=0;  Planet.Tb_K = [255  265  273]; % pure water, temperatures at the bottom of the Ice Ih
% Planet.Ocean.w_ocean_pct=0;  Planet.Tb_K = [255 260 265 270 273]; % pure water, temperatures at the bottom of the Ice Ih
PlanetProfile(Planet,Seismic,Params)
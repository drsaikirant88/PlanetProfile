function PlanetWedge(input)%filename or PPstruct)


%filename
if isstr(input)
%     loadFile and get Radii from density changes
elseif isstruct(input)
    r = input.r_m*1e-3;
    phase = input.phase;
    radii = getRadii(r,phase);
else
    radii = Test;
end

colors = getColors;

if  ~isempty(radii.R)
    IceI = wedgeR(radii.R); IceI.FaceColor=colors.IceI;
else
    error('R not found')
end
if  ~isempty(radii.Ocean)
    Ocean = wedgeR(radii.Ocean);Ocean.FaceColor = colors.Ocean;
end
if ~isempty(radii.IceIII)
    IceIII = wedgeR(radii.Rock);IceIII.FaceColor = colors.IceIII;
end
if ~isempty(radii.IceV)
    IceV = wedgeR(radii.IceV);IceV.FaceColor = colors.IceV;
end
if ~isempty(radii.IceVI)
    IceVI = wedgeR(radii.IceVI);IceVI.FaceColor = colors.IceVI;
end
if ~isempty(radii.IceVII)
    IceVII = wedgeR(radii.IceVII);IceVII.FaceColor = colors.IceVII;
end
if ~isempty(radii.Rock)
    Rock = wedgeR(radii.Rock);Rock.FaceColor = colors.Rock;
end
if ~isempty(radii.Core)
    Core =  wedgeR(radii.Core);Core.FaceColor = colors.Core;
end
set(gca,'XLim',radii.R/2*[-1 1],'YLim',[0 radii.R*1.02],'XTick',[],'XColor','none')


% here's the test case 
% eventually match radii and densities from planetprofile outputs
% either read in the PP output file, or send the data from PlanetProfile

function radii = Test
figure(1);clf; hold on
R = 2556;
radii.R = R;
radii.Ocean = R-100;
radii.III = R-200;
radii.V = R-300;
radii.VI = R-600;
radii.Rock = R-900;
radii.Core = 500;
radii.VII = [];


function P = wedgeR(R)
width = pi/7;
P = wedge(pi/2-width,pi/2+width,0,0,R);

function colors = getColors
colors.IceI = [150, 226, 241]/255;
colors.IceII = [3, 169, 252]/255;
colors.IceIII = [150, 226, 241]/255;
colors.IceV = [150, 226, 241]/255;
colors.IceVI =  [150, 226, 241]/255;
colors.IceVII =  [44, 115, 150]/255;
colors.Ocean = [100, 119, 186]/255;
colors.Rock = [101, 46, 11]/255;
colors.Core = [141, 122, 121]/255;

function radii = getRadii(r,phase)
radii.R = r(1);
radii.Core = r(min(find(phase>=100))); 
radii.Rock = r(min(find(phase>=50 & phase<100)));
radii.Ocean = r(min(find(phase==0)));
% radii.Ih = r(min(find(phase==1)));
radii.IceII = r(min(find(phase==2)));
radii.IceIII = r(min(find(phase==3)));
radii.IceV = r(min(find(phase==5)));
radii.IceVI = r(min(find(phase==6)));
radii.IceVII = r(min(find(phase==7)));


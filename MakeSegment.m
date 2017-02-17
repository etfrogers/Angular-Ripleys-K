
function strel = MakeSegment(angle, angleInc, rad) 
%angles in degrees

x = -rad:rad;
[xg,yg] = meshgrid(x,x);
[theta, rho] = cart2pol(xg,yg);
theta = 180+(theta*360/(2*pi));

ll = angle-angleInc/2;
ul = angle+angleInc/2;
assert(ul <= 360)
if ll < 0
    strel = ((theta>360+ll) | (theta < ul)) & (rho<rad);
else
    strel = (theta>ll) & (theta < ul) & (rho<rad);
end

strel = strel | rot90(strel,2);
strel = double(strel);
strel = strel./sum(strel(:));



figure(98)
imagesc(strel)
drawnow
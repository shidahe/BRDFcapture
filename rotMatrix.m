function rotm = rotMatrix(deg,ax)
% Rotation matrix for rotate couterclockwise
% facing positive
% 'deg' degrees 
% around axis 'ax'

theta = deg2rad(deg);
switch ax
    case 'x'
        rotm = [1 0 0;
            0 cos(theta) -sin(theta);
            0 sin(theta) cos(theta)];
        
    case 'y' 
        rotm = [cos(theta) 0 sin(theta);
            0 1 0;
            -sin(theta) 0 cos(theta)];
        
    case 'z'
        rotm = [cos(theta) -sin(theta) 0;
            sin(theta) cos(theta) 0;
            0 0 1];
  
    otherwise
        disp('unknown axis');
end
 
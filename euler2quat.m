function [w,x,y,z] = euler2quat(eul)

yaw = eul(1);
pitch = eul(2);
roll = eul(3);

heading = yaw;
attitude = pitch;
bank = roll;

c1 = cos(heading/2);
c2 = cos(attitude/2);
c3 = cos(bank/2);
s1 = sin(heading/2);
s2 = sin(attitude/2);
s3 = sin(bank/2);

w = c1*c2*c3 - s1*s2*s3;
x = s1*s2*c3 + c1*c2*s3;
y = s1*c2*c3 + c1*s2*s3;
z = c1*s2*c3 - s1*c2*s3;

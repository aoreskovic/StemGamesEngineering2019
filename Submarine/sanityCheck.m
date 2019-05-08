clear all

row = 1025
roc = 7850

t = 40/1000

l = 15
r = 1.5

S = 2*r^2*pi + 2*r*pi*l
V = r^2*pi * l


uzgon = V*row/1000
dolj = S*t*roc/1000*1.5


Scirc = r^2*pi

h = 1;
d = r-h
c = 2*r*sqrt(1-(d/r)^2);

fi = 2*atan(c/(2*d))

Scut = r^2*0.5*(fi-sin(fi))

ratio = Scut/Scirc
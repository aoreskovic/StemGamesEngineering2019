clear all
speed_kn = [0.25:0.25:20]
length_c = 18
radius_rb = 1.7

for i = 1:length(speed_kn)
    power(i) = sub_power(speed_kn(i), length_c, radius_rb)
end

plot(power, speed_kn)
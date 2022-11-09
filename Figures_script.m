T_atm = load('T_atm_pvt_1_tess_6.mat');
T_in = load('T_in_pvt_1_tess_6.mat');
T_set = load('T_set_pvt_1_tess_6.mat');
T_tank = load('T_tank_pvt_1_tess_6.mat');

% interv = [1:1:31536000];
T_atm2 = resample(T_atm.T_atm,[1:1:31536000]);
T_in2 = resample(T_in.T_in,[1:1:31536000]);
T_set2 = resample(T_set.T_set,[1:1:31536000]);



f1 = figure(1);
plot(T_atm.T_atm.Time, T_atm.T_atm.Data, 'b')
hold on
plot(T_set.T_set.Time, T_set.T_set.Data, 'g')
hold on
plot(T_in.T_in.Time, T_in.T_in.Data, 'r')
hold on
legend('Outdoor temperature', 'Desired indoor temperature', 'Real indoor temperature','Location','South')
ylabel('Temperature [°C]')
grid on
% 6051632
ylim([-10 30])
xlim([0,31536000])
xticks([2678400 5097600 7776000 10368000 13046400 15638400 18316800 20995200 23587200 26265600 28857600 31536000]);
xticklabels({'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})

f2 = figure(2);
plot(T_tank.T_tank.Time, T_tank.T_tank.Data)
ylim([40 100])
xlim([0,31536000])
xticks([2678400 5097600 7776000 10368000 13046400 15638400 18316800 20995200 23587200 26265600 28857600 31536000]);
xticklabels({'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'})
ylabel('State-of-Charge')
yticks([50 61.25 72.5 83.75 95]);
yticklabels({'0 %', '25 %','50 %','75 %', '100 %'})
grid on

f3 = figure(3);
subplot(2,2,1)
plot(T_atm2.Time(9590400:10108800), T_atm2.Data(9590400:10108800), 'b')
hold on
plot(T_set2.Time(9590400:10108800), T_set2.Data(9590400:10108800), 'g')
hold on
plot(T_in2.Time(9590400:10108800), T_in2.Data(9590400:10108800), 'r')
hold on
legend('Outdoor temperature', 'Desired indoor temperature', 'Real indoor temperature','Location','South')
ylabel('Temperature [°C]')
xticks([9590400 9676800 9763200 9849600 9936000 10022400 10108800]);
xticklabels({'21-04','22-04','23-04','24-04','25-04','26-04','27-04'})
xlim([T_in2.Time(9590400) T_in2.Time(10108800)])
ylim([-10 30])
grid on
title('Spring')

subplot(2,2,2)
plot(T_atm2.Time(17452800:17971200), T_atm2.Data(17452800:17971200), 'b')
hold on
plot(T_set2.Time(17452800:17971200), T_set2.Data(17452800:17971200), 'g')
hold on
plot(T_in2.Time(17452800:17971200), T_in2.Data(17452800:17971200), 'r')
hold on
legend('Outdoor temperature', 'Desired indoor temperature', 'Real indoor temperature','Location','South')
ylabel('Temperature [°C]')
xticks([17452800 17539200 17625600 17712000 17798400 17884800 17971200]);
xticklabels({'21-07','22-07','23-07','24-07','25-07','26-07','27-07'})
xlim([T_atm2.Time(17452800) T_atm2.Time(17971200)])
ylim([-10 30])
grid on
title('Summer')

subplot(2,2,3)
plot(T_atm2.Time(25401600:25920000), T_atm2.Data(25401600:25920000), 'b')
hold on
plot(T_set2.Time(25401600:25920000), T_set2.Data(25401600:25920000), 'g')
hold on
plot(T_in2.Time(25401600:25920000), T_in2.Data(25401600:25920000), 'r')
hold on
legend('Outdoor temperature', 'Desired indoor temperature', 'Real indoor temperature','Location','South')
ylabel('Temperature [°C]')
xticks([25401600 25488000 25574400 25660800 25747200 25833600 25920000]);
xticklabels({'21-10','22-10','23-10','24-10','25-10','26-10','27-10'})
xlim([T_atm2.Time(25401600) T_atm2.Time(25920000)])
ylim([-10 30])
grid on
title('Autum')

subplot(2,2,4)
plot(T_atm2.Time(1814400:2332800), T_atm2.Data(1814400:2332800), 'b')
hold on
plot(T_set2.Time(1814400:2332800), T_set2.Data(1814400:2332800), 'g')
hold on
plot(T_in2.Time(1814400:2332800), T_in2.Data(1814400:2332800), 'r')
hold on
legend('Outdoor temperature', 'Desired indoor temperature', 'Real indoor temperature','Location','South')
ylabel('Temperature [°C]')
xticks([1814400 1900800 1987200 2073600 2160000 2246400 2332800]);
xticklabels({'21-01','22-01','23-01','24-01','25-01','26-01','27-01'})
xlim([T_atm2.Time(1814400) T_atm2.Time(2332800)])
ylim([-10 30])
grid on
title('Winter')

f4 = figure(4);
subplot(2,2,1)
plot(T_atm2.Time(9590400:10108800), T_atm2.Data(9590400:10108800), 'b')
hold on
plot(T_set2.Time(9590400:10108800), T_set2.Data(9590400:10108800), 'g')
hold on
plot(T_in2.Time(9590400:10108800), T_in2.Data(25401600:25920000), 'r')
hold on
legend('Outdoor temperature', 'Desired indoor temperature', 'Real indoor temperature','Location','South')
ylabel('Temperature [°C]')
xticks([9590400 9676800 9763200 9849600 9936000 10022400 10108800]);
xticklabels({'21-04','22-04','23-04','24-04','25-04','26-04','27-04'})
xlim([T_in2.Time(9590400) T_in2.Time(10108800)])
ylim([-10 30])
grid on
title('Spring')

subplot(2,2,2)
plot(T_atm2.Time(17452800:17971200), T_atm2.Data(17452800:17971200), 'b')
hold on
plot(T_set2.Time(17452800:17971200), T_set2.Data(17452800:17971200), 'g')
hold on
plot(T_in2.Time(17452800:17971200), T_in2.Data(17452800:17971200), 'r')
hold on
legend('Outdoor temperature', 'Desired indoor temperature', 'Real indoor temperature','Location','South')
ylabel('Temperature [°C]')
xticks([17452800 17539200 17625600 17712000 17798400 17884800 17971200]);
xticklabels({'21-07','22-07','23-07','24-07','25-07','26-07','27-07'})
xlim([T_atm2.Time(17452800) T_atm2.Time(17971200)])
ylim([-10 30])
grid on
title('Summer')

subplot(2,2,3)
plot(T_atm2.Time(25401600:25920000), T_atm2.Data(25401600:25920000), 'b')
hold on
plot(T_set2.Time(25401600:25920000), T_set2.Data(25401600:25920000), 'g')
hold on
plot(T_in2.Time(25401600:25920000), T_in2.Data(25401600:25920000), 'r')
hold on
legend('Outdoor temperature', 'Desired indoor temperature', 'Real indoor temperature','Location','South')
ylabel('Temperature [°C]')
xticks([25401600 25488000 25574400 25660800 25747200 25833600 25920000]);
xticklabels({'21-10','22-10','23-10','24-10','25-10','26-10','27-10'})
xlim([T_atm2.Time(25401600) T_atm2.Time(25920000)])
ylim([-10 30])
grid on
title('Autum')

subplot(2,2,4)
plot(T_atm2.Time(1814400:2332800), T_atm2.Data(1814400:2332800), 'b')
hold on
plot(T_set2.Time(1814400:2332800), T_set2.Data(1814400:2332800), 'g')
hold on
plot(T_in2.Time(1814400:2332800), T_in2.Data(25401600:25920000), 'r')
hold on
legend('Outdoor temperature', 'Desired indoor temperature', 'Real indoor temperature','Location','South')
ylabel('Temperature [°C]')
xticks([1814400 1900800 1987200 2073600 2160000 2246400 2332800]);
xticklabels({'21-01','22-01','23-01','24-01','25-01','26-01','27-01'})
xlim([T_atm2.Time(1814400) T_atm2.Time(2332800)])
ylim([-10 30])
grid on
title('Winter')
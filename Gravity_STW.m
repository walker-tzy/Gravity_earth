clear 
clc
close all
tic
data=xlsread('PREM_1s_1.xlsx'); %将数据csv转为xlsx格式，然后导入数据,数据已经进行调整（排序）
data_1=xlsread('STW105.xlsx');%将数据csv转为xlsx格式，然后导入数据,数据已经进行调整（排序）
R=6371;
G=6.67259e-11;
%PREM模型
r=zeros(1,1);
Rho=zeros(1,1);
g_earth_in=zeros(1,1);%预分配neicun
g_earth_out=zeros(1,1);
V_earth_in=zeros(1,1);
V_earth_out=zeros(1,1);
M=zeros(1,1);
for i=1:length(data)   %利用循环将二维矩阵分两列赋值给半径和密度
    r(i,1)=data(i,1);
    Rho(i,1)=data(i,2).*1000;
end
M(1,1)=(4/3).*pi.*Rho(1,1).*r(1,1)^3; %计算质量初始值
for i=2:length(data) %迭代求出每个半径值所对应的质量
    M(i,1)=M(i-1,1)+(4/3).*pi.*Rho(i,1).*(r(i,1)^3-r(i-1,1)^3);
end
%内部引力场初始值
 g_earth_in(1,1)=(4/3).*pi.*G.*Rho(1,1).*r(1,1)*1000;
 
 %循环求内部引力场
for i=2:length(Rho) 
 g_earth_in(i,1)=G.*M(i,1).*1000/r(i,1).^2;
end
%求解内部引力势
V_out=zeros(1,1);
V_out(199,1)=0;
k=198;
while k>0  %外部球壳
    V_out(k,1)=10^(6).*G.*Rho(k,1).*(4.*pi).*r(k,1).*(r(k+1,1)-r(k,1))+V_out(k+1,1);
    k=k-1;
end
for i=1:length(r) %将内部引力势看成两部分，外部球壳+内部球体
     V_earth_in(i,1)=G.*M(i,1).*10^(6)/r(i,1)+V_out(i,1);
end
r_1=6371:6371*2;
%外部引力场和外部引力势
for i=1:length(r_1)   
g_earth_out(i,1)=G.*M(199,1)*1000/r_1(1,i)^2;
V_earth_out(i,1)=G.*M(199,1)*10^(6)/r_1(1,i);
end


%STW105模型
r_0=zeros(1,1);
Rho_0=zeros(1,1);
g_earth_in_0=zeros(1,1);%预分配neicun
g_earth_out_0=zeros(1,1);
V_earth_in_0=zeros(1,1);
V_earth_out_0=zeros(1,1);
M_0=zeros(1,1);


for i=1:length(data_1)   %利用循环将二维矩阵分两列赋值给半径和密度
    r_0(i,1)=data_1(i,1)/1000;
    Rho_0(i,1)=data_1(i,2);
end
M_0(1,1)=(4/3).*pi.*Rho_0(1,1).*r_0(1,1)^3; %计算质量初始值
for i=2:length(data_1) %迭代求出每个半径值所对应的质量
    M_0(i,1)=M_0(i-1,1)+(4/3).*pi.*Rho_0(i,1).*(r_0(i,1)^3-r_0(i-1,1)^3);
end
%内部引力场初始值
 g_earth_in_0(1,1)=(4/3).*pi.*G.*Rho_0(1,1).*r_0(1,1)*1000;
 
 %循环求内部引力场
for i=2:length(Rho_0) 
 g_earth_in_0(i,1)=G.*M_0(i,1)*1000/r_0(i,1).^2;
end
%求解内部引力势
V_out_0=zeros(1,1);
V_out_0(750,1)=0;
k=749;
while k>0  %外部球壳
    V_out_0(k,1)=10^(6).*G.*Rho_0(k,1).*(4.*pi).*r_0(k,1).*(r_0(k+1,1)-r_0(k,1))+V_out_0(k+1,1);
    k=k-1;
end
for i=1:length(r_0) %将内部引力势看成两部分，外部球壳+内部球体
     V_earth_in_0(i,1)=G.*M_0(i,1).*10^(6)/r_0(i,1)+V_out_0(i,1);
end
r_2=6371:6371*2;
%外部引力场和外部引力势
for i=1:length(r_2)   
g_earth_out_0(i,1)=G.*M_0(750,1)*1000/r_2(1,i)^2;
V_earth_out_0(i,1)=G.*M_0(750,1)*10^(6)/r_2(1,i);
end


figure(1);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]);
h1=plot(g_earth_in_0,r_0);          %绘制地球内部引力关系图
hold on
h2=plot(g_earth_in,r); 
xlabel('Gravity of interior(m/s^2)');  
set(gca,'Ygrid','on');%以半径轴为准画网格
set(gca,'YTick',[0:500:7000]);
 ylabel('Radius(km)');
set(h1,'LineStyle','-','LineWidth',1.1)%对应第一条曲线的线性y1
set(h2,'LineStyle','--','LineWidth',1.1)%对应第二条曲线的线性y2 
lgd=legend('g(内部)STW105模型','g(内部)PREM模型','Location','west');
lgd.FontSize = 11;
legend('boxoff');
hold on
Ax1=axes('YAxisLocation','right','Color','none','XColor','none','YLim',[0 7000]); %用坐标叠加绘制右侧半径坐标轴
ylabel(Ax1,'Radius(km)');
set(gca,'YTick',[0:500:7000]);

figure(2);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]);
h1=plot(g_earth_out_0,r_2);          %绘制地球外部引力位关系图
hold on
h2=plot(g_earth_out,r_1); 
xlabel('External gravitational potential');  
set(gca,'Ygrid','on');%以半径轴为准画网格
set(gca,'YTick',[6000:500:13000]);
 ylabel('Radius(km)');
set(h1,'LineStyle','-','LineWidth',1.1)%对应第一条曲线的线性y1
set(h2,'LineStyle','--','LineWidth',1.1)%对应第二条曲线的线性y2 
lgd=legend('g(外部)STW105模型','g(外部)PREM模型','Location','east');
lgd.FontSize = 11;
legend('boxoff');
hold on
Ax1=axes('YAxisLocation','right','Color','none','XColor','none','YLim',[6000 13000]); %用坐标叠加绘制右侧半径坐标轴
ylabel(Ax1,'Radius(km)');
set(gca,'YTick',[6000:500:13000]);

figure(3);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]);
h1=plot(V_earth_in_0,r_0);          %绘制地球内部引力位关系图
hold on
h2=plot(V_earth_in,r); 
xlabel('Internal gravitational potential');  
set(gca,'Ygrid','on');%以半径轴为准画网格
set(gca,'YTick',[0:500:7000]);
 ylabel('Radius(km)');
set(h1,'LineStyle','-','LineWidth',1.1)%对应第一条曲线的线性y1
set(h2,'LineStyle','-','LineWidth',1.1)%对应第二条曲线的线性y2 
lgd=legend('V(内部)STW105模型','V(内部)PREM模型','Location','west');
lgd.FontSize = 11;
legend('boxoff');
hold on
Ax1=axes('YAxisLocation','right','Color','none','XColor','none','YLim',[0 7000]); %用坐标叠加绘制右侧半径坐标轴
ylabel(Ax1,'Radius(km)');
set(gca,'YTick',[0:500:7000]);

figure(4);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]);
h1=plot(V_earth_out_0,r_2);          %绘制地球外部引力位关系图
hold on
h2=plot(V_earth_out,r_1); 
xlabel('External gravitational potential');  
set(gca,'Ygrid','on');%以半径轴为准画网格
set(gca,'YTick',[6000:500:13000]);
 ylabel('Height(km)');
set(h1,'LineStyle','-','LineWidth',1.1)%对应第一条曲线的线性y1
set(h2,'LineStyle','-','LineWidth',1.1)%对应第二条曲线的线性y2 
lgd=legend('V(外部)STW105模型','V(外部)PREM模型','Location','northeast');
lgd.FontSize = 11;
legend('boxoff');
hold on
Ax1=axes('YAxisLocation','right','Color','none','XColor','none','YLim',[6000 13000]); %用坐标叠加绘制右侧半径坐标轴
ylabel(Ax1,'Height(km)');
set(gca,'YTick',[6000:500:13000]);
 toc


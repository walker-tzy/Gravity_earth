clear 
clc
close all
tic
data=xlsread('PREM_1s_1.xlsx'); %将数据csv转为xlsx格式，然后导入数据,数据顺序已经进行调整
%data=xlsread('STW105.xlsx');
R=6371;
G=6.67259e-11;
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

figure(1);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]); %对figure绘图区大小控制
[ax,h1,h2]=plotyy(r,Rho,r,g_earth_in);          %先绘制半径和密度、引力关系图
set(gca,'box','off','Ytick',[]);  %该段代码解决了上方刻度重叠的问题
set(ax(1),'ylim',[0,16000],'ytick',[0:2000:16000],'XAxisLocation','bottom'); %右轴的范围
set(ax(2),'ylim',[0,11],'ytick',[0:1:11],'XAxisLocation','bottom'); %左轴的范围 
view(90,-90);%第一个参数表示沿z顺时针旋转n度，第二个为沿y
set(get(ax(1),'Ylabel'),'String','Density(kg/m^3)') %函数句柄，左侧y轴名称
set(get(ax(2),'Ylabel'),'String','Gravity of interior(m/s^2)') %右侧y轴名称
set(gca,'Xgrid','on');%以半径轴为准画网格
xlabel('Radius(km)');
set(gca,'XTick',[0:500:7000]); %半径坐标范围
set(h1,'LineStyle','-','LineWidth',1.3)%对应第一条曲线
set(h2,'LineStyle','--','LineWidth',1.3)%对应第二条曲线
lgd=legend('Rho(密度)','g(内部)','Location','west');%添加图例，将图例放置在西侧
lgd.FontSize = 12;                      %设置图例字体大小
legend('boxoff');                       %去掉图例外边框
hold on
Ax1=axes('XAxisLocation','top','Color','none','YColor','none','XLim',[0 7000]); %用透明坐标叠加，为了绘制右侧半径轴
xlabel(Ax1,'Radius(km)');
view(90,-90);  %原始值为view（0,90），图像旋转
set(gca,'XTick',[0:500:7000]); %右侧半径轴刻度修改

figure(2);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]);
[ax,h1,h2]=plotyy(r,V_earth_in,r,g_earth_in);          %绘制地球内部引力位与引力关系图
set(gca,'box','off','Ytick',[]); 
set(ax(1),'ylim',[0,1.2.*10^(8)],'ytick',[0:10^(7):1.2*10^(8)]); %右轴的范围
set(ax(2),'ylim',[0,11],'ytick',[0:1:11]); %左轴的范围
view(90,-90);
set(get(ax(1),'Ylabel'),'String','Internal gravitational potential') %左侧y轴 
set(get(ax(2),'Ylabel'),'String','Gravity of interior(m/s^2)') %右侧y轴
set(gca,'Xgrid','on');%以半径轴为准画网格
set(gca,'XTick',[0:500:7000]);
xlabel('Radius(km)');
set(h1,'LineStyle','-','LineWidth',1.3)%对应第一条曲线的线性y1
set(h2,'LineStyle','--','LineWidth',1.3)%对应第二条曲线的线性y2 
lgd=legend('V(内部)','g(内部)','Location','west');
lgd.FontSize = 12;
legend('boxoff');
hold on
Ax1=axes('XAxisLocation','top','Color','none','YColor','none','XLim',[0 7000]); %用坐标叠加绘制右侧半径坐标轴
xlabel(Ax1,'Radius(km)');
view(90,-90);
set(gca,'XTick',[0:500:7000]);

figure(3);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]);
[ax,h1,h2]=plotyy(r_1,V_earth_out,r_1,g_earth_out);          %绘制地球外部引力位与引力关系图
set(gca,'box','off','Ytick',[]); 
set(ax(1),'ylim',[0,1.2.*10^(8)],'ytick',[0:10^(7):1.2*10^(8)]); %右轴的范围
set(ax(2),'ylim',[0,11],'ytick',[0:1:11]); %左轴的范围
view(90,-90);
set(get(ax(1),'Ylabel'),'String','External gravitational potential') %左侧y轴 
set(get(ax(2),'Ylabel'),'String','Gravity of External(m/s^2)') %右侧y轴
set(gca,'Xgrid','on');%以半径轴为准画网格
xlabel('Height(km)');
set(gca,'XTick',[6000:500:13000]);
set(h1,'LineStyle','-','LineWidth',1.3)%对应第一条曲线的线性y1
set(h2,'LineStyle','--','LineWidth',1.3)%对应第二条曲线的线性y2 
lgd=legend('V(外部)','g(外部)','Location','west');
lgd.FontSize = 12;
legend('boxoff');
hold on
Ax1=axes('XAxisLocation','top','Color','none','YColor','none','XLim',[6000 13000]); %用坐标叠加绘制右侧半径坐标轴
xlabel(Ax1,'Height(km)');
view(90,-90);
set(gca,'XTick',[6000:500:13000]);

toc



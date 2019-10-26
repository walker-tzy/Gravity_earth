clear 
clc
close all
tic
data=xlsread('PREM_1s_1.xlsx'); %������csvתΪxlsx��ʽ��Ȼ��������,�����Ѿ����е���������
data_1=xlsread('STW105.xlsx');%������csvתΪxlsx��ʽ��Ȼ��������,�����Ѿ����е���������
R=6371;
G=6.67259e-11;
%PREMģ��
r=zeros(1,1);
Rho=zeros(1,1);
g_earth_in=zeros(1,1);%Ԥ����neicun
g_earth_out=zeros(1,1);
V_earth_in=zeros(1,1);
V_earth_out=zeros(1,1);
M=zeros(1,1);
for i=1:length(data)   %����ѭ������ά��������и�ֵ���뾶���ܶ�
    r(i,1)=data(i,1);
    Rho(i,1)=data(i,2).*1000;
end
M(1,1)=(4/3).*pi.*Rho(1,1).*r(1,1)^3; %����������ʼֵ
for i=2:length(data) %�������ÿ���뾶ֵ����Ӧ������
    M(i,1)=M(i-1,1)+(4/3).*pi.*Rho(i,1).*(r(i,1)^3-r(i-1,1)^3);
end
%�ڲ���������ʼֵ
 g_earth_in(1,1)=(4/3).*pi.*G.*Rho(1,1).*r(1,1)*1000;
 
 %ѭ�����ڲ�������
for i=2:length(Rho) 
 g_earth_in(i,1)=G.*M(i,1).*1000/r(i,1).^2;
end
%����ڲ�������
V_out=zeros(1,1);
V_out(199,1)=0;
k=198;
while k>0  %�ⲿ���
    V_out(k,1)=10^(6).*G.*Rho(k,1).*(4.*pi).*r(k,1).*(r(k+1,1)-r(k,1))+V_out(k+1,1);
    k=k-1;
end
for i=1:length(r) %���ڲ������ƿ��������֣��ⲿ���+�ڲ�����
     V_earth_in(i,1)=G.*M(i,1).*10^(6)/r(i,1)+V_out(i,1);
end
r_1=6371:6371*2;
%�ⲿ���������ⲿ������
for i=1:length(r_1)   
g_earth_out(i,1)=G.*M(199,1)*1000/r_1(1,i)^2;
V_earth_out(i,1)=G.*M(199,1)*10^(6)/r_1(1,i);
end


%STW105ģ��
r_0=zeros(1,1);
Rho_0=zeros(1,1);
g_earth_in_0=zeros(1,1);%Ԥ����neicun
g_earth_out_0=zeros(1,1);
V_earth_in_0=zeros(1,1);
V_earth_out_0=zeros(1,1);
M_0=zeros(1,1);


for i=1:length(data_1)   %����ѭ������ά��������и�ֵ���뾶���ܶ�
    r_0(i,1)=data_1(i,1)/1000;
    Rho_0(i,1)=data_1(i,2);
end
M_0(1,1)=(4/3).*pi.*Rho_0(1,1).*r_0(1,1)^3; %����������ʼֵ
for i=2:length(data_1) %�������ÿ���뾶ֵ����Ӧ������
    M_0(i,1)=M_0(i-1,1)+(4/3).*pi.*Rho_0(i,1).*(r_0(i,1)^3-r_0(i-1,1)^3);
end
%�ڲ���������ʼֵ
 g_earth_in_0(1,1)=(4/3).*pi.*G.*Rho_0(1,1).*r_0(1,1)*1000;
 
 %ѭ�����ڲ�������
for i=2:length(Rho_0) 
 g_earth_in_0(i,1)=G.*M_0(i,1)*1000/r_0(i,1).^2;
end
%����ڲ�������
V_out_0=zeros(1,1);
V_out_0(750,1)=0;
k=749;
while k>0  %�ⲿ���
    V_out_0(k,1)=10^(6).*G.*Rho_0(k,1).*(4.*pi).*r_0(k,1).*(r_0(k+1,1)-r_0(k,1))+V_out_0(k+1,1);
    k=k-1;
end
for i=1:length(r_0) %���ڲ������ƿ��������֣��ⲿ���+�ڲ�����
     V_earth_in_0(i,1)=G.*M_0(i,1).*10^(6)/r_0(i,1)+V_out_0(i,1);
end
r_2=6371:6371*2;
%�ⲿ���������ⲿ������
for i=1:length(r_2)   
g_earth_out_0(i,1)=G.*M_0(750,1)*1000/r_2(1,i)^2;
V_earth_out_0(i,1)=G.*M_0(750,1)*10^(6)/r_2(1,i);
end


figure(1);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]);
h1=plot(g_earth_in_0,r_0);          %���Ƶ����ڲ�������ϵͼ
hold on
h2=plot(g_earth_in,r); 
xlabel('Gravity of interior(m/s^2)');  
set(gca,'Ygrid','on');%�԰뾶��Ϊ׼������
set(gca,'YTick',[0:500:7000]);
 ylabel('Radius(km)');
set(h1,'LineStyle','-','LineWidth',1.1)%��Ӧ��һ�����ߵ�����y1
set(h2,'LineStyle','--','LineWidth',1.1)%��Ӧ�ڶ������ߵ�����y2 
lgd=legend('g(�ڲ�)STW105ģ��','g(�ڲ�)PREMģ��','Location','west');
lgd.FontSize = 11;
legend('boxoff');
hold on
Ax1=axes('YAxisLocation','right','Color','none','XColor','none','YLim',[0 7000]); %��������ӻ����Ҳ�뾶������
ylabel(Ax1,'Radius(km)');
set(gca,'YTick',[0:500:7000]);

figure(2);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]);
h1=plot(g_earth_out_0,r_2);          %���Ƶ����ⲿ����λ��ϵͼ
hold on
h2=plot(g_earth_out,r_1); 
xlabel('External gravitational potential');  
set(gca,'Ygrid','on');%�԰뾶��Ϊ׼������
set(gca,'YTick',[6000:500:13000]);
 ylabel('Radius(km)');
set(h1,'LineStyle','-','LineWidth',1.1)%��Ӧ��һ�����ߵ�����y1
set(h2,'LineStyle','--','LineWidth',1.1)%��Ӧ�ڶ������ߵ�����y2 
lgd=legend('g(�ⲿ)STW105ģ��','g(�ⲿ)PREMģ��','Location','east');
lgd.FontSize = 11;
legend('boxoff');
hold on
Ax1=axes('YAxisLocation','right','Color','none','XColor','none','YLim',[6000 13000]); %��������ӻ����Ҳ�뾶������
ylabel(Ax1,'Radius(km)');
set(gca,'YTick',[6000:500:13000]);

figure(3);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]);
h1=plot(V_earth_in_0,r_0);          %���Ƶ����ڲ�����λ��ϵͼ
hold on
h2=plot(V_earth_in,r); 
xlabel('Internal gravitational potential');  
set(gca,'Ygrid','on');%�԰뾶��Ϊ׼������
set(gca,'YTick',[0:500:7000]);
 ylabel('Radius(km)');
set(h1,'LineStyle','-','LineWidth',1.1)%��Ӧ��һ�����ߵ�����y1
set(h2,'LineStyle','-','LineWidth',1.1)%��Ӧ�ڶ������ߵ�����y2 
lgd=legend('V(�ڲ�)STW105ģ��','V(�ڲ�)PREMģ��','Location','west');
lgd.FontSize = 11;
legend('boxoff');
hold on
Ax1=axes('YAxisLocation','right','Color','none','XColor','none','YLim',[0 7000]); %��������ӻ����Ҳ�뾶������
ylabel(Ax1,'Radius(km)');
set(gca,'YTick',[0:500:7000]);

figure(4);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]);
h1=plot(V_earth_out_0,r_2);          %���Ƶ����ⲿ����λ��ϵͼ
hold on
h2=plot(V_earth_out,r_1); 
xlabel('External gravitational potential');  
set(gca,'Ygrid','on');%�԰뾶��Ϊ׼������
set(gca,'YTick',[6000:500:13000]);
 ylabel('Height(km)');
set(h1,'LineStyle','-','LineWidth',1.1)%��Ӧ��һ�����ߵ�����y1
set(h2,'LineStyle','-','LineWidth',1.1)%��Ӧ�ڶ������ߵ�����y2 
lgd=legend('V(�ⲿ)STW105ģ��','V(�ⲿ)PREMģ��','Location','northeast');
lgd.FontSize = 11;
legend('boxoff');
hold on
Ax1=axes('YAxisLocation','right','Color','none','XColor','none','YLim',[6000 13000]); %��������ӻ����Ҳ�뾶������
ylabel(Ax1,'Height(km)');
set(gca,'YTick',[6000:500:13000]);
 toc


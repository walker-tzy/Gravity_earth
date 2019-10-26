clear 
clc
close all
tic
data=xlsread('PREM_1s_1.xlsx'); %������csvתΪxlsx��ʽ��Ȼ��������,����˳���Ѿ����е���
%data=xlsread('STW105.xlsx');
R=6371;
G=6.67259e-11;
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

figure(1);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]); %��figure��ͼ����С����
[ax,h1,h2]=plotyy(r,Rho,r,g_earth_in);          %�Ȼ��ư뾶���ܶȡ�������ϵͼ
set(gca,'box','off','Ytick',[]);  %�öδ��������Ϸ��̶��ص�������
set(ax(1),'ylim',[0,16000],'ytick',[0:2000:16000],'XAxisLocation','bottom'); %����ķ�Χ
set(ax(2),'ylim',[0,11],'ytick',[0:1:11],'XAxisLocation','bottom'); %����ķ�Χ 
view(90,-90);%��һ��������ʾ��z˳ʱ����תn�ȣ��ڶ���Ϊ��y
set(get(ax(1),'Ylabel'),'String','Density(kg/m^3)') %������������y������
set(get(ax(2),'Ylabel'),'String','Gravity of interior(m/s^2)') %�Ҳ�y������
set(gca,'Xgrid','on');%�԰뾶��Ϊ׼������
xlabel('Radius(km)');
set(gca,'XTick',[0:500:7000]); %�뾶���귶Χ
set(h1,'LineStyle','-','LineWidth',1.3)%��Ӧ��һ������
set(h2,'LineStyle','--','LineWidth',1.3)%��Ӧ�ڶ�������
lgd=legend('Rho(�ܶ�)','g(�ڲ�)','Location','west');%���ͼ������ͼ������������
lgd.FontSize = 12;                      %����ͼ�������С
legend('boxoff');                       %ȥ��ͼ����߿�
hold on
Ax1=axes('XAxisLocation','top','Color','none','YColor','none','XLim',[0 7000]); %��͸��������ӣ�Ϊ�˻����Ҳ�뾶��
xlabel(Ax1,'Radius(km)');
view(90,-90);  %ԭʼֵΪview��0,90����ͼ����ת
set(gca,'XTick',[0:500:7000]); %�Ҳ�뾶��̶��޸�

figure(2);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]);
[ax,h1,h2]=plotyy(r,V_earth_in,r,g_earth_in);          %���Ƶ����ڲ�����λ��������ϵͼ
set(gca,'box','off','Ytick',[]); 
set(ax(1),'ylim',[0,1.2.*10^(8)],'ytick',[0:10^(7):1.2*10^(8)]); %����ķ�Χ
set(ax(2),'ylim',[0,11],'ytick',[0:1:11]); %����ķ�Χ
view(90,-90);
set(get(ax(1),'Ylabel'),'String','Internal gravitational potential') %���y�� 
set(get(ax(2),'Ylabel'),'String','Gravity of interior(m/s^2)') %�Ҳ�y��
set(gca,'Xgrid','on');%�԰뾶��Ϊ׼������
set(gca,'XTick',[0:500:7000]);
xlabel('Radius(km)');
set(h1,'LineStyle','-','LineWidth',1.3)%��Ӧ��һ�����ߵ�����y1
set(h2,'LineStyle','--','LineWidth',1.3)%��Ӧ�ڶ������ߵ�����y2 
lgd=legend('V(�ڲ�)','g(�ڲ�)','Location','west');
lgd.FontSize = 12;
legend('boxoff');
hold on
Ax1=axes('XAxisLocation','top','Color','none','YColor','none','XLim',[0 7000]); %��������ӻ����Ҳ�뾶������
xlabel(Ax1,'Radius(km)');
view(90,-90);
set(gca,'XTick',[0:500:7000]);

figure(3);
set(gcf,'unit','centimeters','position',[10.5,4.5,20,15.5]);
[ax,h1,h2]=plotyy(r_1,V_earth_out,r_1,g_earth_out);          %���Ƶ����ⲿ����λ��������ϵͼ
set(gca,'box','off','Ytick',[]); 
set(ax(1),'ylim',[0,1.2.*10^(8)],'ytick',[0:10^(7):1.2*10^(8)]); %����ķ�Χ
set(ax(2),'ylim',[0,11],'ytick',[0:1:11]); %����ķ�Χ
view(90,-90);
set(get(ax(1),'Ylabel'),'String','External gravitational potential') %���y�� 
set(get(ax(2),'Ylabel'),'String','Gravity of External(m/s^2)') %�Ҳ�y��
set(gca,'Xgrid','on');%�԰뾶��Ϊ׼������
xlabel('Height(km)');
set(gca,'XTick',[6000:500:13000]);
set(h1,'LineStyle','-','LineWidth',1.3)%��Ӧ��һ�����ߵ�����y1
set(h2,'LineStyle','--','LineWidth',1.3)%��Ӧ�ڶ������ߵ�����y2 
lgd=legend('V(�ⲿ)','g(�ⲿ)','Location','west');
lgd.FontSize = 12;
legend('boxoff');
hold on
Ax1=axes('XAxisLocation','top','Color','none','YColor','none','XLim',[6000 13000]); %��������ӻ����Ҳ�뾶������
xlabel(Ax1,'Height(km)');
view(90,-90);
set(gca,'XTick',[6000:500:13000]);

toc



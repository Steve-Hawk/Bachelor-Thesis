%% units
G     = 6.674e-11;       % m^3/(kg s^2)
c     = 299792458 ;      % m/s
M_sun = 1.98892e30 ;     % kg
mu0   = 1.2566370614e-6; % Newton/Ampere^2
Kb    = 1.3806488e-23 ;  % Joule/K
Mparsec = 3.08567758e19; % km 

CU_to_km   = M_sun*G/(1000*c*c) ;                 % km
CU_to_ms   = (1000*M_sun*G/(c*c*c));              % ms
CU_to_s    = (M_sun*G/(c*c*c))      ;             % s
CU_to_dens = c*c*c*c*c*c / (G*G*G * M_sun*M_sun); % kg/m^3

CU_to_energy    = M_sun*c*c  ;        % kg m^2/s^2

%% positions data of black holes
% positions info of the different simulations
%structure time x y radius and omega
filename = ('../BBH-b3/positions-b3.csv');
b3_p = positions_f(filename);
filename = ('../BBH-b4/positions-b4.csv');
b4_p = positions_f(filename);
filename = ('../BBH-b5/positions-b5.csv');
b5_p = positions_f(filename);
filename = ('../BBH-b6/positions-b6.csv');
b6_p = positions_f(filename);
filename = ('../BBH-b7/positions-b7.csv');
b7_p = positions_f(filename);
filename = ('../BBH-b10/positions-b10.csv');
b10_p = positions_f(filename);

%% GW data
% distance from the detector = r
% structure t h_p h_x psi4_r psi4_i
filename = '../BBH-b3/mp_psi4_l2_m2_r110.00.asc';
r = 110;
b3_h = gw_strain(filename,r);

filename = '../BBH-b4/mp_psi4_l2_m2_r115.00.asc';
r = 115;
b4_h = gw_strain(filename,r);

filename = '../BBH-b5/mp_psi4_l2_m2_r115.00.asc';
r = 115;
b5_h = gw_strain(filename,r);

filename = '../BBH-b6/mp_psi4_l2_m2_r115.00.asc';
r = 115;
b6_h = gw_strain(filename,r);

filename = '../BBH-b7/mp_psi4_l2_m2_r115.00.asc';
r = 115;
b7_h = gw_strain(filename,r);

filename = '../BBH-b10/mp_psi4_l2_m2_r115.00.asc';
r = 115;
b10_h = gw_strain(filename,r);


%% GW analysis
figure();
hold on;
plot_f('\psi_4','t [M_\odot]','\psi_4',16)
plot(t,psi4_r,'.');
plot(t,psi4_i,'.');
s= {['Re{\psi_4}'],...
    ['Im{\psi_4}']};
legend_f(s);


figure();
hold on;
plot(t,h_p);
plot(t,h_x);
grid on;
plot_f('Metric perturbation h','t [M_\odot]','h',16)
s= {['h_+'],...
    ['h_x']};
legend_f(s);


% energy balance
% variable in the integral over the angles proportional to the energy
%int_var = diff(new_h_x).^2 + diff(new_h_p).^2;
%figure();
%plot(t(2:end,1),1e5*int_var.*r^2/(16*pi),'.')

%% Fourier trabsform
t = b7_h(:,1);                   
Fs = 1./abs(b7_h(1,1)-b7_h(2,1));            % Sampling frequency
y = fft(b7_h(:,2));     
w_f = ((0:length(y)-1)*Fs/length(y))*(2*pi); % omega fourier

figure();
plot(w_f,abs(y));
%%

figure();
plot(Fs*t,b7_h(:,2))
Y = fft(b7_h(:,2));
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%% BINARY NEUTRON star
% considerazioni
% andamento 1/r che misuriamo
%2 omega 
%

d = gw_strain('mp_Psi4_l2_m2_r300.00.asc');
% moltiplicare per 110 e dividere per 100Mpc
x = importdata('mp_Psi4_l2_m2_r300.00.asc', ' ');
% time in solar masses
t = x(:,1);
% sepctrum
figure();
plot(t,fft(d(:,1)));
hold on;
plot(t,fft(d(:,2)));

% energy balance
% variable in the integral over the angles proportional to the energy
int_var = diff(d(:,1)).^2 + diff(d(:,2)).^2;
figure();
plot(t(2:end),int_var,'.')



%% wave polarizations plot 
%angle parameter of the ring
theta = 0:0.01:2*pi;
%frequency of the wave
omega = 0.1;
subplot(1,5,1), 
plot(cos(theta),sin(theta),'.');
pbaspect([1 1 1]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
xlim([-2 2]);
ylim([-2 2]);

a = pi/6;


for t=1:1:12
    subplot(1,12,t), 
plot(cos(theta) .* (1 + 0.5.*cos(t*a)),sin(theta) .* (1 - 0.5.*cos(a*t)),'.');
pbaspect([1 1 1]);
%set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
%set(gcf,'color','w')
set(gca,'Visible','off')
set(gca,'xtick',[]);
set(gca,'ytick',[]);
xlim([-2 2]);
ylim([-2 2]);
end
%[ax4,h3]=suplabel('+ polarization' ,'t');
%set(h3,'FontSize',30)
close all

for t=1:1:12
    subplot(1,12,t), 
plot(cos(theta) + sin(theta).*0.5.*cos(t*a),sin(theta) + cos(theta).* 0.5.*cos(a*t),'.');
pbaspect([1 1 1]);
set(gca,'Visible','off')
set(gca,'xtick',[]);
set(gca,'ytick',[]);
xlim([-2 2]);
ylim([-2 2]);
end



%% wave polarizations animated
%angle parameter of the ring
theta = 0:0.03:2*pi;
%frequency of the wave
omega = 0.1;
% t time

n=1;
ii=1;
for t=500:3000
    % plus polarization
    h_plus = 0.5*cos(omega.*t);
    h_times = 0.5*cos(omega.*t + pi/2);
    X = cos(theta) .* (1 + 0.5.*h_plus) + sin(theta).*(0.5.*h_times);
    Y = sin(theta) .* (1 - 0.5.*h_plus) + cos(theta).*(0.5.*h_times);

    CM = jet(120); % n+10 
    plot(X,Y,'.','color',CM(n,:));%,ii.*ones(size(X))
    grid on;
    %set(gca,'Visible','off')
    pbaspect([1 1 1]);
    set(gca,'zticklabel',[])
    set(gca,'xticklabel',[])
    set(gca,'yticklabel',[])
    xlabel('x');
    ylabel('y');
    zlabel('t');
    %set(gca,'xtick',[])
    %set(gca,'ytick',[])
    %set(gca,'ztick',[])
    xlim([-2 2]);
    ylim([-2 2]);
    pause(0.1)
    
    %hold on;
    n=n+1;
    %clf;
    ii = ii + 0.2;
end


%% wave polarization for BBH
theta = 0:0.03:2*pi;

% t time
for n=10:300:57001%t=0.1:3000
    % plus polarization
    h_plus = 1000.*new_h_p(n);%0.5.*cos(omega.*t);
    h_times = 1000.*new_h_x(n);%0.5.*cos(omega.*t - pi/2);
    X = cos(theta) .* (1 + 0.5.*h_plus) + sin(theta).*(0.5.*h_times);
    Y = sin(theta) .* (1 - 0.5.*h_plus) + cos(theta).*(0.5.*h_times);    
    
    subplot(2,1,1), plot(X,Y,'.');
    xlim([-2 2]);
    ylim([-2 2]);
    s= {['time ',num2str(t(n)),]};
    legend_f(s);
    
    subplot(2,1,2), 
    hold on;
    plot(t,new_h_p,'r');
    plot(t,new_h_x,'b');
    plot(t(n),new_h_p(n),'or','MarkerSize',5,'MarkerFaceColor','m') ;   
    plot(t(n),new_h_x(n),'or','MarkerSize',5,'MarkerFaceColor','m');

    
    pause(0.1)
    clf;
end
%s= {['m_1 = ',num2str(m1),' m_e'],...
%    ['m_2 = ',num2str(m2),' m_e'],...
%    ['m_3 = ',num2str(m3),' m_e']};

%% theoretical binary sources
%angular frequency
omeg=2*pi;
%radius
R=1;

% t time
time =0:0.01:2;
for n=1:length(time)
    
    
    plot(cos(omeg .*t(n)),sin(omeg.*t(n)),'.');
    hold on;
    plot(-cos(omeg .*t(n)),-sin(omeg.*t(n)),'.');
    xlim([-2 2]);
    ylim([-2 2]);
    pause(0.5)
    clf;
end
%% 3D animation
x=-100:1:100;
y=x;
for omeg =0:0.1:2*pi
for n=1:length(x)
    for m = 1:length(y)
        z(n,m)=(60.*cos(2.*atan2(y(m),x(n)+0.0001)- omeg +0.2.*sqrt(x(n).^2+y(m).^2))./(20 + sqrt(x(n).^2+y(m).^2)));
    end
end

surface(z);
xlim([0 200]);
ylim([0 200]);
shading interp


pause(0.5)
clf
end
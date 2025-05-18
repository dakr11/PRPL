%
clear all, close all
%% load experimental data
shot = 44664;%46304...radial; %46315...vertical; 46316...vertical; 46319...radial;46278...radial;46279...radial;46276...vertical;46280...radial; %44664(first session);
label_stab = 'vertical';
data_MSL  = readtable([num2str(shot), '_MSL.csv']);
data_stab = readtable([num2str(shot), '_stab.csv']);

if strcmp(label_stab,'vertical')
    MSL_interp = interp1(data_MSL.Time_ms_, data_MSL.B_z*1e-3, data_stab.Time);
    B_label = 'B_{hor}';
else
    MSL_interp = interp1(data_MSL.Time_ms_, data_MSL.B_x*1e-3, data_stab.Time);
    B_label = 'B_{vert}';
end

MSL_interp = smooth(MSL_interp,51,'moving');

t = data_stab.Time*1e-3; % ms -> s

% figure, hold on
% plot(t,MSL_interp)
% plot(t,MSL_interp_s)
% hold off
%% Identify model parameters - needed due to new stabilization!!

% Measured Data
dt = diff(t);   % time difference
u  = data_stab.(label_stab);     % Input signal  = Current in PFC
y  = MSL_interp;             % Output signal = Measured Magnetic Field
R_msl = 0.0;                 % R coorrdinate of the probe position
Z_msl = 0.0;                 % Z coorrdinate of the probe position

approach = 1;   % select method used for model identification

switch approach
    case 1
        data = iddata(y, u, dt(1)); 
        % Estimate the Model
        nx = 2;                             % number of states (nx-order system)
        sys_est = ssest(data, nx, 'DisturbanceModel','none');    % estimates
        % Display the estimated model
        disp(sys_est);
        % Compare the estimated model with the data
        figure,
        compare(data, sys_est);

    case 2
        nx = 2; % number of states (nx-order system)
        % Create initial state-space model
        K = zeros(nx,1);
        
        init_sys = idss(A, B, C, D, K, 'Ts',dt(1));
        
        % Set estimation options to use the initial model
        opt = ssestOptions('InitialState', 'estimate', 'Focus', 'prediction');
        % opt.InitialStateModel = init_sys;
        
        % Estimate the state-space model
        sys_est = ssest(data, nx, opt,'DisturbanceModel','none');
        
        % Display the estimated model
        disp(sys_est);
        
        % Optionally, plot the model response compared to the data
        figure,compare(data, sys_est);
end

%% Use estimated ss model
sys_new = ss(sys_est);

[y, t, x] = lsim(sys_est, u, t);

% Time constants
tau_cs = abs(1/sys_est.A(1,1));
tau_vv = abs(1/sys_est.A(2,2));

fprintf(['Copper shell time constant: tau_cs=',num2str(tau_cs*1e3),' ms\n'])
fprintf(['Vacuum vessel time constant: tau_vv=',num2str(tau_vv*1e3),' ms\n'])

%%
% Plot the results
figure('Name', 'New_model','Position',[200,200,650,500]);
sgtitle(['#', num2str(shot)],'fontweight','bold')
subplot(2, 1, 1);
plot(t, u, 'DisplayName',[label_stab,' stabilization'], 'LineWidth', 1.8);
title('Input Signal'), legend('Location','southeast');
xlabel('Time [s]'); ylabel('I [A]'); %xlim([0,0.02])
set(gca,'FontWeight','bold')

subplot(2, 1, 2); hold on
plot(t, y, 'DisplayName',['Modeled signal',', \tau_{cs}=',num2str(round(tau_cs*1e3,2)),'ms',', \tau_{vv}=',num2str(round(tau_vv*1e3,2)),'ms'], 'LineWidth', 1.8);
plot(t, MSL_interp, 'DisplayName','Measured signal', 'LineWidth', 1.8);
title('System Response');
leg = legend('show'); 
title(leg, ['MSL at (r,z)=(',num2str(R_msl),',',num2str(Z_msl),')']);
xlabel('Time [s]'); 
ylabel([B_label,' [T]']); 
set(gca,'FontWeight','bold')

%% Plot states
num_states = size(x, 2);  % Get number of states

figure;
sgtitle(['#', num2str(shot)])
subplot(2, 1, 1);
plot(t, x(:,1), 'DisplayName','Copper Shell','LineWidth',1.8);
ylabel('\xi_{cs} = \int I_{cs}dt'), legend
set(gca, 'FontWeight','bold')
subplot(2, 1, 2);
plot(t, x(:,2), 'DisplayName','Vacuum Vessel', 'LineWidth',1.8);
ylabel('\xi_{vv} = \int I_{vv}dt'), xlabel('Time [s]'), legend;
set(gca, 'FontWeight','bold')


%% Model from Adela's thesis
try_AK_model = false;
if try_AK_model
    b1 = 5e5;
    b2 = 1e-4;
    k1 = 2.3989e-9;
    k2 = 9.25;
    k3 = 1.52e-6;
    
    tau_cs = 15.561e-3;
    tau_v  = 0.98e-3;
    
    A = [-1/tau_cs     1.0042e-7;...
          1.7084e-7  -1/tau_v];
    
    B = [-b1; -b2];
    C = [k1  k2];
    D = k3;
    
    % state-space model
    sys = ss(A,B,C,D);
    
    % data_Irog  = readtable('36234_oldDischarge_Irog.csv');
    % t_I = data_Irog.Var1;
    % I_stab = data_Irog.Var2;
    
    t_I = data_stab.Time/1e3;
    I_stab= data_stab.(label_stab);

    [y, t, x] = lsim(sys, I_stab, t_I);
    
    % Plot the results
    figure('Name','Model_AKthesis');
    subplot(2, 1, 1);
    plot(t, I_stab);
    title('Input Signal');
    xlabel('Time [s]');
    ylabel('I(t)');
    % xlim([0,0.02])
    subplot(2, 1, 2);
    plot(t, y);
    title('System Response');
    xlabel('Time [s]');
    ylabel('B(t) [T]');
    % xlim([0,0.02])

end
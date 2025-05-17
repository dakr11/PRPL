%

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
    
    % A = [-64.6808     1.0042e-7;...
    %       1.7084e-7  -1.0255e3];
    
    B = [-b1; -b2];
    C = [k1  k2];
    D = k3;
    
    % state-space model
    sys = ss(A,B,C,D);
    
    data_Irog  = readtable('36234_oldDischarge_Irog.csv');
    
    t_I = data_Irog.Var1;
    u = data_Irog.Var2;
    
    [y, t, x] = lsim(sys, u, t_I);
    
    % Plot the results
    figure('Name','Model_AKthesis');
    subplot(2, 1, 1);
    plot(t, u);
    title('Input Signal');
    xlabel('Time [s]');
    ylabel('I(t)');
    xlim([0,0.02])
    subplot(2, 1, 2);
    plot(t, y);
    title('System Response');
    xlabel('Time [s]');
    ylabel('B(t) [T]');
    xlim([0,0.02])

end
%% load experimental data
shot = 44664;
label_stab = 'vertical';
data_MSL  = readtable([num2str(shot), '_MSL.csv']);
data_stab = readtable([num2str(shot), '_stab.csv']);

MSL_interp = interp1(data_MSL.Time_ms_, data_MSL.B_z*1e-3, data_stab.Time);

MSL_interp = smooth(MSL_interp,51,'moving');

t = data_stab.Time*1e-3;

% figure, hold on
% plot(t,MSL_interp)
% plot(t,MSL_interp_s)
% hold off
%% Identify model parameters - needed due to new stabilization!!

% Measured Data
dt = diff(t);   % time difference
u  = data_stab.vertical;     % Input signal  = Current in PFC
y  = MSL_interp;             % Output signal = Measured Magnetic Field
R_msl = 0.4;                 % R coorrdinate of the probe position
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

% Plot the results
figure('Name', 'New_model');
sgtitle(['#', num2str(shot)])
subplot(2, 1, 1);
plot(t, u, 'DisplayName',['Current in ', label_stab,' stabilization'], 'LineWidth', 1.8);
title('Input Signal'), legend('Location','southeast');
xlabel('Time [s]'); ylabel('I [A]'); xlim([0,0.02])
set(gca,'FontWeight','bold')

subplot(2, 1, 2); hold on
plot(t, y, 'DisplayName','Modeled signal', 'LineWidth', 1.8);
plot(t, MSL_interp, 'DisplayName','Measured signal', 'LineWidth', 1.8);
title('System Response');
leg = legend('show'); 
title(leg, ['MSL at (',num2str(R_msl),',',num2str(Z_msl),')']);
xlabel('Time [s]'); ylabel('B [T]'); xlim([0,0.02])
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
ylabel('\xi_{vv} = \int I_{vv}dt'), xlabel('Time (s)'), legend;
set(gca, 'FontWeight','bold')


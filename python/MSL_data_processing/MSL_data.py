#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 20 11:54:01 2024

@author: dani
"""
# %% import libraries

import pandas as pd
import numpy as np
from scipy import constants as c
from scipy import integrate, signal, interpolate
import requests


# %% 

def smooth(data, win=11): 
    smoothed_data = signal.savgol_filter(data, win, 3)
    return smoothed_data

def integrate_mc(mc, identifier):
    '''Integrate the voltage induced in the Mirnov coils to obtain the magnetic field [mT]'''
    const = 1/(3.8e-03)
    mc -= mc.loc[:0.9e-3].mean()  #remove offset
    mc = pd.Series(integrate.cumtrapz(mc, x=mc.index, initial=0) * const,
                    index=mc.index*1000, name= 'B'+identifier[1:])    #integration
    return mc*1e3 

def integrate_sc(mc, identifier):
    '''Integrate the voltage induced in the Saddle coil to obtain the vertical component of the magnetic field [mT]'''
    const = 1/(0.83)
    mc -= mc.loc[:0.9e-3].mean()  #remove offset
    mc = pd.Series(integrate.cumtrapz(mc, x=mc.index, initial=0) * const,
                    index=mc.index*1000, name= 'B'+identifier[1:])    #integration
    return mc*1e3 

def get_closest_value(data, value, arg = False):
    if arg:
        return np.abs(data - value).argmin()
    else:
        return data[np.abs(data - value).argmin()]
    
# %%

class MSL_data: 
    def __init__(self, shot_no, date):
        self.shot_no = shot_no  # shot_no
        self.date    = date     # date
        
        
        self.load_shot_info()
        
        self.load_MSL_data()
        
    def load_mc(self):
        '''Load signals from Mirnov coils'''
        
        mirnov_url   = lambda identifier: f'http://golem.fjfi.cvut.cz/shots/{self.shot_no}/Diagnostics/LimiterMirnovCoils/{identifier}.csv'
        self.df_mirnov = pd.concat([integrate_mc(pd.read_csv(mirnov_url(sig), names = ['Time', sig], index_col = 'Time').squeeze(), sig) 
                               for sig in ['U_mc1','U_mc5','U_mc9','U_mc13']], axis = 'columns')
        return 

    def load_stab(self, quadr = False):
        '''Currents in the stabilization coils'''
        if not quadr:
            stab_url     = lambda position: f'http://golem.fjfi.cvut.cz/shots/{self.shot_no}/Infrastructure/PositionStabilization/I^{position}_currclamp.csv' #!!! zrejme prohozene kanaly pro U <-> I!!!
            
            cI = 1/0.05
            self.df_stab = pd.concat([pd.read_csv(stab_url(pos), names = [pos])*cI for pos in ['radial','vertical']], axis = 'columns')
            # get oscilloscope's time
            dt = float(requests.get(f'http://golem.fjfi.cvut.cz/shotdir/{self.shot_no}/Devices/Oscilloscopes/RigolMSO5204-a/ScopeSetup/XINC').text)*1e6
            self.df_stab.index = pd.Series(np.linspace(0, dt, self.df_stab.shape[0])).rename('Time')
            # smooth signals
            self.df_stab['radial']   = smooth(self.df_stab['radial'])
            self.df_stab['vertical'] = smooth(self.df_stab['vertical'])
        else:
            stab_url     = lambda position: f'http://golem.fjfi.cvut.cz/shots/{self.shot_no}/Infrastructure/PositionStabilization/I^{position}_currclamp.csv' #!!! zrejme prohozene kanaly pro U <-> I!!!
            # quadr_url    = f'https://golem.fjfi.cvut.cz/shotdir/{self.shot_no}/Devices/Oscilloscopes/RigolMSO5104-a/I%5evertical_currclamp.csv'
            quadr_url    = f'https://golem.fjfi.cvut.cz/shotdir/{self.shot_no}/Devices/Oscilloscopes/RigolMSO5104-a/U%5evertical_fg.csv'
            
            cI = 1/0.05
            cI_quadr = 1/0.01
            self.df_stab = pd.concat([pd.read_csv(url, names = [name])*const for url, name, const in zip([stab_url('radial'), quadr_url],['radial','Inner Quadrupole'], [cI,cI_quadr])], axis = 'columns')
            # get oscilloscope's time
            dt = float(requests.get(f'http://golem.fjfi.cvut.cz/shotdir/{self.shot_no}/Devices/Oscilloscopes/RigolMSO5204-a/ScopeSetup/XINC').text)*1e6
            self.df_stab.index = pd.Series(np.linspace(0, dt, self.df_stab.shape[0])).rename('Time')
            # smooth signals
            # self.df_stab['radial']   = smooth(self.df_stab['radial'])
            # self.df_stab['Inner Quadrupole'] = smooth(self.df_stab['Inner Quadrupole'])
        
        return

    def load_BD(self):
        ''' Standard diagnostics'''
        BD = ['U_loop', 'Bt', 'Ich']
        self.df_BD = pd.concat([pd.read_csv(f'http://golem.fjfi.cvut.cz/shots/{self.shot_no}/Diagnostics/BasicDiagnostics/Results/{sig}.csv', 
                                    names = ['Time', sig], index_col=0) for sig in BD], axis = 'columns')
        return 
    
    def load_shot_info(self):
        '''Load some basics info on shot'''
        
        # Ubt, Ucd
        params_url = f'http://golem.fjfi.cvut.cz/shots/{self.shot_no}/Production/Parameters/infrastructure.bt_ecd'
        params = requests.get(params_url).text.split(',')
        
        # Assume same order accross all the shots
        self.Ubt = int(params[0].split('=')[1])
        self.Ucd = int(params[3].split('=')[1])
        
        # Stab waveform
        
        return 

    def load_saddle(self):
        '''Load signals from saddle coils'''
        
        saddle_url = f'http://golem.fjfi.cvut.cz/shots/{self.shot_no}/Diagnostics/FastSpectrometry/U_HeI.csv'
        
        # Saddle coil
        self.df_saddle = integrate_mc(pd.read_csv(saddle_url, names = ['Time', 'B_z'], index_col = 'Time').squeeze(), 'B_z') 
        
        return 

    def load_MSL_data(self):
        '''Load signals from MSL probe'''

        pf = f'/home/dani/Documents/jaderka/Master/PRPL/experiments/{self.date}/MSL_data/'
        trigger_pos = 2.56
        
        self.data_MSL = pd.read_csv(f'{pf}{self.shot_no}.txt', skiprows = 22, sep = ';', 
                           names = ['Time [ms]', 'B_x', 'B_y', 'B_z'], 
                           decimal = ',', usecols = [0, 2, 3, 4], index_col = 0)
        self.data_MSL = self.data_MSL.replace('\t', ' ', regex=True)
        # remove offset + convert to float + remove data before trigger
        self.data_MSL = self.data_MSL.astype(np.float64)
        for cl in self.data_MSL.columns:            
            self.data_MSL[cl]  = smooth(self.data_MSL[cl],51)
            self.data_MSL[cl] -= self.data_MSL[cl].loc[0.:1].mean()
        self.data_MSL.index -= trigger_pos
        return 


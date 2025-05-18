#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 17 18:10:55 2024

@author: dani
"""


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import constants as c
from scipy import integrate, signal, interpolate
import requests


from MSL_data import *
from scipy import constants as c
import requests


# %%
def get_data_scal(shot_no, identifier):
    r = requests.get(f'http://golem.fjfi.cvut.cz/shots/{shot_no}/Diagnostics/PlasmaDetection/Results/{identifier}')
    return float(r.content)

def get_closest_value(data, value):
    return data[np.abs(data - value).argmin()]

def interp_signal(df,signal):
    interp = interpolate.interp1d(signal.index, signal, bounds_error=False)
    return interp(df.index)  # mm to m    

shot_no     = 38925 
vac_shot_no = 38922


R0 = 0.4   # [m]
a0 = 85e-3 # [m]

BD = ['U_loop', 'Bt', 'Ip']

df = pd.concat([pd.read_csv(f'http://golem.fjfi.cvut.cz/shots/{shot_no}/Diagnostics/BasicDiagnostics/Results/{sig}.csv', 
                            names = ['Time', sig], index_col=0) for sig in BD], axis = 'columns')

plasma_start = float(requests.get(f'http://golem.fjfi.cvut.cz/shots/{shot_no}/Diagnostics/BasicDiagnostics/Results/t_plasma_start').text)
plasma_end = float(requests.get(f'http://golem.fjfi.cvut.cz/shots/{shot_no}/Diagnostics/BasicDiagnostics/Results/t_plasma_end').text)


df['Bp'] = c.mu_0 * df['Ip']*1e3/(2 * a0 * np.pi)

# %% 
shot_defBt = 46298
data_defBt = MSL_data(shot_defBt, '2024_09_17') 
 
shot_defRadStab = 46304
data_defRadStab = MSL_data(shot_defRadStab, '2024_09_17') 

# %%
fig, ax = plt.subplots(figsize=(6,4))
df['Ip'].plot(label = f'$I_p$ [kA], (#{shot_no})', color='tab:red')
(df['Bp']*1e3).plot(label = '$B_p$ [mT]',color ='tab:purple')

ax.plot(data_defBt.data_MSL['B_x'].abs(), label=f'$|B_{{z,B_t}}|$ [mT], default $B_t$, Ubt ={data_defBt.Ubt} (#{shot_defBt})', color='tab:orange')
ax.plot(data_defRadStab.data_MSL['B_x'],'tab:red', label = f'default RadStab (#{shot_defRadStab})',color='tab:blue')
ax.set(xlabel='Time [ms]',ylabel='a.u.', xlim=(0,plasma_end))
# ax.set(xlabel='Time [ms]', ylabel='$B_z$ [mT]', xlim=(0,plasma_end))
ax.legend(); ax.grid()
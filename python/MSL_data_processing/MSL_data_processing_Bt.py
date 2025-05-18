#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 20 10:37:19 2024

@author: dani
"""

# %% import libraries

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import constants as c
from scipy import integrate, signal, interpolate
import requests


from MSL_data import *

# %%
# try:
#     del data_MSL
# except:
#     pass    

# shot_no = 46319
# date = '2024_09_17'

# data = MSL_data(shot_no, date)

# data.load_stab(True)

# data.load_mc()

# %% Default orientation of Bt
plot_Bt_CW = False
if plot_Bt_CW:
    r0_Bt = np.arange(46296,46301)
    
    rHFS_Bt = np.arange(46271,46276)
    
    rLFS_Bt = np.arange(46331,46335)
    
    rHFS_B = pd.DataFrame(data=np.zeros((np.size(rHFS_Bt),3)),columns=['B_x','B_y','B_z'], index = rHFS_Bt)
    for ii in range(np.size(rHFS_Bt)):
        try:
            del data
        except:
            pass
        data = MSL_data(rHFS_Bt[ii], '2024_09_16')
        rHFS_B.iloc[ii] = (data.data_MSL.abs().max()).values # Bx,By,Bz
    
        
    r0_B = pd.DataFrame(data=np.zeros((np.size(r0_Bt),3)),columns=['B_x','B_y','B_z'], index = r0_Bt)
    for ii in range(np.size(r0_Bt)):
        try:
            del data
        except:
            pass
        data = MSL_data(r0_Bt[ii], '2024_09_17')
        r0_B.iloc[ii] = (data.data_MSL.abs().max()).values # Bx,By,Bz
        
        
    rLFS_B = pd.DataFrame(data=np.zeros((np.size(rLFS_Bt),3)),columns=['B_x','B_y','B_z'], index = rLFS_Bt)
    for ii in range(np.size(rLFS_Bt)):
        try:
            del data
        except:
            pass
        data = MSL_data(rLFS_Bt[ii], '2024_09_17')
        rLFS_B.iloc[ii] = (data.data_MSL.abs().max()).values # Bx,By,Bz
      
            
    fig, ax = plt.subplots()
    ax.scatter(r0_B['B_y'],r0_B['B_x'],label='center: r=0, z=0')
    ax.scatter(rHFS_B['B_y'],rHFS_B['B_x'],label='HFS: r=-85, z=0')
    ax.scatter(rLFS_B['B_y'],rLFS_B['B_x'],label='LFS: r=85, z=0')
    ax.set(xlabel='$B_t$ [mT]', ylabel='$B_z$ [mT]')
    plt.title('Default orientation of $B_t$ (ACW)')
    ax.legend(), ax.grid()

#%% Different orientation of Bt
plot_Bt_ACW = False
if plot_Bt_ACW:
    r0_Bt_CW = np.arange(46307,46312)
    
    rLFS_Bt_CW = np.arange(46321,46326)
        
    r0_B_CW = pd.DataFrame(data=np.zeros((np.size(r0_Bt_CW),3)),columns=['B_x','B_y','B_z'], index = r0_Bt_CW)
    for ii in range(np.size(r0_Bt_CW)):
        try:
            del data
        except:
            pass
        data = MSL_data(r0_Bt[ii], '2024_09_17')
        r0_B_CW.iloc[ii] = (data.data_MSL.abs().max()).values # Bx,By,Bz
        
        
    rLFS_B_CW = pd.DataFrame(data=np.zeros((np.size(rLFS_Bt_CW),3)),columns=['B_x','B_y','B_z'], index = rLFS_Bt_CW)
    for ii in range(np.size(rLFS_Bt_CW)):
        try:
            del data
        except:
            pass
        data = MSL_data(rLFS_Bt_CW[ii], '2024_09_17')
        rLFS_B_CW.iloc[ii] = (data.data_MSL.abs().max()).values # Bx,By,Bz
           
    fig, ax = plt.subplots()
    ax.scatter(r0_B_CW['B_y'],r0_B_CW['B_x'],label='center: r=0, z=0')
    ax.scatter(rLFS_B_CW['B_y'],rLFS_B_CW['B_x'],label='LFS: r=85, z=0')
    ax.set(xlabel='$B_t$ [mT]', ylabel='$B_z$ [mT]')
    plt.title('Different orientation of $B_t$ (CW)')
    ax.legend(), ax.grid()
    
#%%    
plot_CW_ACW = False    
if plot_CW_ACW:
    fig, ax = plt.subplots()
    ax.scatter(r0_B['B_y'],r0_B['B_x'],label='ACW, center: r=0, z=0', marker ='o', color='None',edgecolors='tab:blue',alpha=0.8, linewidth=1.6)
    ax.scatter(rHFS_B['B_y'],rHFS_B['B_x'],label='ACW, HFS: r=-85, z=0',color='None', edgecolors='tab:red',linewidth=1.6)
    ax.scatter(rLFS_B['B_y'],rLFS_B['B_x'],label='ACW, LFS: r=85, z=0', color='None', edgecolors = 'tab:green',linewidth=1.6)
    ax.scatter(r0_B_CW['B_y'],r0_B_CW['B_x'],label='CW, center: r=0, z=0', marker='x',color='tab:blue',linewidth=1.6)
    ax.scatter(rLFS_B_CW['B_y'],rLFS_B_CW['B_x'],label='CW, LFS: r=85, z=0',marker = 'x', color='tab:green', linewidth=1.6)
    ax.set(xlabel='$B_t$ [mT]', ylabel='$B_z$ [mT]')
    plt.title('Different orientation of $B_t$')
    ax.legend(), ax.grid()
    
# %%
plot_radStab_Bt = True
if plot_radStab_Bt:
    shot_defBt = 46299
    data_defBt = MSL_data(shot_defBt, '2024_09_17') 
    
    shot_defRadStab = 46304
    data_defRadStab = MSL_data(shot_defRadStab, '2024_09_17') 
    
    fig, ax = plt.subplots()
    plt.title('MSL measurement, r=0 mm (center)')
    ax.plot(data_defBt.data_MSL['B_x'],'tab:blue', label=f'default $B_t$, Ubt ={data_defBt.Ubt} (#{shot_defBt})')
    ax.plot(data_defRadStab.data_MSL['B_x'],'tab:red', label = f'default RadStab (#{shot_defRadStab})')
    ax.set(xlabel='Time [ms]', ylabel='$B_z$ [mT]', xlim=(0,90))
    ax.legend(); ax.grid()

# %%
plot_vertStab_Bt = True
if plot_vertStab_Bt:
    shot_defBt = 46299
    data_defBt = MSL_data(shot_defBt, '2024_09_17') 
    
    shot_defVertStab = 46315
    data_defVertStab = MSL_data(shot_defVertStab, '2024_09_17') 
    
    fig, ax = plt.subplots()
    plt.title('MSL measurement, r=0 mm (center)')
    ax.plot(data_defBt.data_MSL['B_z'],'tab:blue', label=f'default $B_t$, Ubt ={data_defBt.Ubt} (#{shot_defBt})')
    ax.plot(data_defVertStab.data_MSL['B_z'],'tab:red', label = f'default VertStab (#{shot_defVertStab})')
    ax.set(xlabel='Time [ms]', ylabel='$B_r$ [mT]', xlim=(0,90))
    ax.legend(); ax.grid()
    
# %%
plot_Bt_ACW_CW = False
if plot_Bt_ACW_CW:
    shot_defBt = 46307#46296
    data_defBt = MSL_data(shot_defBt, '2024_09_17') 
    
    shot_defBt2 = 46321#46331
    data_defBt2 = MSL_data(shot_defBt2, '2024_09_17') 
    
    # shot_defBt3 = 46271
    # data_defBt3 = MSL_data(shot_defBt3, '2024_09_16') 
    
    fig, ax = plt.subplots()
    # plt.title('MSL measurement, r=0 mm (center)')
    ax.plot(data_defBt.data_MSL['B_x'],'tab:blue', label=f'default $B_t$, Ubt ={data_defBt.Ubt} (#{shot_defBt}), r=0 mm')
    ax.plot(data_defBt2.data_MSL['B_x'],'tab:red', label=f'default $B_t$, Ubt ={data_defBt2.Ubt} (#{shot_defBt2}), r=85 mm')
    # ax.plot(data_defBt3.data_MSL['B_x'],'tab:green', label = f'default $B_t$, Ubt ={data_defBt3.Ubt} (#{shot_defBt3}), r=-85 mm')
    ax.set(xlabel='Time [ms]', ylabel='$B_z$ [mT]', xlim=(0,90))
    ax.legend(); ax.grid()


# %%
plot_simple_Bt = False
if plot_simple_Bt:
    shot_defBt = 46275
    data_defBt = MSL_data(shot_defBt, '2024_09_16') 
    fig, ax = plt.subplots()
    
    ax.plot(data_defBt.data_MSL['B_y'],'tab:blue', label=f'default orientation of $B_t$, Ubt ={data_defBt.Ubt} (#{shot_defBt}), r=0 mm')
    
    ax.set(xlabel='Time [ms]', ylabel='$B_t$ [mT]', xlim=(0,90))
    ax.legend(); ax.grid()
  
# %%
plot_radStab = True
if plot_radStab:
    shot_defRadStab = 46278
    data_defRadStab = MSL_data(shot_defRadStab, '2024_09_16') 
    
    shot_defRadStab2 = 46304
    data_defRadStab2 = MSL_data(shot_defRadStab2, '2024_09_17') 
    
    fig, ax = plt.subplots()
    ax.plot(data_defRadStab.data_MSL['B_x'],'tab:blue', label=f'#{shot_defRadStab}, default RadStab, r=-85mm (HFS)')
    ax.plot(data_defRadStab2.data_MSL['B_x'],'tab:red', label = f'#{shot_defRadStab2}. default RadStab, r=0mm (center)')
    ax.set(xlabel='Time [ms]', ylabel='$B_z$ [mT]', xlim=(0,90))
    ax.legend(); ax.grid()
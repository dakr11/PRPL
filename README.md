# Investigation of the feasibility of the plasma position stabilization at tGOLEM
The project aims to investigate the feasibility of plasma position stabilization at Tokamak GOLEM. 

> *Reduce uncertainties from the past. First understand, then construct*
>  
> *Gather the information on plasma position stabilization in one place.*
> 
> *Uncover the potential limits.*

## Introduction
One of the primary objectives of this project is to analyze the causes of plasma motion. As seen in Figure ..., characteristic plasma movement at GOLEM is inward in the radial direction and upward in the vertical direction. 



## Problems
* Impact of the copper shell
* Cause of inward and upward plasma movement
* Magnetic fields and their impact on magnetic diagnostics 
* Discharge quality 
* Technical limits
* Plasma position stabilization (most current status)


## Copper shell
The time constant of the copper shell was measured and compared with a model in [A. Kubincova BP](https://dspace.cvut.cz/bitstream/handle/10467/97036/F4-BP-2021-Kubincova-Adela-bp_fttf_21_kubincova.pdf?sequence=-1&isAllowed=y). The time constant was determined as $\tau = $


The modulation of the poloidal magnetic field along the torus, produced by the limbs of the transformer and by the diagnostic windows in the copper shell was investigated [Valovic](http://golem.fjfi.cvut.cz/wiki/Library/CASTOR/Valovic_Magnetic_Diagnostics_CZJP_88.pdf) at then-existing CASTOR tokamak (= previous version of tGOLEM). The results of those measurements are seen in Figure ...  


## Discharge performance
The discharge duration is closely tied to its quality/performance, encompassing factors like wall conditioning and instabilities. Additionally, the discharge quality is influenced by the current state of the machine and uncertainties in the technologies used, such as gas puffing. 

Consequently, applying external magnetic fields for plasma position control does not always guarantee the discharge extension. Therefore, before starting the position control, it is required to find the optimal parameters initiating the discharge ($U_{CD}, U_{Bt}, T_{CD}, T_{Bt}, p$). 

*What role does each of them play (impact on breakdown, etc.)? - see [M.Odstrcil report](http://golem.fjfi.cvut.cz/wiki/Experiments/BreakDownStudies/Reports/ToBeCategorized/13Odstrcilove/)* 

Compare very nice shot [\#29457](http://golem.fjfi.cvut.cz/shots/29457/), performed without stabilization, with shot [\#39125](http://golem.fjfi.cvut.cz/shots/39125/) performed with stabilization. (*Pay attention, the discharge duration seems to be identified differently for the old discharges!*) 


From [Valovic: Plasma Position](http://golem.fjfi.cvut.cz/wiki/Library/CASTOR/ValovicM_Plasma_Control_Position_CZJP_89.pdf):
'''
It (the current in the external quadrupole coils) starts from a pre-programmed non-zero level which is optimal for breakdown.
'''

Another important note from the paper:
'''
The current in the internal quadrupole coils were proportional to the primary transformer current.
'''
- Why? To eliminate stray magnetic field? Or is it technology issue?

### Fields orientation 
[impact of fields orientation on plasma breakdown](http://golem.fjfi.cvut.cz/wiki/TrainingCourses/Universities/CTU.cz/PRPL/2015-2016/AdamSem/index)

## Technical limits 
>*Is it even achievable with the current version of plasma position stabilization?*

As mentioned earlier, the discharge duration is influenced by various factors and one important consideration is the possible amount of stored electrical energy used to drive a plasma current, i.e. the capacity $C_{CD}$. (E.g. in the case of the discharge \#39125 the current started decreasing during the discharge - *Do we even have any examples of 'ramp down'?* )

*What does the plasma current top determine?*



## References


<div id="refs"></div>

### Approach


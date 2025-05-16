# Logbook
V následujícím jsou shrnuty všemožné postřehy, reporty a obecně vývoj celého tohoto projektu PRPL.

<p align="center">
  <img src="Figs/draw/roadmap_introPres_PRPLA.svg" width="455"/> 
  <br/>
  <em></em>
</p>


### 23.10.2023
Komunikace s Dr.Ivanem Ďuranem a Dr.Tomášem Markovičem ([email](emails/Re_Měření_magnetických_polí_na_tokamaku_GOLEM.eml)). To podstatné/nejzajímavější shrnuto v 

### 2.11.2023 První návštěva ÚFP
S panem Dr.Ďuranem jsme se pokusili zprovoznit sondu. 
Zpocatku byl problem s nejakym spatnym kontaktem, kdy sonda vůbec neměřila, ale pote to nejakým zázrakem ("zakvedlani dratky" :D) začalo fungovat. Ještě zbyvá vyzkoušet trigger, ale to až příště.

<div style="text-align: center;">
  <div style="display: inline-flex; gap: 20px;">
    <div>
      <img src="Figs/photos/UFP_02.jpg" alt="Figure 1" width="300">
      <p style="text-align: center;"><em>Figure 1: Sestavení sondy na ÚFP</em></p>
    </div>
    <div>
      <img src="Figs/photos/UFP_01.jpg" alt="Figure 2" width="300">
      <p style="text-align: center;"><em>Figure 2: První testy</em></p>
    </div>
  </div>
</div>

### 6.11.2023 
Ovládací software pro MSL sondy přetažen na windows PC na GOLEMovi a zdá se, že ho lze i spustit.

### 14.11.2023 Druhá návštěva ÚFP
Triggerovani úspěšně vyzkoušeno => přenos sondy na GOLEM ("Hlavně pozor na drátky!")

### 14.12.2023
Sonda smontována, program na PC spuštěn, ale komunikace se sondou nefunguje. Vyzkoušeno i na jiném windows notebooku, nicméně taktéž s verzí windows 10. Oba dva počítače hlásí chybu, sice v trochu odlišné podobě, ale vždy jde o problém s portem a zřejmě i nějakou dll knihovnou... 

### 11.2.2024
- nejde-li to zatim prakticky, zkusime to teoreticky
- napsan skript pro vypocet magnetickeho pole `B_field.m` - mozno vybrat mezi numerickou a analytickou metodou (elipticke integraly)
- vypocet B numerickym zpusobem otestovan na jednoduchem prikladu, ktery ma analyticke reseni, viz `Test_B.m`; V skriptu take porovnan numericky pristup s analytickym (vyuzivajici ell.int.) - na prikladu jedne civky
- napsan skript pro predpocitani a ulozeni hodnot magnetickeho pole vytvareneho jednotkovym proudem protekajicim civkami stabilizace v danem bode mrizky - ulozeno jako `Bcoils_attempt01.mat`

#### TODO:
- [ ] zpracovat vysledky porovnani metod + testovani vypoctu dle `Test_B.m` (ruzne vzdalenosti, ruzna n, apod.)
- [ ] nutno zkontrolovat/upravit skript pro vypocet vzajemne indukcnosti, zejmena ten numericky pristup bude mozna spatne (prohozene souradnice, apod.) 

### 24.3.2024
Po přednášce TTJZ, kterou vedl Dr.Ďuran, došla řeč i na sondu. Po vylíčení problémů mi pan Dr.Ďuran s panem Doc.Entlerem nabídli zapůjčení staršího PC s windows7 na FJFI. (Tak proč toho nevyužít...)

### 8.4.2024
Převoz PC na FJFI (Díky Dominiku!)


### 9.4.2024
Nový pocitac v kombinaci s redukcí (RS232 na HDMI) ATEN (+ nainstalovani prislusneho driveru) pomohlo! Sonda se připojila, měření teploty funguje, sonda reaguje na přiložení neodymoveho magnetku -> Připraveno na měření


### 26.4.2024
- mereni s MSL sondou uvnitr komory tokamaku: http://golem.fjfi.cvut.cz/shots/0/Infrastructure/Homepage/psql/ShotsOfTheMission.php (za asistence Marka Tunkla a Lukáše Lobka) \
- vysledky shrnuty zde...



### 16.9. (46271-46280)
**r = -8.5cm**\
BtScan: 46271-46275\
VertStab: 46276, 46280(wSaddle coil)\
RadStab: 46278, 46279(wSaddle coil)



### 17.9. (46287-46340)
**r =-8.5cm**\
InnerQuadr: 46287\
EtScan: 46288, 46290\
DummyDischarge: 46291(Bt_400,Ucd_325), 46293(Bt_800,Ucd_325)\
RadQuadr: 46294\
DummyDischarge+RadQuadr: 46295

**r =0**\
BtScan: 46296-46300\
BtScan(opposite direction): 46307-46311\
Et: 46305\
dummyDischarge: 46306\
dummyDischarge(opposite direction): 46312, 46313, 46314, \
InnerQuadr: 46301, 46302(different orientation)\
VertStab: 46315\
RadStab: 46304\
RadQuadr: 46303

**r=8.5cm**\
šum:49317\
BtScan: 46331-46335\
DummyDischarge: 46336-46339\
DummyDischarge+RadQuad: 46340\
BtScan(opposite direction): 46321-46325\
DummyDischarge(opposite direction): 46326-46328\
Et: 46329(Ucd_200),46330(Ucd_325)\
VertStab: 46316\
InnerQuadr: 46318, \
RadStab: 46319\
RadQuadr: 46320\


#### Inner Quadrupole 
- Kepca z vertikalni zapojena do vinuti Inner Quadrupole -> request freq. generatoru na osciloskopu pro vertical stab
- sber proudu na fluke loop Jendy Buryance (proudova stabilizace) - pro nase ucely nastaveno na 10mV/A
- na vertikalni stabilizaci 5kepec, na radialni x + FastSpectrometry


r = -8.5cm:  

r = 0.0cm: zkousena i jina orientace Bt pole + take s Ecd(to ale nemeneno); behem toho take navracena zpatky vertikalni (46315) 

r = 8.5cm: 46317 dost mozna ptrohozena polarita u inner quadr. oproti predchozim - nesepnulo-> datal ulozena pro offset (jak poznamenal Lukas)

**Dipol nebo Kvadrupol? - Email z 25.2.2020**
>> Interpretoval bych to takto. Vinuti na GOLEMu je kvadrupol , nebot obsahuje 4 vodice. Tyto jsou pak zapojeny tak, ze vytvareji dipolove magneticke pole.  *Dr. Stöckel*

**Zpracovani**
1. Inner Quadrupole

2. Better identification of the model constants for vertical and radial stab.

3. Vertical Stray Field from toroidal field coils


TODO: z porovnani vyboju z 16.9. (kdy jsme jeste neresili kvadrupol) a vyboju z 17.9. by melo byt videt, zda tam bylo pritomne nejake pole, ktere tam byt nemelo

TODO: instead of that 'dynamic' B-S figure for one shot, take max. B at max current of many shots and compare

### 7.3.2025
- Sonda spolu s počítačem navrácena na ÚFP


### 16.5.2025
- finalizace: psaní reportu, upload na GitHub,...





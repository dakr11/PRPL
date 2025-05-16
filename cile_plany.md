# PRPL: Cíle/Plány

## Cíle
### Skromný cíl
- vytvořit (dynamický) model pro magnetické pole pouze s proudy v cívkách, bez plazmatu a vodivých struktur
- asi jen <i>step responsse</i>
- porovnat s měřením Mirnovových cívek a Hallovy sondy 

<b>Přístup:</b>\
 -> Staticky: mělo by jít z BiotSavarta, jak jsem kdysi již zkoušela, opět zkusit numericky i analyticky\
 -> Dynamicky: z $\frac{d\psi}{dt}$ počtu závitů MC, jimi uzavřenému obsahu a předpokladu, že se v rámci rozměrů cívky hodnota $\frac{d\psi}{dt}$ příliš němění by mělo jít získat očekávané mag. pole naměřené MC ($\psi$ je lokalni poloidalni tok) -> <mark>ale asi to nebude tak trivialni, zrejme by se kazda z civek mela uvazovat jako jedno samotne vinuti a ze vzajemnych indukcnosti ziskat psi - problem je, že cívka neprochazi kolem hlavni osy -> nutno vyuzit jiny vzorec!!!</mark>


### Méně skromný cíl
- vytvořit (dynamický) model pro magnetické pole bez plazmatu, tj. pouze s cívkami vnitřní a externí stabilizací, kožuchem a jádrem
- asi jen <i>step responsse</i>
- porovnat s měřením Mirnovových cívek a Hallovy sondy 
- tím, že by se započítala konstantu kožuchu,tak bych očekávala, že by mělo vycházet jinak


### Neskromný cíl
- vytvořit (dynamický) model pro magnetické pole s plazmatem a 'vším' okolo
- porovnat s měřením Mirnovových cívek a Hallovy sondy 

----
- Dynamicky to pro magneticke pole pro kazdy bod mrizky neupocitam, musi to by pouze v určitém bodě/pár bodech
- Chci-li namodelovat mag. pole měřené magnetickými Mirnovovými cívkami, pak by změna indukčnosti plazmatu (dM/dr) měla jít určit z měření polohy (ale ne z MC, nutno z kamer, a teda z nakalibrovaných kamer!!!), jádro i kožuch by asi měly mít vliv na to, aby znepřesnili měření MC (?) -> tímto by šlo zjistit jak eliminovat pole v cívkách, aby měřili pouze polohu
- K předešlému bodu by pak bylo vhodné odhadnout chybu v určování polohy MC vs. Kamery 

----

### Kombinace modelů pro prunik pole kozuchem (Adela BP) a zelezneho jadra (T. Markovič)
- v BP Adely neni pri urcovani polo

- T.Markovic zase uvazuje nejaky stacionarni stav (nicmene z popisu jsem pochopila, že se do civky stabilizace poustel impuls, nikoliv konstanti proud???), tedy neuvazoval mozne zpozdeni od kozuchy a tedy virive proudy indukovane v kozuchu -> asi by taktez mely byt nejak zapocitany do proudu indukovanych v transformatorovym jadre

## Vypocet B z psi
- lze pouze pres derivaci? tedy: $B_r(R,Z) = -\frac{1}{2\pi R}\frac{\partial\psi}{\partial Z}$ 

## Vypocet magnetizacnich proudu transformatoru
- popis vypoctu pro feromagneticke struktury viz [JANET doc], [Free boundary Simulations of MHD plasma, Javier PhDthesis], [OBrien equilibrium analysis of IronCore]

- mozna by bylo lepsi pocitat magneticke pole ne pres Elipticke integraly, ale pres Greenovu fci jak se asi casto delava


## Kroky
- [ ] Spočítat magnetické pole od cívek pro síťku s přesahem k jádru, numericky i analyticky (eliptické integrály)



## K cemu to vlastne vsechno muze byt:
- Breakdown - lze pak treba optimalizovat se stabilizaci, aby doslo k chtenemu prurazu pri co mozna nejnizsi ztrate volt-sekund
- kalibrace "rychle" mag. diagnostiky = MC
- konstanta kozuchu
- indukcni model



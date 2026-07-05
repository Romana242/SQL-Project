# SQL Project

## 1. Zadání

Cílem projektu bylo pro analytické oddělení společnosti zabývající se životní úrovní obyvatel odpovědět na několik výzkumných otázek týkajících se dostupnosti základních potravin pro širokou veřejnost.

Pro účely prezentace výsledků na odborné konferenci bylo nutné připravit robustní datový základ, který umožní porovnání vývoje cen potravin vůči průměrným příjmům obyvatel v čase.

Součástí zadání bylo také vytvoření doplňkové datové sady obsahující makroekonomické ukazatele (HDP, GINI koeficient a populace) pro vybrané evropské státy ve stejném časovém období jako primární analýza pro Českou republiku.

---

## 2. Tvorba tabulek

### 2.1 Tvorba 1. (primární) tabulky

Při tvorbě primární analytické tabulky byly identifikovány klíčové požadavky vyplývající z výzkumných otázek. Na jejich základě byly vybrány následující zdrojové tabulky:

- `czechia_price` (sloupce: `value`, `date_from`)
- `czechia_price_category` (sloupec: `name`)
- `czechia_payroll` (sloupec: `value`)
- `czechia_payroll_industry_branch` (sloupec: `name`)

Pro propojení relevantních dat byla použita operace `JOIN`, která zajistila integraci pouze odpovídajících záznamů mezi tabulkami.

Na základě provedené kontroly kvality dat byly identifikovány následující skutečnosti:

- tabulka `czechia_payroll` obsahuje ve sloupci `value_type_code` dva různé typy hodnot:
  - 316 = průměrný počet zaměstnanců
  - 5958 = průměrná hrubá mzda  
  Pro další analýzu bylo nutné data filtrovat pouze na hodnotu 5958,
- časová období mezd a cen nejsou plně shodná,
- sloupec `region_code` v tabulce `czechia_price` obsahuje jak data za celou ČR, tak regionální hodnoty; pro analýzu byla použita pouze agregovaná data (`region_code IS NULL`),
- analýza časových řad ukázala, že některé potravinové kategorie nemají kompletní historická data v celém sledovaném období 2006–2018. Například kategorie „jakostní víno bílé“ je dostupná až od roku 2015, což omezuje její využití pro dlouhodobé srovnání.

---

### 2.2 Tvorba 2. tabulky

Druhá tabulka byla vytvořena za účelem doplnění makroekonomických dat pro evropské státy.

Tabulka `countries` obsahuje sloupec `continent`, který umožnil filtraci evropských států dle zadání. Pro vytvoření výsledné tabulky bylo nutné propojit:

- `economies` (sloupce: `year`, `gdp`, `population`, `gini`)
- `countries` (sloupce: `country`, `continent`)

Pro spojení byla použita operace `JOIN`.

Následně byla provedena manuální kontrola výsledného seznamu států, aby byla ověřena správnost zařazení evropských zemí (a vyloučení nesprávně kategorizovaných položek).

---

## 3. Výzkumné otázky

### 3.1 Růst mezd v čase

**Otázka:** Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých dochází k poklesu?

**Postup:**
1. výpočet průměrné mzdy v jednotlivých odvětvích a letech  
2. přidání hodnot předchozího roku pomocí `LAG()`  
3. výpočet meziročních rozdílů  

**Závěr:**
Na základě výskytu záporných meziročních hodnot lze konstatovat, že mzdy nerostly ve všech odvětvích kontinuálně. V některých odvětvích došlo v určitých letech k poklesu.

---

### 3.2 Kupní síla (potraviny vs. mzdy)

**Otázka:** Kolik litrů mléka a kilogramů chleba bylo možné pořídit za průměrnou mzdu v prvním a posledním srovnatelném období?

**Postup:**
1. identifikace společných let pro mzdy a ceny (2006 a 2018)  
2. ověření názvů a jednotek potravin  
3. výpočet průměrných mezd a cen  
4. výpočet poměru mzda vs. cena  
5. kontrolní přepočet výsledků  

**Závěr:**
- 2006: cca 1 287 kg chleba nebo 1 437 l mléka  
- 2018: cca 1 342 kg chleba nebo 1 642 l mléka  

---

### 3.3 Nejpomalejší zdražování potravin

**Otázka:** Která kategorie potravin zdražuje nejpomaleji?

**Postup:**
1. výpočet průměrných cen potravin za jednotlivé roky  
2. přidání hodnot předchozího roku  
3. výpočet meziroční procentní změny  
4. výpočet průměrné meziroční změny  

**Kontroly:**
- ověřena úplnost časových řad (např. „jakostní víno bílé“ má nekompletní historii),
- kontrola záporných hodnot u kategorií s poklesem,
- ověřeno, že nejde o důsledek chybějících dat,
- kontrola absence NULL hodnot v cenách.

**Závěr:**
Nejnižší průměrný meziroční růst byl zaznamenán u banánů žlutých (+0,81 %). Ačkoli některé komodity vykazují záporný růst (např. cukr krystalový a rajská jablka), tyto hodnoty nejsou odpovědí na otázku, protože ta se týká nejnižšího růstu, nikoli poklesu.

---

### 3.4 Rozdíl růstu mezd a cen

**Otázka:** Existuje rok, kdy byl růst cen potravin výrazně vyšší než růst mezd (o více než 10 %)?

**Postup:**
1. výpočet průměrných meziročních změn mezd a cen  
2. výpočet rozdílů mezi těmito změnami  

**Závěr:**
Maximální rozdíl mezi růstem cen a mezd nepřesáhl 10 procentních bodů (max. cca +7,11 p. b.). Na základě analýzy nebyl identifikován rok, který by splňoval zadanou podmínku.

---

### 3.5 Vliv HDP na mzdy a ceny

**Otázka:** Má růst HDP vliv na růst mezd a cen potravin?

**Postup:**
1. výpočet meziročních změn HDP, mezd a cen  
2. porovnání aktuálních a předchozích hodnot HDP  
3. analýza korelace mezi ukazateli  

**Závěr:**
Analýza neprokázala jednoznačnou závislost mezi růstem HDP a růstem mezd ani cen potravin. V některých obdobích lze pozorovat podobné trendy, tento vztah však není konzistentní. Vývoj mezd i cen je pravděpodobně ovlivněn širším spektrem ekonomických faktorů.

---

## 4. Shrnutí

Projekt ukázal, že vývoj cen potravin a mezd v čase není lineární ani jednoznačně determinovaný makroekonomickými ukazateli.

Současně byla v rámci přípravy dat provedena detailní kontrola kvality dat a analýza časových řad, která odhalila omezení datasetu (např. neúplné časové řady u některých komodit).

Tato zjištění byla zohledněna při interpretaci výsledků a při formulaci závěrů jednotlivých výzkumných otázek.

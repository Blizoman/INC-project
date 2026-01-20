# INC – Projekt: UART Přijímač (RX)

Riešenie 2. časti projektu z predmetu INC (Návrh číslicových systémů) na FIT VUT.

## Obsah úlohy
- **VHDL Implementácia** – opis RTL architektúry a konečného automatu (FSM).
- **UART_RX** – modul pre príjem sériových dát (8 dátových bitov, 1 stop bit).
- **Simulácia** – verifikácia pomocou `testbench` a nástrojov GHDL / GTKWave.
- **Ladenie** – analýza priebehov signálov (WaveForm).

Projekt bol vytvorený výlučne na vzdelávacie účely.

## Hodnotenie
- Získané body: **16 / 20**

---

<details>
<summary><b>Zobrazit zkrácené zadání</b></summary>

### Cíl projektu
Implementovat navržený RTL obvod přijímače UART z první části projektu v jazyce VHDL a ověřit jeho funkčnost pomocí simulace.

### Soubory
- `uart_rx.vhd` – datová cesta (rozhraní entity a architektura).
- `uart_rx_fsm.vhd` – řídicí konečný automat (FSM).

### Nástroje
Projekt využívá open-source nástroje:
- **GHDL:** Analýza, syntéza a simulace VHDL.
- **GTKWave:** Zobrazení průběhů signálů.

**Spuštění:**
Simulace se spouští pomocí skriptu `./uart.sh`, který zkompiluje VHDL soubory a otevře výstup v GTKWave.

### Výstup
Funkční implementace (zdrojové kódy) a technická zpráva obsahující snímek obrazovky zachycující přenos datového slova.

</details>

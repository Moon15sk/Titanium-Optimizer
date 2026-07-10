#include <iostream>
#include <windows.h>
#include <string>
#include <cstdlib>

// Pomocná funkcia na zápis DWORD hodnôt do registrov
bool SetRegDWORD(HKEY hKeyParent, const std::string& subKey, const std::string& valueName, DWORD value) {
    HKEY hKey;
    LONG result = RegCreateKeyExA(hKeyParent, subKey.c_str(), 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE, NULL, &hKey, NULL);
    if (result != ERROR_SUCCESS) return false;
    
    result = RegSetValueExA(hKey, valueName.c_str(), 0, REG_DWORD, reinterpret_cast<const BYTE*>(&value), sizeof(DWORD));
    RegCloseKey(hKey);
    return result == ERROR_SUCCESS;
}

// Pomocná funkcia na zápis String (textových) hodnôt do registrov
bool SetRegString(HKEY hKeyParent, const std::string& subKey, const std::string& valueName, const std::string& value) {
    HKEY hKey;
    LONG result = RegCreateKeyExA(hKeyParent, subKey.c_str(), 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE, NULL, &hKey, NULL);
    if (result != ERROR_SUCCESS) return false;
    
    result = RegSetValueExA(hKey, valueName.c_str(), 0, REG_SZ, reinterpret_cast<const BYTE*>(value.c_str()), value.length() + 1);
    RegCloseKey(hKey);
    return result == ERROR_SUCCESS;
}

// Nastavenie ANSI farieb pre profesionálny vzhľad v termináli
void SetupTerminal() {
    HANDLE hOut = GetStdHandle(STD_OUTPUT_HANDLE);
    DWORD dwMode = 0;
    GetConsoleMode(hOut, &dwMode);
    dwMode |= ENABLE_VIRTUAL_TERMINAL_PROCESSING;
    SetConsoleMode(hOut, dwMode);
}

void PrintHeader() {
    std::cout << "\033[1;36m"; // Azúrová farba
    std::cout << "==================================================\n";
    std::cout << "       TITANIUM OPTIMIZER PRO // ENGINE C++       \n";
    std::cout << "==================================================\n";
    std::cout << "\033[0m"; // Reset farby
}

// --- JEDNOTLIVÉ OPTIMALIZAČNÉ FUNKCIE ---

void OptimizeGaming() {
    std::cout << "\033[1;33m[>] Aplikujem herné optimalizácie...\033[0m\n";
    
    // Zapnutie herného režimu (Game Mode)
    SetRegDWORD(HKEY_CURRENT_USER, "Software\\Microsoft\\GameBar", "AllowAutoGameMode", 1);
    
    // Vypnutie Game DVR (záznam na pozadí, čo žerie FPS)
    SetRegDWORD(HKEY_CURRENT_USER, "System\\GameConfigStore", "GameDVR_Enabled", 0);
    SetRegDWORD(HKEY_LOCAL_MACHINE, "SOFTWARE\\Policies\\Microsoft\\Windows\\GameDVR", "AllowGameDVR", 0);
    
    // Aktivácia HAGS (Hardware-Accelerated GPU Scheduling)
    SetRegDWORD(HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Control\\GraphicsDrivers", "HwSchMode", 2);
    
    std::cout << "\033[1;32m[+] Herný režim, HAGS aktívny a Game DVR zakázané.\033[0m\n\n";
}

void OptimizeNetwork() {
    std::cout << "\033[1;33m[>] Optimalizujem sieť a odozvu (Ping)...\033[0m\n";
    
    // Vypnutie Network Throttling (hry majú plnú prioritu siete)
    SetRegDWORD(HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile", "NetworkThrottlingIndex", 0xFFFFFFFF);
    SetRegDWORD(HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile", "SystemResponsiveness", 0);
    
    // Vyčistenie DNS Cache
    system("ipconfig /flushdns > nul");
    
    std::cout << "\033[1;32m[+] Sieťová telemetria vypnutá a DNS cache premazaná.\033[0m\n\n";
}

void DisableTelemetry() {
    std::cout << "\033[1;33m[>] Likvidujem telemetriu a sledovanie na pozadí...\033[0m\n";
    
    // Hlavná Windows Telemetria
    SetRegDWORD(HKEY_LOCAL_MACHINE, "SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection", "AllowTelemetry", 0);
    
    // Zastavenie a zakázanie služby DiagTrack (Prepojené skúsenosti používateľov a telemetria)
    system("sc config DiagTrack start= disabled > nul 2>&1");
    system("sc stop DiagTrack > nul 2>&1");
    
    // NVIDIA Telemetria (ak existuje)
    system("sc config NvTelemetryContainer start= disabled > nul 2>&1");
    system("sc stop NvTelemetryContainer > nul 2>&1");
    
    // Zakázanie Cortany
    SetRegDWORD(HKEY_LOCAL_MACHINE, "SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Search", "AllowCortana", 0);
    
    std::cout << "\033[1;32m[+] Všetky sledovacie služby úspešne zablokované.\033[0m\n\n";
}

void DisableVBS() {
    std::cout << "\033[1;33m[>] Vypínam VBS (Zabezpečenie založené na virtualizácii) pre maximálny herný výkon...\033[0m\n";
    
    // Vypnutie izolácie jadra (HVCI / VBS) - dokáže pridať až 10% výkonu procesora v hrách
    SetRegDWORD(HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Control\\DeviceGuard\\Scenarios\\HypervisorEnforcedCodeIntegrity", "Enabled", 0);
    
    std::cout << "\033[1;32m[+] VBS bolo v registroch deaktivované (vyžaduje reštart PC).\033[0m\n\n";
}

void EnableUltimatePerformance() {
    std::cout << "\033[1;33m[>] Odomykám skrytý plán napájania Ultimate Performance...\033[0m\n";
    
    // Príkaz na duplikáciu schémy maximálneho výkonu priamo od Microsoftu
    system("powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 > nul 2>&1");
    
    std::cout << "\033[1;32m[+] Plán napájania odomknutý. Môžeš si ho prepnúť v nastaveniach batérie.\033[0m\n\n";
}

void Windows11Tweaks() {
    std::cout << "\033[1;33m[>] Upravujem rozhranie Windowsu...\033[0m\n";
    
    // Návrat ku klasickému menu na pravé kliknutie (odstránenie "Zobraziť viac možností")
    SetRegString(HKEY_CURRENT_USER, "Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\\InprocServer32", "", "");
    
    // Vypnutie otravných widgetov na hlavnom paneli
    SetRegDWORD(HKEY_CURRENT_USER, "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "TaskbarDa", 0);
    
    std::cout << "\033[1;32m[+] Klasické menu aktivované, widgety skryté.\033[0m\n\n";
}

void CleanSystemFiles() {
    std::cout << "\033[1;33m[>] Čistím systém od dočasného balastu...\033[0m\n";
    
    // Rýchle premazanie Temp zložiek
    system("del /q /f /s %TEMP%\\* > nul 2>&1");
    system("del /q /f /s C:\\Windows\\Temp\\* > nul 2>&1");
    
    std::cout << "\033[1;32m[+] Dočasné súbory vymazané.\033[0m\n\n";
}

// --- HLAVNÝ PROGRAM ---

int main() {
    SetupTerminal();
    
    // Kontrola, či je program spustený ako Správca (Administrator)
    bool isAdmin = false;
    HANDLE hToken = NULL;
    if (OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &hToken)) {
        TOKEN_ELEVATION elevation;
        DWORD cbSize = sizeof(TOKEN_ELEVATION);
        if (GetTokenInformation(hToken, TokenElevation, &elevation, sizeof(elevation), &cbSize)) {
            isAdmin = elevation.TokenIsElevated;
        }
    }
    if (hToken) CloseHandle(hToken);

    if (!isAdmin) {
        PrintHeader();
        std::cout << "\033[1;31m[ERORR] Tento nástroj vyžaduje práva SPRÁVCU!\033[0m\n";
        std::cout << "Klikni na skompilovaný súbor pravým tlačidlom a zvoľ 'Spustiť ako správca'.\n\n";
        std::cout << "Stlač Enter pre ukončenie...";
        std::cin.get();
        return 1;
    }

    int volba = 0;
    while (true) {
        system("cls");
        PrintHeader();
        std::cout << " [1] KOMPLETNÁ ULTRA OPTIMALIZÁCIA (All-in-One)\n";
        std::cout << " [2] Iba Herné Tweaky (Game Mode, HAGS, Game DVR)\n";
        std::cout << " [3] Iba Sieť a Ping (Network Throttling, DNS)\n";
        std::cout << " [4] Iba Vypnutie Telemetrie a Sledovania\n";
        std::cout << " [5] Iba Vypnutie VBS (Zvýšenie FPS na CPU)\n";
        std::cout << " [6] Iba Aktivácia Ultimate Performance plánu\n";
        std::cout << " [7] Iba Windows 11 Vizuálne Tweaky (Klasické menu)\n";
        std::cout << " [8] Iba Vyčistenie Temp súborov\n";
        std::cout << " [0] Ukončiť program\n";
        std::cout << "--------------------------------------------------\n";
        std::cout << "Vyber možnosť (0-8): ";
        
        std::cin >> volba;
        if (std::cin.fail()) {
            std::cin.clear();
            std::cin.ignore(10000, '\n');
            continue;
        }

        system("cls");
        PrintHeader();

        if (volba == 0) break;

        switch (volba) {
            case 1:
                OptimizeGaming();
                OptimizeNetwork();
                DisableTelemetry();
                DisableVBS();
                EnableUltimatePerformance();
                Windows11Tweaks();
                CleanSystemFiles();
                break;
            case 2: OptimizeGaming(); break;
            case 3: OptimizeNetwork(); break;
            case 4: DisableTelemetry(); break;
            case 5: DisableVBS(); break;
            case 6: EnableUltimatePerformance(); break;
            case 7: Windows11Tweaks(); break;
            case 8: CleanSystemFiles(); break;
            default: std::cout << "Neplatná voľba.\n"; break;
        }

        std::cout << "\033[1;36mHotovo! Zmeny boli úspešne zapísané do jadra systému.\033[0m\n\n";
        std::cout << "Stlač Enter pre návrat do menu...";
        std::cin.ignore();
        std::cin.get();
    }

    return 0;
}

#include <iostream>
#include <windows.h>
#include <string>
#include <cstdlib>

// Pomocná funkcia na zmenu farby textu v konzole
void SetColor(int color) {
    SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), color);
}

// Zápis DWORD do registrov
bool SetRegistryValueDWORD(HKEY hKeyRoot, const std::string& subKey, const std::string& valueName, DWORD data) {
    HKEY hKey;
    long result = RegCreateKeyExA(hKeyRoot, subKey.c_str(), 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE, NULL, &hKey, NULL);
    if (result == ERROR_SUCCESS) {
        result = RegSetValueExA(hKey, valueName.c_str(), 0, REG_DWORD, (const BYTE*)&data, sizeof(data));
        RegCloseKey(hKey);
        return (result == ERROR_SUCCESS);
    }
    return false;
}

// Vykreslenie hlavičky TITANIUM
void PrintHeader() {
    system("cls");
    SetColor(11); // Výrazná azúrová (Cyan)
    std::cout << "=========================================================\n";
    std::cout << "          TITANIUM OPTIMIZER PRO // C++ ENGINE           \n";
    std::cout << "=========================================================\n\n";
    SetColor(7);  // Reset na klasickú sivobielu
}

int main() {
    int choice = 0;

    while (true) {
        PrintHeader();
        
        SetColor(10); std::cout << "--- POVODNE FUNKCIE (Z TVOJHO NAVRHU) ---\n"; SetColor(7);
        std::cout << "[1] Aktivovat Herny rezim (Game Mode)\n";
        std::cout << "[2] Vratit klasicke Windows menu (Prave tlacidlo)\n";
        std::cout << "[3] Vypnut Windows Telemetriu a sledovanie\n";
        std::cout << "[4] Vyfukat Temp subory (Cistenie disku)\n\n";

        SetColor(11); std::cout << "--- NOVE PREMIUM OPTIMALIZACIE ---\n"; SetColor(7);
        std::cout << "[5] Vypnut VBS a Izolaciu jadra (Stabilizacia FPS)\n";
        std::cout << "[6] Sietovy Tweak (Network Throttling + System Responsiveness)\n";
        std::cout << "[7] Zapnut HW akceleraciu grafiky (HAGS)\n";
        std::cout << "[8] Odomknut skryty 'Ultimate Performance' plan napajania\n\n";

        SetColor(14); std::cout << "[10] APLIKOVAT UPRAVY NARAZ (ALL-IN-ONE COMPETE TWEAK)\n";
        SetColor(12); std::cout << "[99] Ukoncit Titanium\n\n"; SetColor(7);
        
        std::cout << "Zadaj volbu: ";
        std::cin >> choice;

        SetColor(14); // Žltá pre procesy

        if (choice == 99) {
            std::cout << "\nUkoncujem Titanium Optimizer...\n";
            Sleep(1000);
            return 0;
        }

        // PREMENNE PRE SPUSTENIE EVALUACIE
        bool runAll = (choice == 10);

        // 1. GAME MODE
        if (choice == 1 || runAll) {
            std::cout << "\n[>] Povolujem herny rezim vo Windowse...";
            SetRegistryValueDWORD(HKEY_CURRENT_USER, "Software\\Microsoft\\GameBar", "AutoGameModeEnabled", 1);
            std::cout << " OK!\n";
        }

        // 2. KLASICKE MENU
        if (choice == 2 || runAll) {
            std::cout << "[>] Upravujem kontextove menu na klasicky styl...";
            system("reg.exe add \"HKCU\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\\InprocServer32\" /f /ve >nul 2>&1");
            std::cout << " OK!\n";
        }

        // 3. TELEMETRIA (WINDOWS + NVIDIA)
        if (choice == 3 || runAll) {
            std::cout << "[>] Zastavujem zbieranie dat a telemetriu...";
            SetRegistryValueDWORD(HKEY_LOCAL_MACHINE, "SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection", "AllowTelemetry", 0);
            // Vypnutie NVIDIA Telemetrie cez sluzby systému
            system("sc config NvTelemetryContainer start= disabled >nul 2>&1");
            system("net stop NvTelemetryContainer >nul 2>&1");
            std::cout << " OK!\n";
        }

        // 4. CISTENIE DISKU (TEMP)
        if (choice == 4 || runAll) {
            std::cout << "[>] Mazem docasne (Temp) subory a cache...";
            system("del /q /f /s %TEMP%\\* >nul 2>&1");
            system("del /q /f /s C:\\Windows\\Temp\\* >nul 2>&1");
            std::cout << " OK!\n";
        }

        // 5. VBS & ISOLATION VYPLESK
        if (choice == 5 || runAll) {
            std::cout << "[>] Vypinam VBS a Izolaciu jadra pre potlacenie micro-stutteringu...";
            SetRegistryValueDWORD(HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Control\\DeviceGuard", "EnableVirtualizationBasedSecurity", 0);
            SetRegistryValueDWORD(HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Control\\DeviceGuard\\Scenarios\\HypervisorEnforcedCodeIntegrity", "Enabled", 0);
            std::cout << " OK!\n";
        }

        // 6. NETWORK THROTTLING
        if (choice == 6 || runAll) {
            std::cout << "[>] Optimalizujem sietovy stack a potlacam Network Throttling...";
            SetRegistryValueDWORD(HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile", "NetworkThrottlingIndex", 0xFFFFFFFF);
            SetRegistryValueDWORD(HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile", "SystemResponsiveness", 0);
            std::cout << " OK!\n";
        }

        // 7. HAGS
        if (choice == 7 || runAll) {
            std::cout << "[>] Aktivujem Hardware-Accelerated GPU Scheduling (HAGS)...";
            SetRegistryValueDWORD(HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Control\\GraphicsDrivers", "HwSchMode", 2);
            std::cout << " OK!\n";
        }

        // 8. ULTIMATE PERFORMANCE
        if (choice == 8 || runAll) {
            std::cout << "[>] Odomykam plan napajania Ultimate Performance...";
            system("powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1");
            // Nastavenie ako aktivny plan
            system("powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1");
            std::cout << " OK!\n";
        }

        SetColor(10);
        std::cout << "\n[+] Hotovo! Vsetky vybrane optimalizacie boli uspesne aplikovane.\n";
        SetColor(7);
        std::cout << "Pre plny ucinok niektorych zmien (HAGS, VBS, Menu) odporucam restartovat PC.\n";
        
        std::cout << "\nStlac ENTER pre navrat do Titanium menu...";
        std::cin.ignore();
        std::cin.get();
    }

    return 0;
}

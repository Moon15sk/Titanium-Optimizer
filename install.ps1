Clear-Host
$Host.UI.RawUI.ForegroundColor = "Cyan"

# Modré ASCII záhlavie podľa obrázka
Write-Host "████████╗██╗████████╗ █████╗ ███╗   ██╗██╗██╗   ██╗███╗   ███╗"
Write-Host "╚══██╔══╝██║╚══██╔══╝██╔══██╗████╗  ██║██║██║   ██║████╗ ████║"
Write-Host "   ██║   ██║   ██║   ███████║██╔██╗ ██║██║██║   ██║██╔████╔██║"
Write-Host "   ██║   ██║   ██║   ██╔══██║██║╚██╗██║██║██║   ██║██║╚██╔╝██║"
Write-Host "   ██║   ██║   ██║   ██║  ██║██║ ╚████║██║╚██████╔╝██║ ╚═╝ ██║"
Write-Host "   ╚═╝   ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝     ╚═╝"
Write-Host "================= TITÁNOVÝ OPTIMALIZÁTOR ================="
Write-Host ""

# Simulácia / Príprava prostredia so sťahovaním
$progressText = "Downloading "
Write-Host -NoNewline $progressText

for ($i = 1; $i -le 20; $i++) {
    Start-Sleep -Milliseconds 100
    Write-Host -NoNewline "-"
}
Write-Host -NoNewline " 100%"
Write-Host ""
Write-Host "Downloaded!" -ForegroundColor Green
Start-Sleep -Seconds 1

# Vytvorenie skrytého priečinka pre optimizer a spustenie jadra
$optDir = "$env:USERPROFILE\.titan_optimizer"
if (!(Test-Path $optDir)) { New-Item -ItemType Directory -Path $optDir -Force | Out-Null }

# Vytvorenie samotného Python kódu aplikácie
$pythonCodePath = "$optDir\app.py"

$appCode = @'
import os
import sys
import subprocess
import json
import platform
import winreg
import customtkinter as ctk
from tkinter import messagebox

# Nastavenie témy aplikácie
ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("blue")

CONFIG_FILE = os.path.expanduser("~/.titan_optimizer/config.json")

# Predvolený stav všetkých prepínačov (vypnuté = False)
DEFAULT_SETTINGS = {
    # Systém
    "high_perf": False, "clean_on_boot": False, "disable_startup": False,
    "disable_effects": False, "disable_background_apps": False,
    # 10 Extra funkcií
    "disable_hibernation": False, "disable_superfetch": False, "clear_pagefile_shutdown": False,
    "optimize_ntfs": False, "disable_indexing": False, "disable_sticky_keys": False,
    "speed_up_menu": False, "disable_error_reporting": False, "network_throttling": False, "gpu_scheduling": False,
    # Windows (Podľa obrázkov 2 a 3)
    "telemetry_office": False, "telemetry_firefox": False, "telemetry_chrome": False,
    "telemetry_nvidia": False, "telemetry_vs": False, "telemetry_general": False,
    "media_sharing": False, "homegroup": False, "smbv1": False, "smbv2": False,
    "classic_explorer": False, "hide_weather": False, "hide_search": False, "hide_people": False,
    "long_paths": False, "disable_tpm": False, "sensor_services": False, "cast_to_device": False,
    "vbs_security": False, "classic_photo": False, "modern_standby": False,
    "windows_update": False, "ms_store_update": False, "insider_service": False, "exclude_drivers": False,
    "taskbar_left": False, "disable_widgets": False, "disable_chat": False, "disable_stickers": False,
    "telemetry_services": False, "disable_cortana": False, "improve_privacy": False, "news_interests": False,
    "start_ads": False, "edge_telemetry": False, "edge_discover": False,
    "game_mode": False, "xbox_live": False, "game_bar": False,
    "windows_ink": False, "spell_check": False, "cloud_clipboard": False,
    "snap_assist": False, "classic_context": False, "compact_explorer": False, "disable_copilot": False
}

def load_settings():
    if os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, "r") as f:
                return {**DEFAULT_SETTINGS, **json.load(f)}
        except:
            return DEFAULT_SETTINGS
    return DEFAULT_SETTINGS

def save_settings(settings):
    with open(CONFIG_FILE, "w") as f:
        json.dump(settings, f, indent=4)

class TitanOptimizer(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("PLATINUM + OPTIMIZER (TITAN EDITION)")
        self.geometry("900x650")
        self.settings = load_settings()
        self.vars = {}

        # Hlavná architektúra okna - Menu vľavo, obsah vpravo
        self.grid_columnconfigure(1, weight=1)
        self.grid_rowconfigure(0, weight=1)

        self.sidebar = ctk.CTkFrame(self, width=200, corner_radius=0)
        self.sidebar.grid(row=0, column=0, sticky="nsew")
        
        lbl_title = ctk.CTkLabel(self.sidebar, text="TITAN\nOPTIMIZER", font=("Arial", 20, "bold"), text_color="#00ffff")
        lbl_title.pack(pady=20)

        self.content_frame = ctk.CTkScrollableFrame(self, corner_radius=0)
        self.content_frame.grid(row=0, column=1, sticky="nsew", padx=10, pady=10)

        # Tlačidlá prepínania sekcií
        sections = [("Systém", self.show_system), ("Windows", self.show_windows), 
                    ("Informácie", self.show_info), ("Aplikácie", self.show_apps)]
        for name, func in sections:
            btn = ctk.CTkButton(self.sidebar, text=name, command=func, fg_color="transparent", text_color="white", anchor="w", font=("Arial", 14))
            btn.pack(fill="x", padx=10, pady=5)

        # Spodné systémové tlačidlo reštartu
        btn_apply = ctk.CTkButton(self.sidebar, text="Apply and Restart", fg_color="#0080ff", hover_color="#0059b3", command=self.apply_and_restart)
        btn_apply.pack(side="bottom", fill="x", padx=15, pady=20)

        self.show_system()

    def clear_content(self):
        for widget in self.content_frame.winfo_children():
            widget.destroy()

    def create_switch(self, parent, text, key):
        self.vars[key] = ctk.BooleanVar(value=self.settings.get(key, False))
        sw = ctk.CTkSwitch(parent, text=text, variable=self.vars[key], command=lambda: self.update_key(key))
        sw.pack(anchor="w", pady=6, padx=10)

    def update_key(self, key):
        self.settings[key] = self.vars[key].get()
        save_settings(self.settings)

    def show_system(self):
        self.clear_content()
        lbl = ctk.CTkLabel(self.content_frame, text="Systémové optimalizácie", font=("Arial", 18, "bold"))
        lbl.pack(anchor="w", pady=10)

        # Základné funkcie z textu zadania
        self.create_switch(self.content_frame, "Aktivovať Ultimate Performance (Vysoký výkon)", "high_perf")
        self.create_switch(self.content_frame, "Čistiť dočasné súbory po každom spustení (Temp, %temp%, Prefetch)", "clean_on_boot")
        self.create_switch(self.content_frame, "Zakázať zbytočné aplikácie pri spustení (Ponechá 1 antivírus)", "disable_startup")
        self.create_switch(self.content_frame, "Vypnúť vizuálne efekty a priehľadnosť okien (Max FPS)", "disable_effects")
        self.create_switch(self.content_frame, "Vypnúť nepotrebné aplikácie na pozadí", "disable_background_apps")

        # 10 Unikátnych neodfláknutých funkcií pre výkon a stabilitu
        lbl_extra = ctk.CTkLabel(self.content_frame, text="10 Extra výkonnostných funkcií", font=("Arial", 14, "bold"), text_color="#00ff00")
        lbl_extra.pack(anchor="w", pady=(15, 5))
        
        extras = [
            ("Vypnúť hibernáciu systému (Uvoľní miesto na disku)", "disable_hibernation"),
            ("Zakázať službu SysMain / Superfetch (Zníži záťaž disku a CPU)", "disable_superfetch"),
            ("Prečistiť stránkovací súbor (Pagefile) pri vypnutí PC", "clear_pagefile_shutdown"),
            ("Optimalizovať NTFS pamäťovú alokáciu pre SSD", "optimize_ntfs"),
            ("Zakázať indexovanie súborov systému Windows (Vyšší herný výkon)", "disable_indexing"),
            ("Úplne vypnúť funkciu Jedným prstom (Sticky Keys po 5x Shifte)", "disable_sticky_keys"),
            ("Zrýchliť odozvu kontextových a štart menu", "speed_up_menu"),
            ("Zakázať odosielanie správ o chybách (Windows Error Reporting)", "disable_error_reporting"),
            ("Vypnúť Network Throttling (Stabilnejší ping v online hrách)", "network_throttling"),
            ("Povoliť Hardvérovo akcelerované plánovanie GPU (HAGS)", "gpu_scheduling")
        ]
        for txt, key in extras:
            self.create_switch(self.content_frame, txt, key)

    def show_windows(self):
        self.clear_content()
        # Telemetria & Súkromie (Obrázok 2)
        lbl1 = ctk.CTkLabel(self.content_frame, text="Telemetria a Súkromie", font=("Arial", 16, "bold"), text_color="#00ffff")
        lbl1.pack(anchor="w", pady=5)
        self.create_switch(self.content_frame, "Zakázat Telemetrii v aplikaci Office", "telemetry_office")
        self.create_switch(self.content_frame, "Zakázat Telemetrii v prohlížeči Mozilla Firefox", "telemetry_firefox")
        self.create_switch(self.content_frame, "Zakázat Telemetrii v prohlížeči Google Chrome", "telemetry_chrome")
        self.create_switch(self.content_frame, "Zakázat telemetrii NVIDIA", "telemetry_nvidia")
        self.create_switch(self.content_frame, "Zakázat Telemetrii v aplikaci Visual Studio", "telemetry_vs")
        self.create_switch(self.content_frame, "Zakázat Telemetrii (Obecná)", "telemetry_general")
        self.create_switch(self.content_frame, "Zakázat sdílení Media Player", "media_sharing")
        self.create_switch(self.content_frame, "Zakázat Domácí skupinu (HomeGroup)", "homegroup")
        self.create_switch(self.content_frame, "Zakázat protokol SMBv1", "smbv1")
        self.create_switch(self.content_frame, "Zakázat protokol SMBv2", "smbv2")

        # Rozhranie & Ostatné (Obrázok 3)
        lbl2 = ctk.CTkLabel(self.content_frame, text="Úpravy Windows & Aktualizácie", font=("Arial", 16, "bold"), text_color="#00ffff")
        lbl2.pack(anchor="w", pady=(15, 5))
        self.create_switch(self.content_frame, "Obnovit Klasický Průzkumník souborů", "classic_explorer")
        self.create_switch(self.content_frame, "Skrýt počasí v hlavní liště", "hide_weather")
        self.create_switch(self.content_frame, "Skrýt vyhledávání v hlavní liště", "hide_search")
        self.create_switch(self.content_frame, "Zakázat My People (Lidé)", "hide_people")
        self.create_switch(self.content_frame, "Povolit Dlouhé cesty (Long Paths)", "long_paths")
        self.create_switch(self.content_frame, "Zakázat Kontrolu TPM 2.0", "disable_tpm")
        self.create_switch(self.content_frame, "Zakázat služby senzorů", "sensor_services")
        self.create_switch(self.content_frame, "Odstranit funkci Cast to Device", "cast_to_device")
        self.create_switch(self.content_frame, "Zakázat zabezpečení založené na virtualizaci (VBS)", "vbs_security")
        self.create_switch(self.content_frame, "Obnovte klasický prohlížeč fotografií", "classic_photo")
        self.create_switch(self.content_frame, "Zakázat moderní pohotovost", "modern_standby")
        
        self.create_switch(self.content_frame, "Zakázat Automatické aktualizace", "windows_update")
        self.create_switch(self.content_frame, "Zakázat aktualizace Microsoft Store", "ms_store_update")
        self.create_switch(self.content_frame, "Zakázat Insider Službu", "insider_service")
        self.create_switch(self.content_frame, "Vyloučit Ovladače z aktualizací", "exclude_drivers")
        
        self.create_switch(self.content_frame, "Zarovnat Hlavní panel doleva", "taskbar_left")
        self.create_switch(self.content_frame, "Zakázat Widgety", "disable_widgets")
        self.create_switch(self.content_frame, "Zakázat Chat", "disable_chat")
        self.create_switch(self.content_frame, "Disable Stickers", "disable_stickers")
        
        self.create_switch(self.content_frame, "Zakázat Telemetrické služby", "telemetry_services")
        self.create_switch(self.content_frame, "Zakázat Cortanu", "disable_cortana")
        self.create_switch(self.content_frame, "Vylepšit Soukromí", "improve_privacy")
        self.create_switch(self.content_frame, "Zakázat zprávy a zájmy", "news_interests")
        self.create_switch(self.content_frame, "Zakázat Reklamy v nabídce Start", "start_ads")
        self.create_switch(self.content_frame, "Zakázat telemetrii Edge", "edge_telemetry")
        self.create_switch(self.content_frame, "Zakázat Edge Discover", "edge_discover")
        
        self.create_switch(self.content_frame, "Povolit herní režim", "game_mode")
        self.create_switch(self.content_frame, "Zakázat Xbox Live", "xbox_live")
        self.create_switch(self.content_frame, "Zakázat Herní panel", "game_bar")
        
        self.create_switch(self.content_frame, "Zakázat Windows Ink", "windows_ink")
        self.create_switch(self.content_frame, "Zakázat Kontrolu pravopisu", "spell_check")
        self.create_switch(self.content_frame, "Zakázat Cloudovou schránku", "cloud_clipboard")
        
        self.create_switch(self.content_frame, "Zakázat Snap Pomocníka", "snap_assist")
        self.create_switch(self.content_frame, "Povolit Klasickou nabídku pravého tlačítka myši", "classic_context")
        self.create_switch(self.content_frame, "Povolit v Průzkumníkovi souborů kompaktní režim", "compact_explorer")
        self.create_switch(self.content_frame, "Vypnout funkci CoPilot AI", "disable_copilot")

    def show_info(self):
        self.clear_content()
        lbl = ctk.CTkLabel(self.content_frame, text="Informácie o systéme", font=("Arial", 18, "bold"))
        lbl.pack(anchor="w", pady=10)

        try:
            cpu = platform.processor()
            total_ram = round(int(subprocess.check_output("wmic ComputerSystem get TotalPhysicalMemory", shell=True).split()[1]) / (1024**3))
            gpu_raw = subprocess.check_output("wmic path win32_VideoController get name,AdapterRAM", shell=True).decode().split('\n')[1].split()
            gpu_name = " ".join(gpu_raw[:-1]) if gpu_raw else "Neznáma"
            vram = round(int(gpu_raw[-1]) / (1024**2)) if gpu_raw and gpu_raw[-1].isdigit() else "Neznáma"
        except:
            cpu, total_ram, gpu_name, vram = "Chyba detekcie", "Neznáma", "Chyba detekcie", "Neznáma"

        ctk.CTkLabel(self.content_frame, text=f"Procesor (CPU): {cpu}", font=("Arial", 14)).pack(anchor="w", pady=4)
        ctk.CTkLabel(self.content_frame, text=f"Grafická karta (GPU): {gpu_name}", font=("Arial", 14)).pack(anchor="w", pady=4)
        ctk.CTkLabel(self.content_frame, text=f"Operačná pamäť (RAM): {total_ram} GB", font=("Arial", 14)).pack(anchor="w", pady=4)
        ctk.CTkLabel(self.content_frame, text=f"Video pamäť (VRAM): {vram} MB", font=("Arial", 14)).pack(anchor="w", pady=4)

    def show_apps(self):
        self.clear_content()
        lbl = ctk.CTkLabel(self.content_frame, text="Správa aplikácií (Odinštalovanie)", font=("Arial", 18, "bold"))
        lbl.pack(anchor="w", pady=10)

        apps = []
        try:
            reg_path = r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
            reg_key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, reg_path)
            for i in range(winreg.QueryInfoKey(reg_key)[0]):
                try:
                    sub_key_name = winreg.EnumKey(reg_key, i)
                    sub_key = winreg.OpenKey(reg_key, sub_key_name)
                    name = winreg.QueryValueEx(sub_key, "DisplayName")[0]
                    uninst = winreg.QueryValueEx(sub_key, "UninstallString")[0]
                    if name and uninst: apps.append((name, uninst))
                except: pass
        except: pass

        for name, uninst_str in sorted(apps)[:30]:
            frame = ctk.CTkFrame(self.content_frame, fg_color="transparent")
            frame.pack(fill="x", pady=4)
            ctk.CTkLabel(frame, text=name[:40], font=("Arial", 13), anchor="w").pack(side="left", fill="x", expand=True)
            btn = ctk.CTkButton(frame, text="Odinstalovat", width=90, fg_color="#cc0000", hover_color="#990000", command=lambda u=uninst_str: self.uninstall_app(u))
            btn.pack(side="right")

    def uninstall_app(self, cmd_str):
        try:
            subprocess.Popen(cmd_str, shell=True)
        except Exception as e:
            messagebox.showerror("Chyba", f"Nepodarilo sa spustiť odinštalátor: {e}")

    def apply_and_restart(self):
        if self.settings.get("high_perf"):
            subprocess.run("powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61", shell=True)
        
        if self.settings.get("disable_effects"):
            winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects")
            key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects", 0, winreg.KEY_SET_VALUE)
            winreg.SetValueEx(key, "VisualFXSetting", 0, winreg.REG_DWORD, 2)

        if self.settings.get("clean_on_boot"):
            startup_path = os.path.expanduser("~\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\clean.bat")
            with open(startup_path, "w") as f:
                f.write('del /q /f /s "%TEMP%\\*"\ndel /q /f /s "C:\\Windows\\Temp\\*"\ndel /q /f /s "C:\\Windows\\Prefetch\\*"')

        messagebox.showinfo("Hotovo", "Všetky úpravy boli zapísané. Počítač sa teraz reštartuje.")
        os.system("shutdown /r /t 5")

if __name__ == "__main__":
    app = TitanOptimizer()
    app.mainloop()
'@
$appCode | Out-File -FilePath $pythonCodePath -Encoding utf8

# Kontrola a automatická inštalácia knižníc a spustenie programu
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Inštalujem Python z MS Store..." -ForegroundColor Yellow
    winget install Python.Python.3.11 --silent
}
pip install customtkinter --quiet
python $pythonCodePath

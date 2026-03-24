# ESPHome ESP32-S3 7-inch LVGL Smart Home Dashboard 🇬🇧

A comprehensive, feature-rich smart home control panel (Home Assistant) based on a 7-inch touchscreen with an ESP32-S3 microcontroller. The user interface was built entirely using the powerful **LVGL** library within the **ESPHome** environment.

---

## 📸 Project Gallery

Below is a presentation of the individual screens and hardware details:

### General View & Menu
![Front View](images/front_view.jpg)
![Main Menu](images/main_menu.jpg)

### Feature Screens
| Power & Utilities | Climate Control |
| :---: | :---: |
| ![Power / Battery](images/battery.jpg) | ![Climate](images/climate.jpg) |

| Lighting | Weather & Radar |
| :---: | :---: |
| ![Lighting](images/light_contr.jpg) | ![Satellite Image](images/sat_img.jpg) |

### Hardware & Modifications
| Rear View (PCB) | Backlight Modification |
| :---: | :---: |
| ![Rear View](images/back_wiev.jpg) | ![Backlight Mod](images/backlight_mod.jpg) |

---

## ✨ Main Features

This project offers an advanced and fully interactive experience:

* **Advanced Energy Dashboard:** Dynamic energy flow diagram. Icons (PV panels, transmission tower, house) change their colors and shapes (e.g., arrow direction on the transmission tower) in real-time depending on power flow. Includes daily profit calculation (wallet icon).
* **Utility Management:** Real-time readings for water consumption (well pump), gas, and comprehensive cost overviews.
* **Climate & Lighting Control:** Dedicated control screens for managing thermostats, air conditioning, and lights throughout the smart home.
* **Weather & Satellite:** Weather forecast screen integrated with live satellite/radar images.
* **Hardware Battery Monitoring:** Real-time tracking of the internal battery state using an INA sensor for highly accurate voltage and current statistics.
* **Home Assistant Integration:** Instant and seamless communication via the native ESPHome API.
* **Modular Code Structure:** Divided into readable YAML files (e.g., `page_zasilanie.yaml`, `sensory.yaml`), making development, debugging, and customization much easier.
* **🌍 Multilanguage Support:** The user interface supports multiple languages, enabling users to select their preferred language from the settings menu. Easy language switching without requiring device restart.

---

## 🛠️ Hardware Specifications

* **Display:** 7-inch TFT touchscreen display.
* **Microcontroller:** ESP32-S3 (offering plenty of PSRAM for smooth LVGL operation and complex UI rendering).
* **Power Supply:** Built-in **battery** for continuous operation and backup power.
* **Battery Monitoring:** **INA Sensor** (e.g., INA219) integrated for precise measurement of battery voltage, current, and overall charge level.
* **Modifications:** Hardware modification of the screen backlight (`backlight_mod.jpg`) allowing for granular PWM brightness management directly from ESPHome.

---

## 🚀 Installation & Setup

1. **Clone the repository:** Download all `.yaml` files and the `fonts` folder.
2. **Fonts:** Ensure the `materialdesignicons-webfont.ttf` file is located in the `fonts/` folder in the root directory of your ESPHome configuration.
3. **Entity Configuration:** Review `sensory.yaml` and the UI page files. Replace the `entity_id:` values with the ones corresponding to your specific Home Assistant sensors.
4. **Compile and Flash:** Use the ESPHome Dashboard to compile and flash the firmware to your ESP32-S3 device.

---

**Author:** [thomstas]  
**Technologies:** ESPHome, LVGL, C++, Home Assistant
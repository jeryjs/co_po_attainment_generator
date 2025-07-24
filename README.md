# CO-PO Attainment Generator

<img src="assets\app_icon.webp" width=10%> 

[![Install App](https://img.shields.io/badge/Install-Now-brightgreen)](https://github.com/jeryjs/co_po_attainment_generator/releases/latest)

CO-PO Attainment Generator is a Flutter-based calculator designed to automate the process of generating an Excel sheet for calculating Course Outcome (CO) to Program Outcome (PO) attainment. This application is currently targeted for Windows platform and is in its alpha stage.

## Overview

The purpose of CO-PO Attainment Generator is to streamline the calculation process, reducing manual effort and improving result accuracy. It utilizes various dependencies to provide its functionality, including:

- **file_picker**: For picking files from the file system.
- **google_generative_ai**: For extracting question paper details using Google's Gemini AI.
- **image**: For handling images used in question paper extraction.
- **open_file**: For opening files, particularly generated Excel files.
- **path** and **path_provider**: For handling file paths and common filesystem locations.
- **shared_preferences**: For persisting user data.
- **shimmer**: For adding shimmer effect animation in the UI.
- **msix**: For generating an MSIX installer for Windows platform.

## Preview

<img src="https://i.imgur.com/0dAQfI2.png" width=45.9%><img src="https://i.imgur.com/M4HUzq0.png" width=45.9%><img src="https://i.imgur.com/0gzcXAo.png" width=45.9%>
<img width="45.9%" src="https://github.com/user-attachments/assets/316cc471-4e97-48a6-ba15-19cdde8a6669" /><img width="45.9%" src="https://github.com/user-attachments/assets/eeb0c159-2550-4cfd-b319-83e459f533f2" /><img width="45.9%" src="https://github.com/user-attachments/assets/52b2fcfb-3503-4110-bcce-e664945ea1e4" />


## Usage

To use CO-PO Attainment Generator, follow these steps:

1. Launch CO-PO Generator.
2. Fill in the details.
    - You can optionally import a question paper to analyse and extract its details with Gemini AI.
3. Fill in the Weightages.
4. Click generate!
    - You can optionally import a previously generated file to use it as template.

## Installation

[![Install App](https://img.shields.io/badge/Install-Now-brightgreen)](https://github.com/jeryjs/co_po_attainment_generator/releases/latest/)

To install CO-PO Attainment Generator, follow these steps:

1. Go to the latest [release](https://github.com/jeryjs/co_po_attainment_generator/releases/latest) or visit the [releases page](https://github.com/jeryjs/co_po_attainment_generator/releases).

2. Download the `co-po-generator-setup.exe` from 'Assets'.
    - Optionally, you can instead download the msix version, however that requires that you manually trust its certificate.

3. Double-click on the downloaded `.exe` file to start the installation process. You may see a security warning, but you can safely proceed with the installation.

4. Follow the on-screen instructions to complete the installation. Choose the installation location and agree to the terms and conditions.

5. After the installation is finished, you should see a shortcut for CO-PO Attainment Generator on your desktop or in the Start menu.

6. Double-click on the shortcut to launch CO-PO Attainment Generator.

That's it! You have successfully installed CO-PO Attainment Generator on your computer.

## Documentation

For more detailed documentation, including API references and usage guidelines, visit [co_po_generator - Dart API docs](https://jeryjs.github.io/co_po_attainment_generator/).

## License

This project is licensed under the [AGPL-3.0 license](LICENSE).


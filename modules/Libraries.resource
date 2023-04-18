*** Settings ***
Documentation
...    En este archivo se importan las librerias que seran usadas
...    a lo largo del proyecto, al crear un archivo de keywords
...    o casos de prueba agregar la referencia a este archivo
...    para poder habilitar todas las funcionalidades de las librerias
...    agregadas
...    | Resource    libraries.resource
...    Si hay librerias personalizadas agregarlas de igual forma en este archivo
...    | Library    MyLibrary.py
...    Las siguientes librerias son estandar de robot framework
...    - Collections
...    - DateTime
...    - Dialogs
...    - OperatingSystem
...    - Process
...    - String
...    Para mas informacion de cada una consulte la siguiente pagina:
...    https://robotframework.org/robotframework/#standard-libraries
...
...    Las siguientes librerias fueron instaladas por el modulo `pip` de python
...    - SeleniumLibrary
...    Para mas informacion consulte:
...    - repositorio: https://github.com/robotframework/SeleniumLibrary
...    - documentacion: https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html

Library    Collections
Library    DateTime
Library    Dialogs
Library    OperatingSystem
Library    Process
Library    String
Library   SeleniumLibrary
...    timeout=30 minutes
...    run_on_failure=${None}
...    screenshot_root_directory=..\\reports
Library    ../libraries/Evidence.py

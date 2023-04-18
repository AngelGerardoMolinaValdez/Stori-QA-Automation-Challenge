*** Settings ***
Documentation
...    Funciones que pueden ser utilizadas en cualquier escenario
...    o que permiten simplificar una tarea.

Keyword Tags
...    util
...    reusable

Resource    Libraries.resource


*** Variables ***
${DEFAULT_URL}    https://rahulshettyacademy.com/AutomationPractice/
${DEFAULT_BROWSER}    chrome


*** Keywords ***
Abrir Navegador Y Establecer Velocidad
    [Documentation]
    ...    Abre el navegador en la url especificada
    ...    y tambien asigna la velocidad de ejecucion
    ...    por keyword de selenium, es decir que intervalo
    ...    de tiempo tardara en ejecutar una keyword despues de otra
    ...    (unicamente de selenium)
    ...    Ejemplo:
    ...    Si necesitamos dar clic en un boton y posteriomente ingresar
    ...    datos en un elemento input, para esperar entre una accion y
    ...    otra podemos modificarlo con una funcion de la misma libreria de
    ...    SeleniumLibrary
    ...
    ...    Si son ingresadas por consola las variables "url" y "browser"
    ...    por consola (argumento: --variable varname:varvalue) entonces
    ...    estos datos seran tomados para la ejecucion caso contrario
    ...    seran los valores por default definidos en la seccion de
    ...    variables de este archivo.
    [Tags]
    ...    test_setup
    ${INPUT_URL}    Get Variable Value    ${url}
    ${INPUT_BROWSER}    Get Variable Value    ${browser}

    ${EXECUTION_URL}    Set Variable If
    ...    "${INPUT_URL}" == "${None}"    ${DEFAULT_URL}    ${INPUT_URL}

    ${EXECUTION_BROWSER}    Set Variable If
    ...    "${INPUT_BROWSER}" == "${None}"    ${DEFAULT_BROWSER}    ${INPUT_BROWSER}

    Open Browser    ${EXECUTION_URL}    ${EXECUTION_BROWSER}
    Maximize Browser Window

    Set Selenium Speed    0.1 seconds

Terminar Sesion
    [Documentation]
    ...    Esta keyword se ejecuta al terminar un caso de prueba,
    ...    esto nos permite visualizar el estatus final, dicho estatus
    ...    se agrega a la cola de ejecuciones de la suite, esto permite
    ...    al final validar el estatus de todos los casos en la suite,
    ...    este dato se encuentra guardado en la variable \${SUITE STATUS}.
    ...
    ...    Esta keyword cerraba el navegador solo si el estatus de final
    ...    de la suite no es "PASS" caso contrario se mantendra abierto 
    ...    Se ha comentado la primer condicional para que permita cerrar
    ...    el navegador al terminar la ejecucion.
    [Tags]
    ...    test_teardown
    # IF  "${SUITE STATUS}" != "PASS"    RETURN
    Close All Browsers

Esperar Nueva Ventana Y Seleccionarla
    [Documentation]
    ...    Espera que aparezca una nueva ventana del navegador y la
    ...    selecciona
    ...    El parametro especificado indica el indice de la ventana (contando a partir de 0)
    ...    que se debera seleccionar cuando aparezca
    [Tags]
    ...    wait
    ...    window
    [Arguments]    ${num_ventana}
    WHILE   ${True}
        @{windows}    Get Window Handles
        ${len_windows}    Get Length    ${windows}
        IF    ${len_windows} < ${num_ventana}    CONTINUE
        Switch Window    ${windows}[${num_ventana}]
        BREAK
    END

Ingresar Texto Y Seleccionar Coincidencia
    [Documentation]
    ...    Ingresa texto especificado en un elemento <input>
    ...    espera que aparezcan opciones disponibles y selecciona
    ...    el texto que se espera encontrar
    ...
    ...    Ejemplo:
    ...    | Seleccionar Texto En DropdownList    //input[@id="saludos"]    Hola    Hola Mundo!
    [Tags]
    ...    dropdown_list
    ...    selection
    [Arguments]    ${input_element}    ${busqueda}    ${seleccion}
    ${dropdown_elements_xpath}    Set Variable
    ...    //ul[contains(@class, "ui-autocomplete") and not(contains(@style, "none;"))]
    ${dropdown_element_seleccion}    Catenate    SEPARATOR=
    ...    ${dropdown_elements_xpath}//li
    ...    //div[contains(text(), "${seleccion}")]

    Input Text    ${input_element}    ${busqueda}

    Wait Until Element Is Visible    ${dropdown_elements_xpath}
    
    Comment
    ...    Se utiliza javascript para hacer clic al elemento incluso si no estan visible
    ...    Si el elemento no existe entonces fallara la ejecucion
    ${dropdown_element_seleccion_ref}    Get Web Element
    ...    ${dropdown_element_seleccion}
    Execute Javascript
    ...    arguments[0].click();
    ...    ARGUMENTS    ${dropdown_element_seleccion_ref}

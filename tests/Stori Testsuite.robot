*** Settings ***
Documentation
...    Casos de prueba automatizados
...    para entrevista tecnica de la empresa `Stori Card`
...
...    Las Keywords(funciones) de todos los ejercicios se encuentran
...    en la carpeta \${base}/modules
...
...    Las librerias usadas en el proyecto fueron separadas en un archivo
...    para reducir centralizar todas las librerias y mantener un orden.
...    La ruta de las librerias es:
...    - \${base}/modules/Libraries.resource
...
...    Los archivos de keywords usados en este proyecto se alojaron en
...    la siguiente ruta:
...    - \${base}/modules/Resources.resource

Metadata    robot    6.0.2
Metadata    python    3.9
Metadata    chrome    111
Metadata    os    windows

Test Tags    stori_test

Resource    ../modules/Libraries.resource
Resource    ../modules/Resources.resource

Suite Setup    Abrir Navegador Y Establecer Velocidad
Suite Teardown    Terminar Sesion

Test Setup
...    Crear Reporte    ${TEST NAME}
Test Teardown    Terminar Reporte


*** Test Cases ***
Test Ingresar Texto En Elemento De Sugerencia
    [Documentation]
    ...    Ingresara en la pagina y se introducira
    ...    el texto "Me" en el elemento web y debera
    ...    escoger la opcion "Mexico"
    ...
    ...    Descripcion original del problema:
    ...    - In the Suggestion Class Example, enter the word “Me” and select Mexico.
    ...    (Bonus: use only xpath)
    [Tags]
    ...    exercise_1
    ${input_autocomplete}    Set Variable
    ...    //input[@id="autocomplete" and contains(@placeholder, "Countries")]
    ${busqueda}    Set Variable    Me
    ${seleccion}    Set Variable    Mexico

    Wait Until Element Is Visible    ${input_autocomplete}
    Wait Until Element Is Enabled    ${input_autocomplete}

    Ingresar Texto Y Seleccionar Coincidencia    ${input_autocomplete}    ${busqueda}    ${seleccion}

    Agregar A Reporte
    ...    descripcion=Se ingresa Me en el elemento web
    ...    web_element=${input_autocomplete}

Test Seleccionar Valores En Dropdown
    [Documentation]
    ...    Ingresara en la pagina y seran seleccionados
    ...    los elementos Option1 y Option2 del elemento dropdown list
    ...
    ...    Descripcion original del problema:
    ...    - In the Dropdown Example, select option 2 and then option 3. The user should be able to
    ...    see the change.
    ...    (Bonus: use only xpath without using ids, text or values)
    [Tags]
    ...    exercise_2
    ${select_numeros}    Set Variable    //select[@id="dropdown-class-example"]

    Wait Until Element Is Visible    ${select_numeros}
    Wait Until Element Is Enabled    ${select_numeros}

    Select From List By Label    ${select_numeros}    Option1

    Agregar A Reporte
    ...    descripcion=Se ha seleccionado el valor Option1
    ...    web_element=${select_numeros}

    Sleep    2 seconds

    Select From List By Label    ${select_numeros}    Option2

    Agregar A Reporte
    ...    descripcion=Se ha seleccionado el valor Option2
    ...    web_element=${select_numeros}


Test En Ventana De Ejemplo Existe Texto Indicado
    [Documentation]
    ...    Validara en la nueva ventana que se abrira al hacer clic
    ...    en el boton "Open Window" si existe el texto:
    ...    - "the 30 day money back guarantee text"
    ...
    ...    Descripcion original del problema:
    ...    - In the Switch Window Example, click the Open Window button. If the 30 day money back
    ...    guarantee text (example below) is not shown, fail the test. Close the new window.
    ...    (Bonus: Review the text of SELF PACED ONLINE TRAINING, IN DEPTH MATERIAL,
    ...    LIFETIME INSTRUCTOR SUPPORT and RESUME PREPARATION and find the bugs here and
    ...    document them in the RTM)
    [Tags]
    ...    exercise_3
    ${button_abrir_nueva_ventana}    Set Variable    //button[@id="openwindow"]
    ${link_ver_todos_los_cursos}    Set Variable    //a[@class="main-btn"]
    ${texto_esperado}    Set Variable
    ...    the 30 day money back guarantee text

    Wait Until Element Is Visible    ${button_abrir_nueva_ventana}
    Wait Until Element Is Enabled    ${button_abrir_nueva_ventana}

    Click Button    ${button_abrir_nueva_ventana}

    Esperar Nueva Ventana Y Seleccionarla    ${1}

    Wait Until Element Is Visible    ${link_ver_todos_los_cursos}
    Wait Until Element Is Enabled    ${link_ver_todos_los_cursos}

    Agregar A Reporte
    ...    descripcion=Nueva ventana abierta

    TRY
        Page Should Contain    ${texto_esperado}
        Agregar A Reporte
        ...    descripcion=Texto esperado encontrado
        Esperar Nueva Ventana Y Seleccionarla    ${0}

    EXCEPT
        Agregar A Reporte
        ...    descripcion=No se encontro el texto esperado
        Esperar Nueva Ventana Y Seleccionarla    ${0}
        Fail    No se encontro el texto: ${texto_esperado}

    END

Test Encontrar Boton En Nueva Pagina
    [Documentation]
    ...    Dara clic sobre boton "Open Tab" y validara que exista
    ...    el boton con el texto "VIEW ALL COURSES" en caso que no
    ...    exista fallara el caso de prueba.
    ...    Descripcion original del problema:
    ...    - In the Switch Tab Example, click the Open Tab button. Scroll on the new tab until you
    ...    see the button below. Then take a screenshot that includes the button and save it with
    ...    the name of the test case that you gave in the RTM. Don't close the window. Return to
    ...    the first window. (Bonus: use xpath and css selector)
    [Tags]
    ...    exercise_3
    ${link_abrir_pestania}    Set Variable    //a[@id="opentab"]
    ${link_ver_todos_los_cursos}    Set Variable    //a[@class="main-btn"]
    ${button_ver_todos_los_cursos}    Set Variable
    ...    //button[@contains(text(), "VIEW ALL COURSES")]

    Esperar Nueva Ventana Y Seleccionarla    ${0}

    Wait Until Element Is Visible    ${link_abrir_pestania}
    Wait Until Element Is Enabled    ${link_abrir_pestania}

    Click Link    ${link_abrir_pestania}

    Esperar Nueva Ventana Y Seleccionarla    ${1}

    Wait Until Element Is Visible    ${link_ver_todos_los_cursos}
    Wait Until Element Is Enabled    ${link_ver_todos_los_cursos}

    Agregar A Reporte
    ...    descripcion=Nueva pestania abierta correctamente

    TRY
        Page Should Contain Button    ${button_ver_todos_los_cursos}    10 seconds

        Scroll Element Into View    ${button_ver_todos_los_cursos}

        Agregar A Reporte
        ...    descripcion=Boton ver todos los cursos encontrado
        ...    web_element=${button_ver_todos_los_cursos}


    EXCEPT
        Agregar A Reporte
        ...    descripcion=Boton ver todos los cursos no encontrado

        Esperar Nueva Ventana Y Seleccionarla    ${0}

        Fail    No se encontro el boton para ver todos los cursos

    END

Test Obtener Texto De Un Alert
    [Documentation]
    ...    Se ingresara el texto "Stori Card" y se dara clic en boton con texto
    ...
    ...    Descripcion original del problema:
    ...    In the Switch To Alert Example, type this string “Stori Card” and click the Alert button.
    ...    Print the text in the alert and click on OK. Then type the same string and click on the
    ...    Confirm button and print the text. Make sure that the string shown equals this “Hello
    ...    Stori Card, Are you sure you want to confirm?” then click on OK.
    ...    (Bonus: use xpath and css selector)

    [Tags]
    ...    exercise_4
    ${input_nombre}    Set Variable    css:[name="enter-name"]
    ${button_alerta}    Set Variable    alertbtn
    ${button_confirmar}    Set Variable    id:confirmbtn
    ${nombre}    Set Variable    Stori Card
    ${texto_esperado}    Set Variable
    ...    Hello Stori Card, Are you sure you want to confirm?

    Esperar Nueva Ventana Y Seleccionarla    ${0}

    Wait Until Element Is Visible    ${input_nombre}
    Wait Until Element Is Enabled    ${input_nombre}

    Input Text    ${input_nombre}    ${nombre}
    Agregar A Reporte
    ...    descripcion=nombre ingresado
    ...    web_element=${input_nombre}

    Click Button    ${button_alerta}

    Handle Alert    timeout=2 seconds
    Agregar A Reporte
    ...    descripcion=Alerta mostrada

    Input Text    ${input_nombre}    ${nombre}

    Click Button    ${button_confirmar}

    ${mensaje_de_confirmacion}    Handle Alert    timeout=2 seconds
    Agregar A Reporte
    ...    descripcion=Mensaje de confirmacion

    Should Be Equal    ${mensaje_de_confirmacion}    ${texto_esperado}


Test Obtener Los Cursos Con Costo Especifico
    [Documentation]
    ...    En la tabla "Web Table Examples" se deberan buscar todos los cursos
    ...    que el costo sea de $25 y de esa concidencia se imprimira el nombre
    ...    del curso
    ...
    ...    Descripcion original del problema:
    ...    - In the Web Table Example, print the number of courses that are $25. Then print their
    ...    course names.
    ...    (Bonus: use only the css selector child to parent)
    [Tags]
    ...    exercise_5
    ${costo_de_curso}    Set Variable    ${25}
    ${table_cursos}    Set Variable    //table[@name="courses"]
    ${xpath_cursos_con_costo_indicado}    Catenate    SEPARATOR=
    ...    ${table_cursos}//tbody//tr
    ...    //td[text() = ${costo_de_curso}]//..//td[2]

    Wait Until Element Is Visible    ${table_cursos}
    Wait Until Element Is Enabled    ${table_cursos}

    Scroll Element Into View    ${table_cursos}
    Agregar A Reporte
    ...    descripcion=Tabla de cursos
    ...    web_element=${table_cursos}

    @{cursos}    Get WebElements    ${xpath_cursos_con_costo_indicado}

    FOR    ${curso}    IN    @{cursos}
        ${nombre_curso}    Get Text    ${curso}
        Log To Console    Encontrado::${nombre_curso}
    END

Test Imprimir Nombre De Ingenieros
    [Documentation]
    ...    En la tabla "Web Table Fixed header" se obtendra la columna
    ...    "Name" y se imprimira los textos obtenidos
    ...
    ...    Descripcion original del problema:
    ...    - Print the names of all the Engineers in the Web Table Fixed header.
    ...    (Bonus: use xpath and css selector child to parent)
    [Tags]
    ...    exercise_6
    ${table_datos_usuarios}    Set Variable    //div[@class="tableFixHead"]//table
    ${row_nombre_usuarios}    Catenate    SEPARATOR=
    ...    ${table_datos_usuarios}//table//td[1]

    @{datos_de_usuarios}    Get WebElements    ${row_nombre_usuarios}
    Agregar A Reporte
    ...    descripcion=Tabla de datos de usuario
    ...    web_element=${table_datos_usuarios}

    FOR    ${informacion_de_usuario}    IN    @{datos_de_usuarios}
        ${nombre_usuario}    Get Text    ${informacion_de_usuario}
        Log To Console    Nombre::${nombre_usuario}
    END

Test Obtener Texto Resaltado
    [Documentation]
    ...    Obtener el texto resaltado
    ...
    ...    Descripcion original del problema:
    ...    - In the iFrame example, get the text highlighted in blue in the following image and print it.
    ...    (Bonus: use xpath and print only the odd indexes)
    [Tags]
    ...    exercise_6
    ${frame_informacion_cursos}    Set Variable    //iframe[@id="courses-iframe"]
    ${sugerencia_de_busqueda}    Set Variable    testing community
    ${li_texto_solicitado}    Set Variable    //li[contains(text(), "${sugerencia_de_busqueda}")]

    Select Frame    ${frame_informacion_cursos}
    
    Scroll Element Into View    ${li_texto_solicitado}

    ${texto_solicitado}    Get Text    ${li_texto_solicitado}
    Agregar A Reporte
    ...    descripcion=Texto obtenido
    ...    web_element=${li_texto_solicitado}

    Log To Console    Obtenido::${texto_solicitado}

    UnSelect Frame

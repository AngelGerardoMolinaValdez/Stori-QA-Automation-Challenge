import os
import datetime
import shutil
import glob
import asyncio
from robot.libraries.BuiltIn import BuiltIn


class Evidence:
    """Evidence
    Es una libreria que permite generar una carpeta para guardar
    capturas de pantalla del paso a paso de la ejecucion, al finalizar
    guardara las captura en la carpeta generada.

    Consideraciones:
    - Se genera una carpeta por cada caso de prueba
    - Al guardar una captura, no utilizar caracteres especiales ya que ese texto es tomado como el nombre de la imagen y podria generar un error
    - Las imagenes se guardaran en la carpeta reports y al finalizar el flujo se movera a la carpeta de ejecucion correspondiente.
    """

    def __init__(self) -> None:
        """configuracion inicial

        genera la ruta absoluta de la carpeta base del proyecto, tambien genera
        la ruta absoluta de la carpeta reports
        """
        self.robot_builtin = BuiltIn()

        self.base_dir = os.path.abspath(
            os.path.join(
            os.path.dirname(__file__), "..")
        )
        self.reports_dir = os.path.join(self.base_dir, "reports")

        if os.path.exists(self.reports_dir):
            return

        os.mkdir(self.reports_dir)

    def crear_reporte(self, testname : str) -> None:
        """Genera la estructura para guardar datos del reporte

        Se genera el nombre de la carpeta donde se guardaran las imagenes
        segun el nombre del caso de prueba ejecutado, creara dicha carpeta
        y al mismo nombre agreara la fecha y hora para evitar carpetas duplicadas

        Args:
            testname (str): el nombre del caso de prueba
        """
        nombre_reporte = testname
        nombre_reporte = nombre_reporte.replace("-", "_").replace(" ", "_")

        fecha_actual = datetime.datetime.now()
        fecha_formateada = fecha_actual.strftime('%d-%m-%Y %H:%M:%S')
        fecha_reporte = str(fecha_formateada).replace("-", "_").replace(" ", "_").replace(":", "_")

        nombre_execution_folder = nombre_reporte + fecha_reporte
        self.execution_report_folder = os.path.join(
            self.reports_dir, nombre_execution_folder)
    
        os.makedirs(self.execution_report_folder)


    def terminar_reporte(self) -> None:
        """guarda las imagenes en la carpeta del reporte

        Las imagenes se guardan en la carpeta reports/ al invocar
        este metodo las movera a la carpeta creada para los datos
        de la ejecucion.
        """
        pattern_png_files = os.path.join(self.reports_dir, "*.png")
        matches = glob.glob(pattern_png_files)

        for match in matches:
            shutil.move(match, self.execution_report_folder)

    def agregar_a_reporte(self, descripcion : str = None, web_element : str = None) -> None:
        """Guarda una captura de pantalla con la descripcion indicada

        Args:
            descripcion (str, optional): la informacion de la captura. Defaults to None.
            web_element (str, optional): el xpath o identificador del elemento que sera captura. Defaults to None.
        """
        info_captura = []

        if web_element is None:
            info_captura.append("seleniumlibrary.Capture Page Screenshot")

            if descripcion is not None:
                info_captura.append(str(descripcion) + ".png")

            self.robot_builtin.run_keyword(*info_captura)

            return
    
        info_captura.append("seleniumlibrary.Capture Element Screenshot")
        info_captura.append(web_element)

        if descripcion is not None:
            info_captura.append(str(descripcion) + ".png")

        self.robot_builtin.run_keyword(*info_captura)

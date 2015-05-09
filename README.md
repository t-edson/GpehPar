# GpehPar
Analizador de archivos binarios GPEH (Simple Pascal Gpeh parser)

Este programa es un analizador de archivos binarios GPEH. Explora el contenido binario y lo convierte a texto. Realiza un procesamiento básico, pero puede servir de base para crear analizadores más complejos. 

Solo decodifica los encabezados de los eventos, no los parámetros. 

Está codificado usando el lenguaje Object Pascal y el entorno de desarrollo Lazarus. Es una aplicación de consola con línea de comandos. Los comandos que soporta son:

-e<evento>, para filtrar un solo evento.

-s, para mostrar los eventos de forma simplificada (Solo el nombre).

Considerar que los archivos bin, contienen información comprimida y al expandirse se multiplica el tamaño de los datos generados.

Un ejemplo de datos generados es este:

```

ScannerID:1
 3:15:04,
EventID=129 - NBAP_RADIO_LINK_SETUP_RESPONSE
UEcontextID=3650,rncModuleId=0,
cellID1=2,1930
cellID2=114719,15359
cellID3=260095,8191
cellID4=261631,8191
ScannerID:1
20:45:00,

EventID=129 - NBAP_RADIO_LINK_SETUP_RESPONSE
UEcontextID=1998,rncModuleId=0,
cellID1=2,1933
cellID2=131103,15359
cellID3=260095,8191
cellID4=261631,8191
ScannerID:1
20:45:00,

EventID=129 - NBAP_RADIO_LINK_SETUP_RESPONSE
UEcontextID=145,rncModuleId=0,
cellID1=2,1260
cellID2=114719,2355
cellID3=16415,8191
cellID4=261631,8191
ScannerID:1
20:45:00,
```


IMPORTANTE: El programa, aún no está verificado lo suficiente, por lo tanto no se garantiza la veracidad de los datos generados.

HOW TO
===

1. docker run -d -p <puerto>:8080 -v <carpeta de comics>:/comics --name=yacserver muallin/yacreaderlibrary:8.5.0
2. docker exec yacserver YACReaderLibraryServer create-library <nombre de libreria> /comics

